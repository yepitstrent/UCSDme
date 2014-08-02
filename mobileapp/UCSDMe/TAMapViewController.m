//
//  TAMapViewController.m
//  UCSDMe
//
//  Created by Sean Hamilton on 1/24/14.
//  Copyright (c) 2014 Sean Hamilton. All rights reserved.
//

#import "TAMapViewController.h"
#import "TAAppDelegate.h"
#import "TAPlaceOfInterest.h"
#import "TAPOIAnnotation.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "TAPOILabel.h"


@interface TAMapViewController ()
@property (weak, nonatomic) IBOutlet UITabBarItem *mapViewControllerButton;

@property (weak, nonatomic) IBOutlet UILongPressGestureRecognizer *longPress;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation TAMapViewController

- (IBAction)longPressDetected:(UILongPressGestureRecognizer *)sender
{
  if ([sender numberOfTouches] == 1)
  {
    [_mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
  }
  else if ([sender numberOfTouches] == 2)
  {
    [_mapView setUserTrackingMode:MKUserTrackingModeNone];
  }
}

- (BOOL)prefersStatusBarHidden
{
  return YES;
}

-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  // May return nil if a tracker has not already been initialized with a
  // property ID.
  id tracker = [[GAI sharedInstance] defaultTracker];
  
  // This screen name value will remain set on the tracker and sent with
  // hits until it is set to a new value or to nil.
  [tracker set:kGAIScreenName
         value:@"Map View"];
  
  [tracker send:[[GAIDictionaryBuilder createAppView] build]];

}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // set to UCSD region by default
  CLLocationCoordinate2D ucsd = {32.881137,-117.237564};
  MKCoordinateSpan span = {0.01, 0.01};
  MKCoordinateRegion region = MKCoordinateRegionMake(ucsd, span);
  [_mapView setRegion:region animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  NSMutableArray *annotationsToRemove = [ _mapView.annotations mutableCopy ];
  [annotationsToRemove removeObject:_mapView.userLocation ];
  [_mapView removeAnnotations:annotationsToRemove ];
  
  NSArray* pois = [[(TAAppDelegate*)[[UIApplication sharedApplication] delegate] poiList] selectedPOIs];
  
  //Create Annotations for each poi
  for (TAPlaceOfInterest* poi in pois)
  {
    TAPOIAnnotation *poiAnnotation = [[TAPOIAnnotation alloc] initWithPOI:poi];
    [_mapView addAnnotation:poiAnnotation];
  }
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
  MKAnnotationView *annotationView = nil;
  if ([annotation isKindOfClass:[TAPOIAnnotation class]])
  {
    annotationView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
    if (annotationView == nil)
    {
      annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
      //annotationView.canShowCallout = YES;
      annotationView.image = [UIImage imageNamed:@"tridentSmall"];
      //((MKPinAnnotationView *)annotationView).animatesDrop = YES;
      
      //[annotationView addSubview:((TAPOIAnnotation*)annotation)->pointOfInterest.view];
    }
    
  }
  return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
  if(![view.annotation isKindOfClass:[MKUserLocation class]])
  {
    CGRect calloutViewFrame = ((TAPOIAnnotation*)view.annotation).pointOfInterest.view.frame;
    calloutViewFrame.origin = CGPointMake(-calloutViewFrame.size.width/2 + 15, -calloutViewFrame.size.height);
    ((TAPOIAnnotation*)view.annotation).pointOfInterest.view.frame = calloutViewFrame;
    [view addSubview:((TAPOIAnnotation*)view.annotation).pointOfInterest.view];
  }
  
}

//12
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
  for (UIView *subview in view.subviews )
  {
    [subview removeFromSuperview];
  }
}

@end
