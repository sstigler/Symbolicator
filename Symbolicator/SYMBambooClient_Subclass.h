//
//  SYMBambooClient_Subclass.h
//  Symbolicator
//
//  Created by Sam Stigler on 3/28/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import "SYMBambooClient.h"

extern NSString* const kProjectsPath;

@interface SYMBambooClient ()

+ (AFHTTPSessionManager *)sessionManagerForServer:(SYMBambooServer *)server;

@end
