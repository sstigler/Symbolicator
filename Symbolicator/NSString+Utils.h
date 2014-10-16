//
//  NSString+Utils.h
//  Symbolicator
//
//  Created by Sergey Sedov on 16/10/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)

- (BOOL) endsWith: (NSString *) string;
- (BOOL) endsWith: (NSString *) string options: (NSStringCompareOptions) options;

@end
