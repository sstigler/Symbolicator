//
//  SYMFilePickerView.h
//  Symbolicator
//
//  Created by Sam Stigler on 5/9/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSInteger, SYMFilePickerMode) {
    SYMFilePickerModeFinderOnly,
    SYMFilePickerModeFinderAndBamboo
};

extern NSString* const kCrashReportUTI;
extern NSString* const kDSYMUTI;

@interface SYMFilePickerView : NSView

/**
 The URL of the selected file, or nil if no file has been selected yet.
 */
@property(nonatomic, readonly) NSURL* fileURL;

/**
 The Uniform Type Identifier (UTI) to allow selection of in the view and any NSOpenPanels that it launches.
 Defaults to public.plain-text .
 */
@property(nonatomic, copy) NSString* fileType;

/**
 The mode that this file picker uses when determining which file selection options (Finder, Bamboo,
 etc.) to display. Defaults to SYMFilePickerModeFinderOnly.
 */
@property(nonatomic, assign) SYMFilePickerMode mode;

@end
