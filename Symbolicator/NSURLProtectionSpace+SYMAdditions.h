//
//  NSURLProtectionSpace+SYMAdditions.h
//  Symbolicator
//
//  Created by Sam Stigler on 3/23/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLProtectionSpace (SYMAdditions)

- (instancetype)initWithURL:(NSURL *)URL
                      realm:(NSString *)realm
       authenticationMethod:(NSString *)authenticationMethod;

@end
