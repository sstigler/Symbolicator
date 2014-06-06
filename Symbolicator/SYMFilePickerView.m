//
//  SYMFilePickerView.m
//  Symbolicator
//
//  Created by Sam Stigler on 5/9/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import "Symbolicator-Swift.h"
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

        [self.topContentContainer addSubview:self.iconView];
        [self.topContentContainer addSubview:self.typeLabel];
        [self addSubview:self.topContentContainer];

        [self addSubview:self.buttonContainer];

        _fileType = nil;
    }
    return self;
}


#pragma mark - Top-level button configuration methods


- (void)configureForOneButtonLayout
{
    [self resetButtonLayout];

    [self.buttonContainer addSubview:self.finderButton];
}


- (void)configureForTwoButtonLayout
{
    [self resetButtonLayout];

    [self.buttonContainer addSubview:self.finderButton];
    [self.buttonContainer addSubview:self.bambooButton];
}


- (void)resetButtonLayout
{
    [self.finderButton removeFromSuperviewWithoutNeedingDisplay];
    [self.bambooButton removeFromSuperviewWithoutNeedingDisplay];
    self.finderButton = nil;
    self.bambooButton = nil;
}


#pragma mark - Properties


- (NSImageView *)iconView
{
    if (_iconView == nil)
    {
        _iconView = [[NSImageView alloc] initWithFrame:NSZeroRect];
        [_iconView setTranslatesAutoresizingMaskIntoConstraints:NO];
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
        [_typeLabel setBezeled:NO];
    }
    return _typeLabel;
}


- (NSView *)topContentContainer
{
    if (_topContentContainer == nil)
    {
        _topContentContainer = [[NSView alloc] initWithFrame:NSZeroRect];
        _topContentContainer.wantsLayer = YES;
        [_topContentContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _topContentContainer;
}

- (NSView *)buttonContainer
{
    if (_buttonContainer == nil)
    {
        _buttonContainer = [[NSView alloc] initWithFrame:NSZeroRect];
        _buttonContainer.wantsLayer = YES;
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
    }

    NSString* extensionString = [NSString stringWithFormat:@".%@", extension];
    [self.typeLabel setStringValue:extensionString];

    [self setNeedsUpdateConstraints:YES];

    [self unregisterDraggedTypes];
    [self registerForDraggedTypes:@[fileType]];
}


- (void)setMode:(SYMFilePickerMode)mode
{
    _mode = mode;

    switch (mode) {
        case SYMFilePickerModeFinderOnly:
            [self configureForOneButtonLayout];
            break;
        case SYMFilePickerModeFinderAndBamboo:
            [self configureForTwoButtonLayout];
    }

    [self constrainButtons];

    [self setNeedsUpdateConstraints:YES];
}


- (NSArray *)buttonConstraintsForTwoButtonLayout
{
    if (_buttonConstraintsForTwoButtonLayout == nil)
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

        NSLayoutConstraint* spacingBetweenButtons = [NSLayoutConstraint
                                                     constraintWithItem:self.finderButton
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                     toItem:self.bambooButton
                                                     attribute:NSLayoutAttributeLeft
                                                     multiplier:1
                                                     constant:-12];

        _buttonConstraintsForTwoButtonLayout = @[alignLeadingOfFinderButton,
                                                 alignTrailingOfBambooButton,
                                                 spacingBetweenButtons];
    }
    
    return _buttonConstraintsForTwoButtonLayout;
}


- (NSArray *)buttonConstraintsForOneButtonLayout
{
    if (_buttonConstraintsForOneButtonLayout == nil)
    {
        NSLayoutConstraint* containerHeightConstraint = [NSLayoutConstraint
                                                         constraintWithItem:self.buttonContainer
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                         toItem:self.finderButton
                                                         attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                         constant:0];

        NSLayoutConstraint* containerLeftConstraint = [NSLayoutConstraint
                                                       constraintWithItem:self.buttonContainer
                                                       attribute:NSLayoutAttributeLeft
                                                       relatedBy:NSLayoutRelationEqual
                                                       toItem:self.finderButton
                                                       attribute:NSLayoutAttributeLeft
                                                       multiplier:1
                                                       constant:0];

        NSLayoutConstraint* containerRightConstraint = [NSLayoutConstraint
                                                        constraintWithItem:self.buttonContainer
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                        toItem:self.finderButton
                                                        attribute:NSLayoutAttributeRight
                                                        multiplier:1
                                                        constant:0];

        _buttonConstraintsForOneButtonLayout = @[containerHeightConstraint,
                                                 containerLeftConstraint,
                                                 containerRightConstraint];
    }

    return _buttonConstraintsForOneButtonLayout;
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

        [self constrainTopContentContainer];

        NSArray* horizontalIconConstraints = [NSLayoutConstraint
                                              constraintsWithVisualFormat:@"|-[iconView]-[typeLabel]-|"
                                              options:kNilOptions
                                              metrics:@{}
                                              views:self.viewsForAutolayout];
        [self addConstraints:horizontalIconConstraints];


        NSLayoutConstraint* subviewAlignmentInTopContentContainer = [NSLayoutConstraint
                                                                     constraintWithItem:self.iconView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.typeLabel
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     multiplier:1
                                                                     constant:0];

        [self addConstraint:subviewAlignmentInTopContentContainer];

        NSArray* verticalConstraintsPart1 = [NSLayoutConstraint
                                             constraintsWithVisualFormat:@"V:|-[TopContentContainer]"
                                             options:kNilOptions
                                             metrics:@{}
                                             views:self.viewsForAutolayout];

        NSArray* verticalConstraintsPart2 = [NSLayoutConstraint
                                             constraintsWithVisualFormat:@"V:[ButtonContainer]-|"
                                             options:kNilOptions
                                             metrics:@{}
                                             views:self.viewsForAutolayout];

        [self addConstraints:verticalConstraintsPart1];
        [self addConstraints:verticalConstraintsPart2];

        [self constrainButtonContainer];

        self.alreadyAddedConstraints = YES;
        
        [super updateConstraints];
    }
}


- (NSDictionary *)viewsForAutolayout
{
    if (_viewsForAutolayout == nil)
    {
        _viewsForAutolayout = @{@"iconView": self.iconView,
                                @"typeLabel": self.typeLabel,
                                @"Finder": self.finderButton,
                                @"Bamboo": self.bambooButton,
                                @"ButtonContainer": self.buttonContainer,
                                @"TopContentContainer": self.topContentContainer};
    }
    return _viewsForAutolayout;
}


#pragma mark Top content layout constraints


- (void)constrainTopContentContainer
{
    NSLayoutConstraint* heightConstraint = [NSLayoutConstraint
                                            constraintWithItem:self.topContentContainer
                                            attribute:NSLayoutAttributeHeight
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self.iconView
                                            attribute:NSLayoutAttributeHeight
                                            multiplier:1
                                            constant:0];

    NSLayoutConstraint* centerXConstraint = [NSLayoutConstraint
                                             constraintWithItem:self
                                             attribute:NSLayoutAttributeCenterX
                                             relatedBy:NSLayoutRelationEqual
                                             toItem:self.topContentContainer
                                             attribute:NSLayoutAttributeCenterX
                                             multiplier:1
                                             constant:0];

    NSLayoutConstraint* bottomConstraint = [NSLayoutConstraint
                                            constraintWithItem:self.topContentContainer
                                            attribute:NSLayoutAttributeBottom
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:self.iconView
                                            attribute:NSLayoutAttributeBottom
                                            multiplier:1
                                            constant:0];

    [self addConstraints:@[heightConstraint, centerXConstraint, bottomConstraint]];
}


#pragma mark Button layout constraints


- (void)constrainButtons
{
    if ([self.constraints containsObject:self.buttonConstraintsForOneButtonLayout[0]])
    {
        [self removeConstraints:self.buttonConstraintsForOneButtonLayout];
    }

    if ([self.constraints containsObject:self.buttonConstraintsForTwoButtonLayout[0]])
    {
        [self removeConstraints:self.buttonConstraintsForTwoButtonLayout];
    }

    switch (self.mode) {
        case SYMFilePickerModeFinderAndBamboo:
            [self addConstraints:self.buttonConstraintsForTwoButtonLayout];
            break;
        case SYMFilePickerModeFinderOnly:
            [self addConstraints:self.buttonConstraintsForOneButtonLayout];
    }
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

@end
