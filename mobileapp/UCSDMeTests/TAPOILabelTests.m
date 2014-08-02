//
//  TAPOILabelTests.m
//  UCSDMe
//
//  Created by Sean Hamilton on 2/7/14.
//  Copyright (c) 2014 Sean Hamilton. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TAPOILabel.h"

@interface TAPOILabelTests : XCTestCase

@property (nonatomic, strong) TAPOILabel* label;

@end

@implementation TAPOILabelTests

- (void)setUp
{
    [super setUp];
  _label = [[TAPOILabel alloc] init];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testInit
{
  XCTAssertTrue(_label != nil, @"TAPOILabel Failed to init");
}

@end
