//
//  TAOverlayViewController.m
//  UCSDMe
//
//  Created by Sean Hamilton on 1/22/14.
//  Copyright (c) 2014 Sean Hamilton. All rights reserved.
//

#import "TAFirstPersonViewController.h"
#import "TAPlaceOfInterest.h"
#import "TAFirstPersonView.h"
#import "TAPOILabel.h"
#import "UIColor+TAColor.h"
#import "TAAppDelegate.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import <CoreLocation/CoreLocation.h>

@interface TAFirstPersonViewController ()
@property (weak, nonatomic) IBOutlet UITabBarItem *tapOverlayViewControllerButton;

@end

@implementation TAFirstPersonViewController

#pragma mark - View lifecycle

- (BOOL)prefersStatusBarHidden
{
  return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  TAFirstPersonView *taView = (TAFirstPersonView *)self.view;
  float  distanceFilter = [[NSUserDefaults standardUserDefaults] floatForKey:@"distanceFilter"];
  
  if (distanceFilter < 100.0)
  {
    distanceFilter = 10000.0f;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:distanceFilter] forKey:@"distanceFilter"];
  }
  
  [taView setDistanceFilter:distanceFilter];

	[taView start];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	TAFirstPersonView *taView = (TAFirstPersonView *)self.view;
	[taView stop];
  [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  // May return nil if a tracker has not already been initialized with a
  // property ID.
  id tracker = [[GAI sharedInstance] defaultTracker];
  
  // This screen name value will remain set on the tracker and sent with
  // hits until it is set to a new value or to nil.
  [tracker set:kGAIScreenName
         value:@"First Person View"];
  
  [tracker send:[[GAIDictionaryBuilder createAppView] build]];
  
  [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}

#pragma mark - TAFirstPersonViewDelegate Methods
- (NSArray *)poisForFirstPersonView:(TAFirstPersonView *)fpView
{
  return [[(TAAppDelegate*)[[UIApplication sharedApplication] delegate] poiList] selectedPOIs];
}

-(double)bottomViewOffset
{
  return [[[self tabBarController] tabBar] frame].size.height;
}

@end
