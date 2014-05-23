//
//  SYMFilePickerView_Private.h
//  Symbolicator
//
//  Created by Sam Stigler on 5/10/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import "SYMFilePickerView.h"

@interface SYMFilePickerView () <NSDraggingDestination>

/**
 Shows the icon corresponding to the file type.
 */
@property(nonatomic, strong) NSImageView* iconView;

/**
 Shows the file extension corresponding to the file type.
 */
@property(nonatomic, strong) NSTextField* typeLabel;

@property(nonatomic, strong) NSButton* finderButton;
@property(nonatomic, strong) NSButton* bambooButton;

@property(nonatomic, strong) NSURL* fileURL;

@property(nonatomic, strong) NSDictionary* viewsForAutolayout;

@end
