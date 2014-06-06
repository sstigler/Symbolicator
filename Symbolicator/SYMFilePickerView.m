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
NSString* const kDSYMPathExtension = @"dSYM";

static CGFloat const kMaxWidthOfTypeLabel = 250;

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

        [self registerForDraggedTypes:@[(NSString *)kUTTypeFileURL]];
    }
    return self;
}


- (NSString *)requiredFileExtension
{
    NSString* extension = nil;
    if ([self.fileType isEqualToString:kDSYMUTI])
    {
        extension = kDSYMPathExtension;
    }
    else if ([self.fileType isEqualToString:kCrashReportUTI])
    {
        extension = kCrashReportPathExtension;
    }

    return extension;
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
        [_typeLabel.cell setLineBreakMode:NSLineBreakByTruncatingMiddle];
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
        [_finderButton setTarget:self];
        [_finderButton setAction:@selector(runFileChooser:)];
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
        [_bambooButton setEnabled:NO];
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


- (void)setFileURL:(NSURL *)fileURL
{
    [self.typeLabel setStringValue:[fileURL lastPathComponent]];
    [self.delegate filePickerView:self
                   didPickFileURL:fileURL];
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


#pragma mark - AppKit-style file choosers


- (void)runFileChooser:(id)sender
{
    if ([self.fileType isEqualToString:kCrashReportUTI])
    {
        [self chooseCrashReport:sender];
    }
    else if ([self.fileType isEqualToString:kDSYMUTI])
    {
        [self chooseDSYM:sender];
    }
}


- (void)chooseCrashReport:(id)sender
{
    __weak typeof(self) weakSelf = self;

    NSOpenPanel* reportChooser = [[NSOpenPanel alloc] initWithMessage:@"Which crash report is it?"
                                                             fileType:@"crash"];
    [reportChooser
     beginSheetModalForWindow:[NSApp mainWindow]
     completionHandler:^(NSInteger result) {
         if (result == NSFileHandlingPanelOKButton)
         {
             weakSelf.fileURL = [reportChooser URL];
         }
     }];
}


- (void)chooseDSYM:(id)sender
{
    __weak typeof(self) weakSelf = self;

    NSOpenPanel* dSYMChooser = [[NSOpenPanel alloc] initWithMessage:@"Which dSYM goes with the crash report?"
                                                           fileType:@"dSYM"];
    [dSYMChooser
     beginSheetModalForWindow:[NSApp mainWindow]
     completionHandler:^(NSInteger result) {
         if (result == NSFileHandlingPanelOKButton)
         {
             weakSelf.fileURL = [dSYMChooser URL];
         }
     }];
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


- (void)showRejectedDraggingBorder
{
    self.layer.borderColor = [[NSColor redColor] CGColor];
    self.layer.borderWidth = kBorderWidthWhenDragIsInProgress;
}


#pragma mark - NSDraggingDestination methods


- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    NSDragOperation operationMask = [sender draggingSourceOperationMask];
    BOOL isValidDrag = ((operationMask & NSDragOperationLink) &&
                        ([self doesDraggingInfoRepresentAppropriateDrag:sender]));
    if (isValidDrag)
    {
        [self showDraggingBorder];
        return NSDragOperationLink;
    }
    else {
        NSBeep();
        [self showRejectedDraggingBorder];
        return NSDragOperationNone;
    }
}


- (void)draggingExited:(id<NSDraggingInfo>)sender
{
    [self showNonDraggingBorder];
}


- (void)draggingEnded:(id<NSDraggingInfo>)sender
{
    [self showNonDraggingBorder];
}


- (BOOL)doesDraggingInfoRepresentAppropriateDrag:(id<NSDraggingInfo>) draggingInfo
{
    NSArray* __unused pasteboardFileTypes = [[draggingInfo draggingPasteboard] types]; // must call this before calling -stringForType: .
    BOOL okayToDrag = NO;
    NSString* fileURLString = [[draggingInfo draggingPasteboard] stringForType:(NSString *)kUTTypeFileURL];
    if (fileURLString != nil)
    {
        NSURL* candidateURL = [NSURL URLWithString:fileURLString];
        NSString* fileExtension = [candidateURL pathExtension];
        if ([fileExtension isEqualToString:[self requiredFileExtension]])
        {
            self.fileURLBeingDragged = candidateURL;
            okayToDrag = YES;
        }
    }

    return okayToDrag;
}


- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    self.fileURL = [self.fileURLBeingDragged copy];
    return YES;
}


- (void)concludeDragOperation:(id<NSDraggingInfo>)sender
{
    self.fileURLBeingDragged = nil;
}


#pragma mark - Layout


+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}


- (void)updateConstraints
{
    if (self.alreadyAddedConstraints == NO) {

        [self constraintTopContent];

        NSArray* verticalConstraints = [NSLayoutConstraint
                                             constraintsWithVisualFormat:@"V:[ButtonContainer]-|"
                                             options:kNilOptions
                                             metrics:@{}
                                             views:self.viewsForAutolayout];

        [self addConstraints:verticalConstraints];

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


- (void)constraintTopContent
{
    [self constrainTopContentContainer];

    NSArray* horizontalIconConstraints = [NSLayoutConstraint
                                          constraintsWithVisualFormat:@"|-[iconView]-[typeLabel]-|"
                                          options:kNilOptions
                                          metrics:@{}
                                          views:self.viewsForAutolayout];
    [self addConstraints:horizontalIconConstraints];

    NSLayoutConstraint* iconWidthConstraint = [NSLayoutConstraint
                                               constraintWithItem:self.iconView
                                               attribute:NSLayoutAttributeWidth
                                               relatedBy:NSLayoutRelationEqual
                                               toItem:nil
                                               attribute:NSLayoutAttributeNotAnAttribute
                                               multiplier:1
                                               constant:32];

    NSLayoutConstraint* typeLabelWidthConstraint = [NSLayoutConstraint
                                                    constraintWithItem:self.typeLabel
                                                    attribute:NSLayoutAttributeWidth
                                                    relatedBy:NSLayoutRelationLessThanOrEqual
                                                    toItem:nil
                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                    constant:kMaxWidthOfTypeLabel];

    NSLayoutConstraint* subviewAlignmentInTopContentContainer = [NSLayoutConstraint
                                                                 constraintWithItem:self.iconView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.typeLabel
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 multiplier:1
                                                                 constant:0];

    NSArray* verticalConstraints = [NSLayoutConstraint
                                         constraintsWithVisualFormat:@"V:|-[TopContentContainer]"
                                         options:kNilOptions
                                         metrics:@{}
                                         views:self.viewsForAutolayout];

    [self addConstraints:@[iconWidthConstraint,
                           typeLabelWidthConstraint,
                           subviewAlignmentInTopContentContainer]];

    [self addConstraints:verticalConstraints];
}


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

    NSArray* sideConstraints = [NSLayoutConstraint
                                constraintsWithVisualFormat:@"|-(>=20)-[TopContentContainer]-(>=20)-|"
                                options:kNilOptions
                                metrics:@{}
                                views:self.viewsForAutolayout];

    [self addConstraints:@[heightConstraint, centerXConstraint, bottomConstraint]];
    [self addConstraints:sideConstraints];
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
