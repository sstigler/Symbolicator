//
//  NSURLProtectionSpace+SYMAdditions.m
//  Symbolicator
//
//  Created by Sam Stigler on 3/23/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import "NSURLProtectionSpace+SYMAdditions.h"

@implementation NSURLProtectionSpace (SYMAdditions)

- (instancetype)initWithURL:(NSURL *)URL
                      realm:(NSString *)realm
       authenticationMethod:(NSString *)authenticationMethod
{
    NSParameterAssert(URL != nil);
    NSParameterAssert(authenticationMethod != nil);
    
    typeof(self) protectionSpace = [self initWithHost:[URL host]
                                                 port:[[URL port] integerValue]
                                             protocol:[URL scheme]
                                                realm:realm
                                 authenticationMethod:authenticationMethod];
    return protectionSpace;
}

@end
