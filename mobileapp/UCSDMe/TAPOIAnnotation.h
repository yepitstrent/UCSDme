//
//  TAPOIAnnotation.h
//  UCSDMe
//
//  Created by Greblhad on 1/29/14.
//  Copyright (c) 2014 Sean Hamilton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "TAPlaceOfInterest.h"


@interface TAPOIAnnotation : NSObject <MKAnnotation>

@property (nonatomic, weak) TAPlaceOfInterest *pointOfInterest;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;

- (id)initWithPOI:(TAPlaceOfInterest*)poi;

@end
