//
//  NSView+SYMAdditions.h
//  Symbolicator
//
//  Created by Sam Stigler on 5/29/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView (SYMAdditions)

/**
 Recursively removes all autolayout constraints from the view and its subviews.
 */
- (void)sym_removeAllConstraints;

@end
