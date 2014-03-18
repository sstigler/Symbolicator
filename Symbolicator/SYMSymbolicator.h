//
//  SYMSymbolicator.h
//  Symbolicator
//
//  Created by Sam Stigler on 3/17/14.
//  Copyright (c) 2014 Sam Stigler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYMSymbolicator : NSObject

+ (void)symbolicateCrashReport:(NSURL *)crashReportURL
                          dSYM:(NSURL *)dSYMURL
           withCompletionBlock:(void (^)(NSString *symbolicatedReport))completionBlock;

@end
