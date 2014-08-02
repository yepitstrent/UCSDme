//
//  TATabBarViewController.m
//  UCSDMe
//
//  Created by Sean Hamilton on 1/26/14.
//  Copyright (c) 2014 Sean Hamilton. All rights reserved.
//

#import "TATabBarViewController.h"
#import "UIColor+TAColor.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface TATabBarViewController ()

@end

@implementation TATabBarViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [[self tabBar] setTintColor:[UIColor tritonYellow]];
  [[self tabBar] setBackgroundColor:[UIColor tritonBlue]];
  
}

-(void)viewDidAppear:(BOOL)animated
{
  // May return nil if a tracker has not already been initialized with a
  // property ID.
  
  id tracker = [[GAI sharedInstance] defaultTracker];
  
  // This screen name value will remain set on the tracker and sent with
  // hits until it is set to a new value or to nil.
  [tracker set:kGAIScreenName
         value:@"Tab View"];
  
  [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}
@end
