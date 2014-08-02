//
//  TAPOIAnnotation.m
//  UCSDMe
//
//  Created by Greblhad on 1/29/14.
//  Copyright (c) 2014 Sean Hamilton. All rights reserved.
//

#import "TAPOIAnnotation.h"
#import "TAPOILabel.h"

@implementation TAPOIAnnotation

- (id)initWithPOI:(TAPlaceOfInterest *)poi
{
    self = [super init];
    if (self) {
        _pointOfInterest = poi;
        _coordinate = poi.location.coordinate;
        _title = ((TAPOILabel *)poi.view).text;
    }
    return self;
}

@end
