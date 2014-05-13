//
//  SYMFilePickerViewTests.m
//  Symbolicator
//
//  Created by Sam Stigler on 5/9/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import "SYMFilePickerView_Private.h"

#import <XCTest/XCTest.h>

@interface SYMFilePickerViewTests : XCTestCase

@property(nonatomic, strong) SYMFilePickerView* view;

@end

@implementation SYMFilePickerViewTests

- (void)setUp
{
    [super setUp];

    self.view = [[SYMFilePickerView alloc] initWithFrame:NSRectFromCGRect(CGRectZero)];
}


- (void)testIsNSView
{
    XCTAssertTrue([self.view isKindOfClass:[NSView class]],
                  @"Expected view to be an NSView.");
}


- (void)testModeDefaultsToFinderOnly {
    XCTAssertEqual(self.view.mode, SYMFilePickerModeFinderOnly,
                   @"Expected mode to default to SYMFilePickerModeFinderOnly.");
}


- (void)testIconViewIsNSImageView {
    XCTAssertTrue([self.view.iconView isKindOfClass:[NSImageView class]],
                  @"Expected icon view to be an NSImageView.");
}


- (void)testConformsToNSDraggingDestination {
    XCTAssertTrue([self.view conformsToProtocol:@protocol(NSDraggingDestination)],
                  @"Expected view to conform to the NSDraggingDestination protocol.");
}

@end
