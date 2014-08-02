//
//  TAView.h
//  UCSDMe
//
//  Created by Sean Hamilton on 1/22/14.
//  Copyright (c) 2014 Sean Hamilton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import "TAPlaceOfInterest.h"

@protocol TAFirstPersonViewDelegate;
@protocol TAFirstPersonViewLabel;

@interface TAFirstPersonView : UIView  <CLLocationManagerDelegate>

@property (nonatomic) float distanceFilter;
@property (nonatomic, weak) IBOutlet id <TAFirstPersonViewDelegate> delegate;

- (void)start;
- (void)stop;
- (CLLocation *)location;

@end

@protocol TAFirstPersonViewDelegate <NSObject>

@required
- (NSArray *)poisForFirstPersonView:(TAFirstPersonView *)fpView;
-(double)bottomViewOffset;

@end

@protocol TAFirstPersonViewLabel <NSObject>

@optional
- (void)setDistance:(double)dist;

@end



