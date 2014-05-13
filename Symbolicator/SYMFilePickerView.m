//
//  SYMFilePickerView.m
//  Symbolicator
//
//  Created by Sam Stigler on 5/9/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import "SYMFilePickerView_Private.h"

static CGFloat const kBorderWidthWhenNoDragIsInProgress = 1;
static CGFloat const kBorderWidthWhenDragIsInProgress = 3;

NSString* const kCrashReportUTI = @"com.apple.crashreport";
NSString* const kDSYMUTI = @"com.apple.xcode.dsym";

@implementation SYMFilePickerView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self != nil)
    {
        [self showNonDraggingBorder];

        self.fileType = (__bridge NSString *)(kUTTypePlainText);
    }
    return self;
}


- (NSImageView *)iconView
{
    if (_iconView == nil)
    {
        _iconView = [[NSImageView alloc] initWithFrame:NSRectFromCGRect(CGRectZero)];
    }
    return _iconView;
}


- (void)setFileType:(NSString *)fileType
{
    _fileType = fileType;

    [self unregisterDraggedTypes];
    [self registerForDraggedTypes:@[fileType]];
}


#pragma mark - Borders


- (void)showNonDraggingBorder
{
    self.layer.borderColor = [[NSColor blackColor] CGColor];
    self.layer.borderWidth = kBorderWidthWhenNoDragIsInProgress;
}


- (void)showDraggingBorder
{
    self.layer.borderColor = [[NSColor greenColor] CGColor];
    self.layer.borderWidth = kBorderWidthWhenDragIsInProgress;
}


#pragma mark - NSDraggingDestination methods


- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    if ([(id<NSDraggingInfo>)sender draggingSourceOperationMask] != NSDragOperationNone)
    {
        return NSDragOperationLink;
    }
    else {
        return NSDragOperationNone;
    }
}

@end
