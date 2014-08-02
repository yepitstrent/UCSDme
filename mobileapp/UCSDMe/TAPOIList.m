//
//  TAPOIList.m
//  UCSDMe
//
//  Created by Sean Hamilton on 2/10/14.
//  Copyright (c) 2014 Sean Hamilton. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "TAPOIList.h"
#import "TAPOILabel.h"
#import "UIColor+TAColor.h"


@interface TAPOIList ()

@property (atomic, strong) NSMutableDictionary *poisByCategory;
@property (nonatomic, strong) NSMutableDictionary *poisByName;
@property (nonatomic, strong) NSMutableArray *selectedPOIs;
@property (atomic, strong) NSMutableDictionary *friends;
@property (nonatomic, strong) NSThread *fetchingThread;

@end

@implementation TAPOIList

#pragma mark - Lifecycle Methods

- (id)init
{
  self = [super init];
  if (self)
  {
    _poisByCategory = [[NSMutableDictionary alloc] init];
    _poisByName = [[NSMutableDictionary alloc] init];
    _selectedPOIs = [[NSMutableArray alloc] init];
    _friends = [[NSMutableDictionary alloc] init];
    [self populateData];
    _fetchingThread = [[NSThread alloc] initWithTarget:self selector:@selector(fetchingWorker:) object:nil];
    [_fetchingThread setName:@"fetchingWorker"];
    [_fetchingThread start];
  }
  return self;
}

#pragma mark - Public Methods

- (NSArray*)categories
{
  return [_poisByCategory allKeys];
}

- (NSArray*)poisByCategory:(NSString*)category
{
  if ([category isEqualToString:@"Friends"])
  {
    return [_friends allKeys];
  }
  else
  {
    return [_poisByCategory objectForKey:category];
  }
}

- (NSArray*)allPois
{
  return [[_poisByName allKeys] arrayByAddingObjectsFromArray:[_friends allKeys]];
}

- (NSUInteger)numberOfCategories
{
  return [_poisByCategory count];
}

- (NSUInteger)numberOfPOIsInCategory:(NSString*)category
{
  if ([category isEqualToString:@"Friends"])
  {
    return [[_friends allKeys] count];
  }
  else
  {
    return [[_poisByCategory objectForKey:category] count];
  }
}

- (TAPlaceOfInterest*)poiByName:(NSString*)name
{
  TAPlaceOfInterest *poi = [_poisByName objectForKey:name];
  if (poi == nil)
  {
    poi = [_friends objectForKey:name];
  }
  
  return poi;
}

- (NSArray*)selectedPOIs
{
  return _selectedPOIs;
}

- (void)addSelectedPOI:(TAPlaceOfInterest *)poi
{
  if (![_selectedPOIs containsObject:poi])
  {
    [_selectedPOIs addObject:poi];
  }
}

- (void)removeSelectedPOIByName:(NSString *)name
{
  for (TAPlaceOfInterest *poi in _selectedPOIs)
  {
    TAPOILabel *v = (TAPOILabel*)poi.view;
    if ([v.text isEqualToString:name])
    {
      [_selectedPOIs removeObject:poi];
      [v removeFromSuperview];
      break;
    }
  }
}

- (BOOL)selectedPOIsContains:(NSString*)poi
{
  BOOL found = false;
  for (TAPlaceOfInterest *p in _selectedPOIs)
  {
    NSString *text = [(TAPOILabel*)p.view text];
    if ([text isEqualToString:poi])
    {
      found = true;
      break;
    }
  }
  return found;
}

#pragma mark - Private Methods

- (BOOL)addCategory:(NSString*)category
{
  BOOL didAdd = false;
  if ([_poisByCategory objectForKey:category] == nil)
  {
    didAdd = true;
    [_poisByCategory setObject:[[NSMutableArray alloc] init] forKey:category];
  }
  return didAdd;
}

- (BOOL)addPOI:(NSString*)poi toCategory:(NSString*)category
{
  BOOL didAdd = false;
  NSMutableArray *pois = [_poisByCategory objectForKey:category];
  if (pois != nil && ![pois containsObject:poi])
  {
    didAdd = true;
    [pois addObject:poi];
  }
  return didAdd;
}

- (void)populateData
{
  NSDictionary *categories = [self fetchAPIData:@"get_categories"];
  [self populatePoisByNameDictionary];
  
  for (NSString *category in categories)
  {
    [self addCategory:category];
    NSString *apicall = [NSString stringWithFormat:@"get_pois_by_categories&category=%@", category];
    NSArray *pois = [self fetchAPIData:apicall];
    for (NSString *poi in pois)
    {
      [self addPOI:poi toCategory:category];
    }
  }
  BOOL useFacebook = [[NSUserDefaults standardUserDefaults] boolForKey:@"facebookEnabled"];
  if (useFacebook)
  {
    [self addCategory:@"Friends"];
  }
}

- (void)populatePoisByNameDictionary
{
  NSArray *tempPOIArray = [self fetchAPIData:@"get_pois"];
  
  for (int i = 0; i < [tempPOIArray count]; i++)
  {
    NSDictionary *results = [tempPOIArray objectAtIndex:i];
    
    TAPOILabel *label = [[TAPOILabel alloc] init];
    
    label.opaque = NO;
    label.backgroundColor = [UIColor tritonBlue];
    label.center = CGPointMake(200.0f, 200.0f);
    label.textColor = [UIColor tritonYellow];
    label.text = [results valueForKey:@"name"];
    CGSize size = [label.text sizeWithAttributes:@{ NSFontAttributeName : label.font }];
    label.bounds = CGRectMake(0.0f, 0.0f, size.width+size.height+30, size.height+20);
    label.image = [UIImage imageNamed:@"UCSD-Logo.png"];
    
    label.distance = 0.0;
    
    TAPlaceOfInterest *poi =
    [TAPlaceOfInterest placeOfInterestWithView:label
                                            at:[[CLLocation alloc] initWithLatitude:[[results valueForKey:@"lat"] doubleValue]
                                                                          longitude:[[results valueForKey:@"lon"] doubleValue]]
                                  withAltitude:[[results valueForKey:@"alt"] doubleValue]];
    
    [_poisByName setObject:poi forKey:label.text];
  }
}

#pragma mark - Private Backend Methods

- (id)fetchAPIData:(NSString *)func
{
  const NSString* ipaddr = @"54.200.77.201";
  
  // show network activity and get data from backend
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  NSString *url = [NSString stringWithFormat:@"http://%@/api.php?action=%@", ipaddr, func];
  NSData* temp = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
  
  NSError *error;
  NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:temp
                                                              options:NSJSONReadingMutableContainers
                                                                error:&error];
  
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  return dict;
}

#pragma mark - Thread Handler

-(void)fetchingWorker:(id)object
{
  BOOL useFacebook = [[NSUserDefaults standardUserDefaults] boolForKey:@"facebookEnabled"];
  NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
  CLLocationManager *locationManager = [[CLLocationManager alloc] init];
  __block NSString *name = nil;
  __block NSString *facebookId = nil;
  __block NSArray *friends = nil;
  __block NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
  [userInfo setObject:locationManager forKey:@"locationManager"];
  
  // completion handler for
  FBRequestHandler handlerForMe =
  ^(FBRequestConnection *connection, id result, NSError *error)
  {
    name = [result objectForKey:@"name"];
    facebookId = [result objectForKey:@"id"];
    [userInfo setObject:name forKey:@"name"];
    [userInfo setObject:facebookId forKey:@"id"];
    if ( friends != nil)
    {
      NSTimer *timer = [NSTimer timerWithTimeInterval:5.0
                                               target:self
                                             selector:@selector(timerFired:)
                                             userInfo:userInfo
                                              repeats:YES];
      
      [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    }
  };
  
  // completion handler for
  FBRequestHandler handlerForFriends =
  ^(FBRequestConnection *connection, id result, NSError *error)
  {
    friends = [result objectForKey:@"data"];
    [userInfo setObject:friends forKey:@"friends"];
    if ( name != nil && facebookId != nil)
    {
      NSTimer *timer = [NSTimer timerWithTimeInterval:5.0
                              target:self
                            selector:@selector(timerFired:)
                            userInfo:userInfo
                             repeats:YES];
      
      [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    }
  };
  
  if (useFacebook)
  {
    if (![FBSession openActiveSessionWithAllowLoginUI:YES])
    {
      int counter = 0;
      while (![[FBSession activeSession] isOpen] && counter < 10)
      {
        counter++;
        [NSThread sleepForTimeInterval:0.5];
      }
      if (counter == 10)
      {
        useFacebook = NO;
      }
    }
  }
  
  if (useFacebook)
  {
    [FBRequestConnection startForMeWithCompletionHandler:handlerForMe];
    [FBRequestConnection startForMyFriendsWithCompletionHandler:handlerForFriends];
  }
  else
  {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"facebookEnabled"];
    return;
  }
  
  // begin run loop
  while (true)
  {
    [runLoop run];
  }
}

#pragma mark - timer callback
- (void)timerFired:(NSTimer *)timer
{
  CLLocation *location = [(CLLocationManager *)[timer.userInfo objectForKey:@"locationManager"] location];
  NSString *name = [timer.userInfo objectForKey:@"name"];
  NSString *facebookId = [timer.userInfo objectForKey:@"id"];
  
  const NSString* ipaddr = @"54.200.77.201";
  
  // show network activity and get data from backend
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  NSError *error;
  NSString *url = [NSString stringWithFormat:@"http://%@/api.php?action=%@&facebook_id=%@", ipaddr, @"get_facebook_by_id", facebookId];
  NSString *temp = [NSString stringWithContentsOfURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                            encoding:(NSUTF8StringEncoding)
                                               error:&error];
  
  if ([temp isEqualToString:@"[]"])
  {
    url = [NSString stringWithFormat:@"http://%@/api.php?action=%@&facebook_id=%@&name=%@&lat=%f&lon=%f&alt=%f",
           ipaddr, @"insert_facebook_id", facebookId, name, location.coordinate.longitude, location.coordinate.latitude, location.altitude];
  }
  else
  {
    url = [NSString stringWithFormat:@"http://%@/api.php?action=%@&facebook_id=%@&lon=%f&lat=%f&alt=%f",
           ipaddr, @"update_location", facebookId, location.coordinate.longitude, location.coordinate.latitude, location.altitude];
  }
  
  temp = [NSString stringWithContentsOfURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                                  encoding:(NSUTF8StringEncoding)
                                     error:&error];
  
  if ([temp isEqualToString:@"false"])
  {
    NSLog(@"Failed To Update Current Location");
  }
  
  NSMutableString *ids = [NSMutableString stringWithString:@""];
  for (id friend in [timer.userInfo objectForKey:@"friends"])
  {
    [ids appendFormat:@"%@_", [friend objectForKey:@"id"]];
  }
  [ids appendString:@"0"];
  
  url = [NSString stringWithFormat:@"http://%@/api.php?action=%@&facebook_id=%@", ipaddr, @"get_facebook_by_id", ids];
  
  NSData* data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
  
  NSArray *people = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingMutableContainers
                                                      error:&error];
  
  for (NSDictionary *person in people)
  {
    TAPlaceOfInterest *friend = [_friends objectForKey:[person valueForKey:@"name"]];
    
    // if friend is new to list, add them
    if (friend == nil)
    {
      TAPOILabel *label = [[TAPOILabel alloc] init];
      
      
      
      label.opaque = NO;
      label.backgroundColor = [UIColor tritonBlue];
      label.center = CGPointMake(200.0f, 200.0f);
      label.textColor = [UIColor tritonYellow];
      label.text = [person valueForKey:@"name"];
      CGSize size = [label.text sizeWithAttributes:@{ NSFontAttributeName : label.font }];
      label.bounds = CGRectMake(0.0f, 0.0f, size.width+size.height+30, size.height+20);
      
      //Pulls FB Picture for label
      NSURL *fbPicUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=square", [person valueForKey:@"facebook_id"]]];
      NSData *fbPic = [NSData dataWithContentsOfURL:fbPicUrl];
      label.image = [[UIImage alloc] initWithData:fbPic];
      
      label.distance = 0.0;
      
      friend = [TAPlaceOfInterest placeOfInterestWithView:label
                                                       at:[[CLLocation alloc] initWithLatitude:[[person valueForKey:@"lat"] doubleValue]
                                                                                     longitude:[[person valueForKey:@"lon"] doubleValue]]
                                             withAltitude:2.2];
      
      [_friends setObject:friend forKey:label.text];
    }
    else // otherwise update them
    {
      [friend setLocation:[[CLLocation alloc] initWithLatitude:[[person valueForKey:@"lat"] doubleValue]
                                                     longitude:[[person valueForKey:@"lon"] doubleValue]]];
    }
  }
  
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


@end