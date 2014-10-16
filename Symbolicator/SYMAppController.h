//
//  SYMAppController.h
//  Symbolicator
//
//  Created by Sam Stigler on 3/13/14.
//  Copyright (c) 2014 Sam Stigler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYMAppController : NSObject

@property(nonatomic, strong) NSURL* crashReportURL;
@property(nonatomic, strong) NSURL* dSYMURL;
@property(nonatomic, strong) NSURL* dSYMFolder;

@property(nonatomic, copy) NSString* symbolicatedReport;

@end