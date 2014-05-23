//
//  SYMSymbolicateViewController.h
//  Symbolicator
//
//  Created by Sam Stigler on 5/22/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SYMSymbolicateViewController : NSViewController

@property(nonatomic, weak) IBOutlet NSView* leftFilePickerView;
@property(nonatomic, weak) IBOutlet NSView* rightFilePickerView;

@end
