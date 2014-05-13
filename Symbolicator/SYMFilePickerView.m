//
//  SYMFilePickerView.m
//  Symbolicator
//
//  Created by Sam Stigler on 5/9/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import "SYMFilePickerView_Private.h"

static CGFloat const kBorderWidth = 1;

@implementation SYMFilePickerView

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self != nil) {
        [self setUpBorder];
        NSTextAttachment
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

@end
