//
//  TAPlaceOfInterest.h
//  UCSDMe
//
//  Created by Sean Hamilton on 1/22/14.
//  Copyright (c) 2014 Sean Hamilton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "TAFirstPersonView.h"

@interface TAPlaceOfInterest : NSObject

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic) double altitude;


/**
 Creates an instance of TAPlaceOfInterest
 Example usage:
 @code
 NSURL *url1, *url2;
 TAPlaceOfInterest *poi =
 [TAPlaceOfInterest placeOfInterestWithView:label
 at:[[CLLocation alloc] initWithLatitude:[[results valueForKey:@"lat"] doubleValue]
 longitude:[[results valueForKey:@"lon"] doubleValue]]
 withAltitude:[[results valueForKey:@"alt"] doubleValue]];
 @endcode
 @param view
 The UIView that will be displayed on the screen asscioated with the POI
 @param at
 The location where this POI is located as a CLLocation
 @param altitude
 The altitude of the POI as a double
 @return An instance of TAPlaceOfInterest
 */
+ (TAPlaceOfInterest *)placeOfInterestWithView:(UIView *)view at:(CLLocation *)location withAltitude:(double)alt;

@end
