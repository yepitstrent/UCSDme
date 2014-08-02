//
//  TAPOIList.h
//  UCSDMe
//
//  Created by Sean Hamilton on 2/10/14.
//  Copyright (c) 2014 Sean Hamilton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TAPlaceOfInterest.h"

@interface TAPOIList : NSObject

- (NSArray*)categories;
- (NSArray*)poisByCategory:(NSString*)category;
- (NSArray*)allPois;
- (NSUInteger)numberOfCategories;
- (NSUInteger)numberOfPOIsInCategory:(NSString*)category;
- (TAPlaceOfInterest*)poiByName:(NSString*)name;
- (NSArray*)selectedPOIs;
- (void)addSelectedPOI:(TAPlaceOfInterest *)poi;
- (void)removeSelectedPOIByName:(NSString *)name;
- (BOOL)selectedPOIsContains:(NSString*)poi;

@end
