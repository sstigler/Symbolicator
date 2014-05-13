//
//  SYMFilePickerView.m
//  Symbolicator
//
//  Created by Sam Stigler on 5/9/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import "SYMFilePickerView_Private.h"

static CGFloat const kBorderWidth = 1;

NSString* const kCrashReportUTI = @"com.apple.crashreport";
NSString* const kDSYMUTI = @"com.apple.xcode.dsym";

@implementation SYMFilePickerView

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self != nil) {
        [self setUpBorder];

        self.fileType = (__bridge NSString *)(kUTTypePlainText);
    }
    return self;
}


- (void)setUpBorder {
    self.layer.borderColor = [[NSColor blackColor] CGColor];
    self.layer.borderWidth = kBorderWidth;
}


- (NSImageView *)iconView {
    if (_iconView == nil) {
        _iconView = [[NSImageView alloc] initWithFrame:NSRectFromCGRect(CGRectZero)];
    }
    return _iconView;
}


- (void)setFileType:(NSString *)fileType {
    _fileType = fileType;

    [self unregisterDraggedTypes];
    [self registerForDraggedTypes:@[fileType]];
}

#pragma mark - NSDraggingDestination methods



@end
