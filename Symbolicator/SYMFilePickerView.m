//
//  SYMFilePickerView.m
//  Symbolicator
//
//  Created by Sam Stigler on 5/9/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import "SYMFilePickerView_Private.h"

#import "NSView+SYMAdditions.h"

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

        [self.buttonContainer addSubview:self.finderButton];
        [self.buttonContainer addSubview:self.bambooButton];
        [self addSubview:self.buttonContainer];

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
        [_typeLabel setDrawsBackground:NO];
    }
    return _typeLabel;
}


- (NSView *)buttonContainer
{
    if (_buttonContainer == nil)
    {
        _buttonContainer = [[NSView alloc] initWithFrame:NSZeroRect];
        _buttonContainer.wantsLayer = YES;
        _buttonContainer.layer.backgroundColor = [[NSColor greenColor] CGColor];
        [_buttonContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _buttonContainer;
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
        self.finderButton.layer.hidden = NO;
        self.bambooButton.layer.hidden = NO;
    }
    else {
        self.finderButton.layer.hidden = NO;
        self.bambooButton.layer.hidden = YES;
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
    if (self.alreadyAddedConstraints == NO) {

        NSArray* horizontalIconConstraints = [NSLayoutConstraint
                                              constraintsWithVisualFormat:@"|-[iconView]-[typeLabel]-|"
                                              options:kNilOptions
                                              metrics:@{}
                                              views:self.viewsForAutolayout];
        [self addConstraints:horizontalIconConstraints];

        [self constrainButtons];

        NSArray* verticalConstraints = [NSLayoutConstraint
                                        constraintsWithVisualFormat:@"V:|-[iconView]-[ButtonContainer]-|"
                                        options:kNilOptions
                                        metrics:@{}
                                        views:self.viewsForAutolayout];
        [self addConstraints:verticalConstraints];

        self.alreadyAddedConstraints = YES;

        [super updateConstraints];
    }
}


- (void)constrainButtons
{
    if ([self.fileType isEqualToString:kDSYMUTI])
    {
        [self constrainButtonsForTwoButtonLayout];
    }
    else
    {
        [self constrainButtonsForOneButtonLayout];
    }

    [self constrainButtonContainer];
}


- (void)constrainButtonsForTwoButtonLayout
{
    NSLayoutConstraint* alignLeadingOfFinderButton = [NSLayoutConstraint
                                                      constraintWithItem:self.buttonContainer
                                                      attribute:NSLayoutAttributeLeft
                                                      relatedBy:NSLayoutRelationEqual
                                                      toItem:self.finderButton
                                                      attribute:NSLayoutAttributeLeft
                                                      multiplier:1
                                                      constant:0];

    NSLayoutConstraint* alignTrailingOfBambooButton = [NSLayoutConstraint
                                                       constraintWithItem:self.buttonContainer
                                                       attribute:NSLayoutAttributeRight
                                                       relatedBy:NSLayoutRelationEqual
                                                       toItem:self.bambooButton
                                                       attribute:NSLayoutAttributeRight
                                                       multiplier:1
                                                       constant:0];

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


- (void)constrainButtonsForOneButtonLayout
{
    NSArray* horizontalButtonConstraints = [NSLayoutConstraint
                                            constraintsWithVisualFormat:@"|-[Finder]-|"
                                            options:kNilOptions
                                            metrics:@{}
                                            views:self.viewsForAutolayout];
    [self.buttonContainer addConstraints:horizontalButtonConstraints];
}


- (void)constrainButtonContainer
{
    NSLayoutConstraint *containerHeightConstraint = [NSLayoutConstraint
                                                     constraintWithItem:self.buttonContainer
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                     toItem:self.finderButton
                                                     attribute:NSLayoutAttributeHeight
                                                     multiplier:1
                                                     constant:0];

    NSLayoutConstraint *containerXConstraint = [NSLayoutConstraint
                                                constraintWithItem:self
                                                attribute:NSLayoutAttributeCenterX
                                                relatedBy:NSLayoutRelationEqual
                                                toItem:self.buttonContainer
                                                attribute:NSLayoutAttributeCenterX
                                                multiplier:1
                                                constant:0];

    [self addConstraint:containerHeightConstraint];
    [self addConstraint:containerXConstraint];
}


- (NSDictionary *)viewsForAutolayout
{
    if (_viewsForAutolayout == nil)
    {
        _viewsForAutolayout = @{@"iconView": self.iconView,
                                @"typeLabel": self.typeLabel,
                                @"Finder": self.finderButton,
                                @"Bamboo": self.bambooButton,
                                @"ButtonContainer": self.buttonContainer};
    }
    return _viewsForAutolayout;
}

@end
