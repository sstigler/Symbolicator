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


- (void)testModeDefaultsToFinderOnly
{
    XCTAssertEqual(self.view.mode, SYMFilePickerModeFinderOnly,
                   @"Expected mode to default to SYMFilePickerModeFinderOnly.");
}


- (void)testIconViewIsNSImageView
{
    XCTAssertTrue([self.view.iconView isKindOfClass:[NSImageView class]],
                  @"Expected icon view to be an NSImageView.");
}


#pragma mark - Drag-and-drop support


- (void)testImplementsDraggingEntered
{
    XCTAssertTrue([self.view respondsToSelector:@selector(draggingEntered:)],
                  @"Expected view to implement -draggingEntered: .");
}


- (void)testInitiallyAcceptsPlainTextFileTypeAndNothingElse
{
    XCTAssertEqualObjects(self.view.fileType, (__bridge NSString *)kUTTypePlainText,
                          @"Expected view's fileType to default to public.text.");

    XCTAssertTrue([[self.view registeredDraggedTypes] containsObject: (__bridge NSString *)kUTTypePlainText],
                  @"Expected view to be registered for the 'public.plain-text' file type being dragged on to it.");

    XCTAssertEqual([[self.view registeredDraggedTypes] count], 1,
                   @"Expected view to be initially registered for one and only one dragged type.");
}


- (void)testSettingFileTypeToCrashReport
{
    self.view.fileType = kCrashReportUTI;

    XCTAssertEqualObjects(self.view.fileType, kCrashReportUTI,
                          @"Expected %@, got %@.", kCrashReportUTI, self.view.fileType);

    XCTAssertTrue([[self.view registeredDraggedTypes] containsObject:kCrashReportUTI],
                  @"Expected array containing %@, got %@.", kCrashReportUTI, [self.view registeredDraggedTypes]);

    XCTAssertEqual([[self.view registeredDraggedTypes] count], 1,
                   @"Expected view to be registered for one and only one dragged type.");
}


- (void)testSettingFileTypeToDSYM
{
    self.view.fileType = kDSYMUTI;

    XCTAssertEqualObjects(self.view.fileType, kDSYMUTI,
                          @"Expected %@, got %@.", kDSYMUTI, self.view.fileType);

    XCTAssertTrue([[self.view registeredDraggedTypes] containsObject:kDSYMUTI],
                  @"Expected array containing %@, got %@.", kDSYMUTI, [self.view registeredDraggedTypes]);

    XCTAssertEqual([[self.view registeredDraggedTypes] count], 1,
                   @"Expected view to be registered for one and only one dragged type.");
}

@end
