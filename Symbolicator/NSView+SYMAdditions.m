//
//  NSView+SYMAdditions.m
//  Symbolicator
//
//  Created by Sam Stigler on 5/29/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import "NSView+SYMAdditions.h"

@implementation NSView (SYMAdditions)

- (void)sym_removeAllConstraints
{
    NSArray* allConstraints = self.constraints;
    if ([allConstraints count] > 0)
    {
        [self removeConstraints:allConstraints];
    }

    for (NSView* subview in self.subviews)
    {
        [subview sym_removeAllConstraints];
    }
}

@end
