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

NSString* const kCrashReportPathExtension = @"crash";
NSString* const kDSYMPathExtension = @"dSym";

@implementation SYMFilePickerView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self != nil)
    {
        [self setWantsLayer:YES];
        [self showNonDraggingBorder];

        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.iconView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self.iconView];
        [self addSubview:self.typeLabel];
        [self addSubview:self.finderButton];
        [self addSubview:self.bambooButton];
        
        self.fileType = (__bridge NSString *)(kUTTypePlainText);
    }
    return self;
}


- (NSImageView *)iconView
{
    if (_iconView == nil)
    {
        _iconView = [[NSImageView alloc] initWithFrame:NSZeroRect];
    }
    return _iconView;
}


- (NSTextField *)typeLabel
{
    if (_typeLabel == nil)
    {
        _typeLabel = [[NSTextField alloc] initWithFrame:NSZeroRect];
        [_typeLabel setEditable:NO];
        [_typeLabel setSelectable:NO];
        [_typeLabel setBackgroundColor:[NSColor clearColor]];
        [_typeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _typeLabel;
}


- (NSButton *)finderButton
{
    if (_finderButton == nil)
    {
        _finderButton = [[NSButton alloc] initWithFrame:NSZeroRect];
        [_finderButton setTitle:@"Finder..."];
        [_finderButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_finderButton setBezelStyle:NSRoundedBezelStyle];
    }
    return _finderButton;
}


- (NSButton *)bambooButton
{
    if (_bambooButton == nil)
    {
        _bambooButton = [[NSButton alloc] initWithFrame:NSZeroRect];
        [_bambooButton setTitle:@"Bamboo..."];
        [_bambooButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_bambooButton setBezelStyle:NSRoundedBezelStyle];
    }
    return _bambooButton;
}


- (void)setFileType:(NSString *)fileType
{
    _fileType = fileType;
    
    self.iconView.image = [[NSWorkspace sharedWorkspace] iconForFileType:fileType];
    
    NSString* extension = kCrashReportPathExtension;
    if ([fileType isEqualToString:kDSYMUTI])
    {
        extension = kDSYMPathExtension;
    }
    NSString* extensionString = [NSString stringWithFormat:@".%@", extension];
    [self.typeLabel setStringValue:extensionString];

    [self setNeedsUpdateConstraints:YES];

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
        [self showDraggingBorder];
        return NSDragOperationLink;
    }
    else {
        return NSDragOperationNone;
    }
}


- (void)draggingExited:(id<NSDraggingInfo>)sender
{
    [self showNonDraggingBorder];
}


#pragma mark - Layout


+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}


- (void)updateConstraints
{
    [self removeAllConstraints];
    
    NSArray* horizontalIconConstraints = [NSLayoutConstraint
                                          constraintsWithVisualFormat:@"|-[iconView]-[typeLabel]-|"
                                          options:kNilOptions
                                          metrics:@{}
                                          views:self.viewsForAutolayout];
    [self addConstraints:horizontalIconConstraints];
    
    if ([self.fileType isEqualToString:kDSYMUTI])
    {
        [self addHorizontalConstraintsForTwoButtonLayout];
    }
    else
    {
        [self addHorizontalConstraintsForOneButtonLayout];
    }
    
    NSArray* verticalConstraints = [NSLayoutConstraint
                                    constraintsWithVisualFormat:@"V:|-[iconView]-[Finder]-|"
                                    options:kNilOptions
                                    metrics:@{}
                                    views:self.viewsForAutolayout];
    [self addConstraints:verticalConstraints];
    
    [super updateConstraints];
}


- (void)addHorizontalConstraintsForTwoButtonLayout
{
    NSLayoutConstraint* alignLeadingOfFinderButton = [NSLayoutConstraint
                                                      constraintWithItem:self
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                      toItem:self.finderButton
                                                      attribute:NSLayoutAttributeLeft
                                                      multiplier:1
                                                      constant:8];
    
    NSLayoutConstraint* alignTrailingOfBambooButton = [NSLayoutConstraint
                                                       constraintWithItem:self
                                                       attribute:NSLayoutAttributeRight
                                                       relatedBy:NSLayoutRelationEqual
                                                       toItem:self.bambooButton
                                                       attribute:NSLayoutAttributeRight
                                                       multiplier:1
                                                       constant:8];
    
    [self addConstraints:@[alignLeadingOfFinderButton, alignTrailingOfBambooButton]];
    
    NSLayoutConstraint* spacingBetweenButtons = [NSLayoutConstraint
                                                 constraintWithItem:self.finderButton
                                                 attribute:NSLayoutAttributeRight
                                                 relatedBy:NSLayoutRelationEqual
                                                 toItem:self.bambooButton
                                                 attribute:NSLayoutAttributeLeft
                                                 multiplier:1
                                                 constant:12];
    
    [self addConstraint:spacingBetweenButtons];
}


- (void)addHorizontalConstraintsForOneButtonLayout
{
    NSArray* horizontalButtonConstraints = [NSLayoutConstraint
                                            constraintsWithVisualFormat:@"|-[Finder]-|"
                                            options:kNilOptions
                                            metrics:@{}
                                            views:self.viewsForAutolayout];
    [self addConstraints:horizontalButtonConstraints];
}

- (NSDictionary *)viewsForAutolayout
{
    if (_viewsForAutolayout == nil)
    {
        _viewsForAutolayout = @{@"iconView": self.iconView,
                                @"typeLabel": self.typeLabel,
                                @"Finder": self.finderButton,
                                @"Bamboo": self.bambooButton};
    }
    return _viewsForAutolayout;
}


- (void)removeAllConstraints
{
    NSArray* allConstraints = self.constraints;
    if ([allConstraints count] > 0)
    {
        [self removeConstraints:allConstraints];
    }
}

@end
