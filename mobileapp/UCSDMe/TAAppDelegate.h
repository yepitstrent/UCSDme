//
//  TAAppDelegate.h
//  UCSDMe
//
//  Created by Sean Hamilton on 1/22/14.
//  Copyright (c) 2014 Sean Hamilton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAPOIList.h"
#import "TAFirstPersonView.h"

@interface TAAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) TAPOIList *poiList;

@end
