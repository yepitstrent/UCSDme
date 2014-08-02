//
//  TAPlaceOfInterest.m
//  UCSDMe
//
//  Created by Sean Hamilton on 1/22/14.
//  Copyright (c) 2014 Sean Hamilton. All rights reserved.
//

#import "TAPlaceOfInterest.h"
#import "TAPOILabel.h"

@implementation TAPlaceOfInterest

- (id)init
{
    self = [super init];
    if (self) {
			_view = nil;
			_location = nil;
    }    
    return self;
}

+ (TAPlaceOfInterest *)placeOfInterestWithView:(UIView<TAFirstPersonViewLabel> *)view at:(CLLocation *)location withAltitude:(double)alt
{
	TAPlaceOfInterest *poi = [[TAPlaceOfInterest alloc] init];
	poi.view = view;
	poi.location = location;
  poi.altitude = alt;
	return poi;
}

- (BOOL) isEqual:(id)object
{
  return [[(TAPOILabel *)_view text] isEqualToString:[(TAPOILabel *)[(TAPlaceOfInterest *)object view] text]];
}

@end
