//
//  TAPOIListTest.m
//  UCSDMe
//
//  Created by Sean Hamilton on 2/10/14.
//  Copyright (c) 2014 Sean Hamilton. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TAPOIList.h"

@interface TAPOIListTest : XCTestCase

@property (nonatomic) TAPOIList *list;

@end

@implementation TAPOIListTest

- (void)setUp
{
    [super setUp];
  
  _list = [[TAPOIList alloc] init];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testInit
{
  XCTAssertTrue(_list != nil, @"TAPOIList init failed");
}

- (void)testGetCategories
{
  NSArray *categories = [_list categories];
  XCTAssertTrue(categories != nil, @"List of categories falied");
  NSLog(@"%@", categories);
}

@end
