//
//  TAView.m
//  UCSDMe
//
//  Created by Sean Hamilton on 1/22/14.
//  Copyright (c) 2014 Sean Hamilton. All rights reserved.
//

#import "TAFirstPersonView.h"
#import "TAAppDelegate.h"
#import "TARadarView.h"
#import "UIColor+TAColor.h"

#import <AVFoundation/AVFoundation.h>

#pragma mark -
#pragma mark Math utilities declaration

#define DEGREES_TO_RADIANS (M_PI/180.0)

typedef float mat4f_t[16];	// 4x4 matrix in column major order
typedef float vec4f_t[4];	// 4D vector

// Creates a projection matrix using the given y-axis field-of-view,
// aspect ratio, and near and far clipping planes
void createProjectionMatrix(mat4f_t mout, float fovy, float aspect,
                            float zNear, float zFar);
void createOrientationMatrix(mat4f_t mout, float theta);

// Matrix-vector and matrix-matricx multiplication routines
void multiplyMatrixAndVector(vec4f_t vout, const mat4f_t m, const vec4f_t v);
void multiplyMatrixAndMatrix(mat4f_t c, const mat4f_t a, const mat4f_t b);

// Initialize mout to be an affine transform corresponding
// to the same rotation specified by m
void transformFromCMRotationMatrix(mat4f_t mout, const CMRotationMatrix *m);

#pragma mark - Geodetic utilities declaration

#define WGS84_A	(6378137.0)				// WGS 84 semi-major axis constant in meters
#define WGS84_E (8.1819190842622e-2)	// WGS 84 eccentricity

// Converts latitude, longitude to ECEF coordinate system
void latLonToEcef(double lat, double lon, double alt,
                  double *x, double *y, double *z);

// Coverts ECEF to ENU coordinates centered at given lat, lon
void ecefToEnu(double lat, double lon, double x, double y, double z, double xr,
               double yr, double zr, double *e, double *n, double *u);

#pragma mark - TAView extension

@interface TAFirstPersonView ()
{
	AVCaptureSession *captureSession;
	AVCaptureVideoPreviewLayer *captureLayer;
	CADisplayLink *displayLink;
	CMMotionManager *motionManager;
	CLLocationManager *locationManager;
	CLLocation *location;
  CLLocationAccuracy accuracy;
  UIDeviceOrientation currentOrientation;
  UILabel *accLabel;
  TARadarView *radar;
  float rotationOffset;
	mat4f_t projectionTransform;
	mat4f_t cameraTransform;
  mat4f_t orientationTransform;
	vec4f_t *placesOfInterestCoordinates;
}

@end

#pragma mark - TAView implementation

@implementation TAFirstPersonView

#pragma mark - First Person View Methods

- (void)start
{
	[self startCameraPreview];
	[self startLocation];
	[self startDeviceMotion];
	[self startDisplayLink];
  
  radar.center = CGPointMake(self.bounds.size.width - radar.bounds.size.width/2 - 5,
                             self.bounds.size.height - radar.bounds.size.height/2 - [_delegate bottomViewOffset] - 5);
  
  UIInterfaceOrientation orientation=[[UIApplication sharedApplication] statusBarOrientation];
  switch (orientation)
  {
    case UIInterfaceOrientationLandscapeRight:
    {
      [[captureLayer connection] setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
      rotationOffset = M_PI_2;
      currentOrientation = UIDeviceOrientationLandscapeLeft;
      break;
    }
    case UIInterfaceOrientationLandscapeLeft:
    {
      [[captureLayer connection] setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
      rotationOffset = -M_PI_2;
      currentOrientation = UIDeviceOrientationLandscapeRight;
      break;
    }
    case UIInterfaceOrientationPortrait:
    {
      [[captureLayer connection] setVideoOrientation:AVCaptureVideoOrientationPortrait];
      rotationOffset = 0.0;
      currentOrientation = UIDeviceOrientationPortrait;
      break;
    }
    default:
      return;
  }
  
  // make orientationTransform changes
  createOrientationMatrix(orientationTransform, rotationOffset);
}

- (void)stop
{
	[self stopCameraPreview];
	[self stopLocation];
	[self stopDeviceMotion];
	[self stopDisplayLink];
}

- (CLLocation *)location
{
  return location;
}

- (void)startCameraPreview
{
	AVCaptureDevice* camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	if (camera == nil)
  {
		return;
	}
	
	captureSession = [[AVCaptureSession alloc] init];
	AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:nil];
	[captureSession addInput:newVideoInput];
	
	captureLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
	captureLayer.frame = self.bounds;
	[captureLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
	[self.layer addSublayer:captureLayer];
  [self bringSubviewToFront:accLabel];
  
	// Start the session. This is done asychronously since -startRunning doesn't return until the session is running.
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[captureSession startRunning];
	});
}

- (void)stopCameraPreview
{
	[captureSession stopRunning];
	[captureLayer removeFromSuperlayer];
	captureSession = nil;
	captureLayer = nil;
}

- (void)startLocation
{
  locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
  locationManager.distanceFilter = 10;
  locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
	[locationManager startUpdatingLocation];
  [locationManager startUpdatingHeading];
}

- (void)stopLocation
{
	[locationManager stopUpdatingLocation];
  [locationManager stopUpdatingHeading];
	locationManager = nil;
}

- (void)startDeviceMotion
{
	motionManager = [[CMMotionManager alloc] init];
	
	// Tell CoreMotion to show the compass calibration HUD when required to provide true north-referenced attitude
	motionManager.showsDeviceMovementDisplay = YES;
	
	motionManager.deviceMotionUpdateInterval = 1.0 / 60.0;
	
	// New in iOS 5.0: Attitude that is referenced to true north
	[motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical];
}

- (void)stopDeviceMotion
{
	[motionManager stopDeviceMotionUpdates];
	motionManager = nil;
}

- (void)startDisplayLink
{
	displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplayLink:)];
	[displayLink setFrameInterval:1];
	[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopDisplayLink
{
	[displayLink invalidate];
	displayLink = nil;
}

- (void)updatePlacesOfInterestCoordinates
{
	
	if (placesOfInterestCoordinates != NULL)
  {
		free(placesOfInterestCoordinates);
	}
  
  NSArray *placesOfInterest = [_delegate poisForFirstPersonView:self];
	placesOfInterestCoordinates = (vec4f_t *)malloc(sizeof(vec4f_t)*placesOfInterest.count);
  
	int i = 0;
	
	double myX, myY, myZ;
	
  latLonToEcef(location.coordinate.latitude, location.coordinate.longitude, 0.0, &myX, &myY, &myZ);
	// Array of NSData instances, each of which contains a struct with the distance to a POI and the
	// POI's index into placesOfInterest
	// Will be used to ensure proper Z-ordering of UIViews
	typedef struct
  {
		float distance;
		int index;
	} DistanceAndIndex;
	NSMutableArray *orderedDistances = [NSMutableArray arrayWithCapacity:placesOfInterest.count];
  
	// Compute the world coordinates of each place-of-interest
	for (TAPlaceOfInterest *poi in placesOfInterest)
  {
		double poiX, poiY, poiZ, e, n, u;
		
		latLonToEcef(poi.location.coordinate.latitude, poi.location.coordinate.longitude, poi.altitude, &poiX, &poiY, &poiZ);
		ecefToEnu(location.coordinate.latitude, location.coordinate.longitude, myX, myY, myZ, poiX, poiY, poiZ, &e, &n, &u);
		
		placesOfInterestCoordinates[i][0] =  (float)n;
		placesOfInterestCoordinates[i][1] = -(float)e;
		placesOfInterestCoordinates[i][2] =  (float)u;
		placesOfInterestCoordinates[i][3] = 1.0f;
		
		// Add struct containing distance and index to orderedDistances
		DistanceAndIndex distanceAndIndex;
		distanceAndIndex.distance = sqrtf(n*n + e*e + u*u);
    if ([poi.view respondsToSelector:@selector(setDistance:)])
    {
      [(id<TAFirstPersonViewLabel>)poi.view setDistance:distanceAndIndex.distance];
    }
    
    float alpha = 0.8f; //0.9f - ((log10f(distanceAndIndex.distance+0.000001f)/log10f(_distanceFilter))*0.5f);
    [[poi view] setAlpha:alpha];
    
		distanceAndIndex.index = i;
		[orderedDistances insertObject:[NSData dataWithBytes:&distanceAndIndex length:sizeof(distanceAndIndex)] atIndex:i++];
	}
	
	// Sort orderedDistances in ascending order based on distance from the user
	[orderedDistances sortUsingComparator:(NSComparator)^(NSData *a, NSData *b)
   {
     const DistanceAndIndex *aData = (const DistanceAndIndex *)a.bytes;
     const DistanceAndIndex *bData = (const DistanceAndIndex *)b.bytes;
     if (aData->distance < bData->distance)
     {
       return NSOrderedAscending;
     }
     else if (aData->distance > bData->distance)
     {
       return NSOrderedDescending;
     }
     else
     {
       return NSOrderedSame;
     }
   }];
	
	// Add subviews in descending Z-order so they overlap properly
	for (NSData *d in [orderedDistances reverseObjectEnumerator])
  {
		const DistanceAndIndex *distanceAndIndex = (const DistanceAndIndex *)d.bytes;
		TAPlaceOfInterest *poi = (TAPlaceOfInterest *)[placesOfInterest objectAtIndex:distanceAndIndex->index];
    poi.view.center = CGPointMake(1000, 1000); // offscreen
    poi.view.hidden = NO;
		[self addSubview:poi.view];
	}
}

- (void)onDisplayLink:(id)sender
{
  if (radar != nil)
  {
    float rotate = -[[locationManager heading] trueHeading];
    CGAffineTransform t = CGAffineTransformMakeRotation(rotate*DEGREES_TO_RADIANS-rotationOffset);
    radar.transform = t;
    [self bringSubviewToFront:radar];
  }
  
	CMDeviceMotion *d = motionManager.deviceMotion;
	if (d != nil)
  {
    mat4f_t temp;
    CMRotationMatrix r = d.attitude.rotationMatrix;
		transformFromCMRotationMatrix(temp, &r);
    multiplyMatrixAndMatrix(cameraTransform, orientationTransform, temp);
		[self setNeedsDisplay];
	}
}

#pragma mark - Lifecycle Methods

- (void)drawRect:(CGRect)rect
{
	if (placesOfInterestCoordinates == nil)
  {
		return;
	}
	
  NSArray *placesOfInterest = [_delegate poisForFirstPersonView:self];
	mat4f_t projectionCameraTransform;
	multiplyMatrixAndMatrix(projectionCameraTransform, projectionTransform, cameraTransform);
	
	int i = 0;
	for (TAPlaceOfInterest *poi in placesOfInterest)
  {
		vec4f_t v;
		multiplyMatrixAndVector(v, projectionCameraTransform, placesOfInterestCoordinates[i]);
    
    float n = placesOfInterestCoordinates[i][0];
		float e = placesOfInterestCoordinates[i][1];
		float u = placesOfInterestCoordinates[i][2];

    float distance = sqrtf(n*n + e*e + u*u);
		
		float x = (v[0] / v[3] + 1.0f) * 0.5f;
		float y = (v[1] / v[3] + 1.0f) * 0.5f;
		if (v[2] <= 0.0f && distance < _distanceFilter)
    {
			poi.view.center = CGPointMake(x*self.bounds.size.width, self.bounds.size.height-y*self.bounds.size.height);
		}
    else
    {
			poi.view.center = CGPointMake(1000, 1000); // off screen
		}
		i++;
	}
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
  {
		[self initialize];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self)
  {
		[self initialize];
	}
	return self;
}

- (void)initialize
{
  accuracy = INFINITY;
  rotationOffset = 0.0;
  
  accLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
  accLabel.alpha = 0.8;
  accLabel.textColor = [UIColor tritonBlue];
  accLabel.text = [NSString stringWithFormat:@"%.0f m", accuracy];
  [self addSubview:accLabel];
  
  radar = [[TARadarView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)
                                      radius:_distanceFilter];
  radar.alpha = 0.5;
  radar.backgroundColor = [UIColor clearColor];
  [self addSubview:radar];
  [self bringSubviewToFront:radar];
	
	// Initialize projection matrix
	createProjectionMatrix(projectionTransform, 60.0f*DEGREES_TO_RADIANS, self.bounds.size.width*1.0f / self.bounds.size.height, 0.25f, 1000.0f);
  
  // set up orientation rotation information
  createOrientationMatrix(orientationTransform, 0.0f);
  currentOrientation = UIDeviceOrientationPortrait;
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(orientationChanged:)
                                               name:UIDeviceOrientationDidChangeNotification
                                             object:nil];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
  CLLocation *recentLoc = [locations lastObject];
  
  NSDate* eventDate = recentLoc.timestamp;
  NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
  CLLocationAccuracy recentAcc = recentLoc.horizontalAccuracy;
  if (abs(howRecent) < 2.0 && recentAcc <= accuracy)
  {
    location = recentLoc;
    accuracy = recentAcc;
  }
  
  accLabel.text = [NSString stringWithFormat:@"%.0f m", recentAcc];
  [self updatePlacesOfInterestCoordinates];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
  NSLog(@"ERROR: Location services error: %@", error);
}

#pragma mark - NSNotificaton Handlers
- (void)orientationChanged:(NSNotification *)note
{
  if (captureLayer == nil)
  {
    return;
  }
  
  UIDeviceOrientation orientation=[[UIDevice currentDevice] orientation];
  
  // if they are equal do nothing
  if (orientation == currentOrientation)
  {
    return;
  }
  
  float oldOffset = rotationOffset;
  
  switch (orientation)
  {
    case UIDeviceOrientationLandscapeLeft:
    {
      [[captureLayer connection] setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
      rotationOffset = M_PI_2;
      currentOrientation = orientation;
      break;
    }
    case UIDeviceOrientationLandscapeRight:
    {
      [[captureLayer connection] setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
      rotationOffset = -M_PI_2;
      currentOrientation = orientation;
      break;
    }
    case UIDeviceOrientationPortrait:
    {
      [[captureLayer connection] setVideoOrientation:AVCaptureVideoOrientationPortrait];
      rotationOffset = 0.0;
      currentOrientation = orientation;
      break;
    }
    default:
      return;
  }
  
  // only flip if rotation is by 90 degrees, not 180
  if (oldOffset*rotationOffset == 0.0f)
  {
    CGRect rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    captureLayer.frame = rect;
    radar.center = CGPointMake(self.bounds.size.width - radar.bounds.size.width/2 - 5,
                               self.bounds.size.height - radar.bounds.size.height/2 - [_delegate bottomViewOffset] - 5);
    [self bringSubviewToFront:radar];
  }
  
  // make orientationTransform changes
  createOrientationMatrix(orientationTransform, rotationOffset);
}

@end

#pragma mark - Math utilities definition

void createOrientationMatrix(mat4f_t mout, float theta)
{
	mout[0] = cosf(theta);  mout[4] = -sinf(theta); mout[8] = 0.0f;  mout[12] = 0.0f;
	mout[1] = sinf(theta);  mout[5] = cosf(theta);  mout[9] = 0.0f;  mout[13] = 0.0f;
	mout[2] = 0.0f;         mout[6] = 0.0f;         mout[10] = 1.0f; mout[14] = 0.0f;
	mout[3] = 0.0f;         mout[7] = 0.0f;         mout[11] = 0.0f; mout[15] = 1.0f;
}

// Creates a projection matrix using the given y-axis field-of-view, aspect ratio, and near and far clipping planes
void createProjectionMatrix(mat4f_t mout, float fovy, float aspect, float zNear, float zFar)
{
	float f = 1.0f / tanf(fovy/2.0f);
	
	mout[0] = f / aspect;
	mout[1] = 0.0f;
	mout[2] = 0.0f;
	mout[3] = 0.0f;
	
	mout[4] = 0.0f;
	mout[5] = f;
	mout[6] = 0.0f;
	mout[7] = 0.0f;
	
	mout[8] = 0.0f;
	mout[9] = 0.0f;
	mout[10] = (zFar+zNear) / (zNear-zFar);
	mout[11] = -1.0f;
	
	mout[12] = 0.0f;
	mout[13] = 0.0f;
	mout[14] = 2 * zFar * zNear /  (zNear-zFar);
	mout[15] = 0.0f;
}

// Matrix-vector and matrix-matricx multiplication routines
void multiplyMatrixAndVector(vec4f_t vout, const mat4f_t m, const vec4f_t v)
{
	vout[0] = m[0]*v[0] + m[4]*v[1] + m[8]*v[2] + m[12]*v[3];
	vout[1] = m[1]*v[0] + m[5]*v[1] + m[9]*v[2] + m[13]*v[3];
	vout[2] = m[2]*v[0] + m[6]*v[1] + m[10]*v[2] + m[14]*v[3];
	vout[3] = m[3]*v[0] + m[7]*v[1] + m[11]*v[2] + m[15]*v[3];
}

void multiplyMatrixAndMatrix(mat4f_t c, const mat4f_t a, const mat4f_t b)
{
	uint8_t col, row, i;
	memset(c, 0, 16*sizeof(float));
	
	for (col = 0; col < 4; col++) {
		for (row = 0; row < 4; row++) {
			for (i = 0; i < 4; i++) {
				c[col*4+row] += a[i*4+row]*b[col*4+i];
			}
		}
	}
}

// Initialize mout to be an affine transform corresponding to the same rotation specified by m
void transformFromCMRotationMatrix(mat4f_t mout, const CMRotationMatrix *m)
{
	mout[0] = (float)m->m11;
	mout[1] = (float)m->m21;
	mout[2] = (float)m->m31;
	mout[3] = 0.0f;
	
	mout[4] = (float)m->m12;
	mout[5] = (float)m->m22;
	mout[6] = (float)m->m32;
	mout[7] = 0.0f;
	
	mout[8] = (float)m->m13;
	mout[9] = (float)m->m23;
	mout[10] = (float)m->m33;
	mout[11] = 0.0f;
	
	mout[12] = 0.0f;
	mout[13] = 0.0f;
	mout[14] = 0.0f;
	mout[15] = 1.0f;
}

#pragma mark - Geodetic utilities definition

// References to ECEF and ECEF to ENU conversion may be found on the web.

// Converts latitude, longitude to ECEF coordinate system
void latLonToEcef(double lat, double lon, double alt, double *x, double *y, double *z)
{
	double clat = cos(lat * DEGREES_TO_RADIANS);
	double slat = sin(lat * DEGREES_TO_RADIANS);
	double clon = cos(lon * DEGREES_TO_RADIANS);
	double slon = sin(lon * DEGREES_TO_RADIANS);
	
	double N = WGS84_A / sqrt(1.0 - WGS84_E * WGS84_E * slat * slat);
	
	*x = (N + alt) * clat * clon;
	*y = (N + alt) * clat * slon;
	*z = (N * (1.0 - WGS84_E * WGS84_E) + alt) * slat;
}

// Coverts ECEF to ENU coordinates centered at given lat, lon
void ecefToEnu(double lat, double lon, double x, double y, double z, double xr, double yr, double zr, double *e, double *n, double *u)
{
	double clat = cos(lat * DEGREES_TO_RADIANS);
	double slat = sin(lat * DEGREES_TO_RADIANS);
	double clon = cos(lon * DEGREES_TO_RADIANS);
	double slon = sin(lon * DEGREES_TO_RADIANS);
	double dx = x - xr;
	double dy = y - yr;
	double dz = z - zr;
	
	*e = -slon*dx  + clon*dy;
	*n = -slat*clon*dx - slat*slon*dy + clat*dz;
	*u = clat*clon*dx + clat*slon*dy + slat*dz;
}
