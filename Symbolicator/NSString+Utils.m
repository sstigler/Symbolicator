//
//  NSString+Utils.m
//  Symbolicator
//
//  Created by Sergey Sedov on 16/10/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

- (BOOL) endsWith: (NSString *) string {
    return [self endsWith:string options:0];
}

- (BOOL) endsWith: (NSString *) string options: (NSStringCompareOptions) options {
    NSRange range = [self rangeOfString:string options:NSBackwardsSearch | options];
    return NSMaxRange(range) == self.length;
}

@end
