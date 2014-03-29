//
//  SYMBambooClient+Plans.m
//  Symbolicator
//
//  Created by Sam Stigler on 3/29/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import "SYMBambooClient+Plans.h"
#import "SYMBambooClient_Subclass.h"
#import "SYMBambooProject.h"

static NSString* const kPlansPerProjectPathFormat = @"rest/api/latest/projects/%@.json";
static NSString* const kExpandParameterKey = @"expand";
static NSString* const kPlansExpandParameterValue = @"plans";

@implementation SYMBambooClient (Plans)

-  (void)fetchAllPlansForBambooProject:(SYMBambooProject *)project
                              onServer:(SYMBambooServer *)server
                   withCompletionBlock:(void (^)(NSError *))completionBlock
{
    AFHTTPSessionManager* sessionManager = [[self class] sessionManagerForServer:server];
    NSString* pathToFetch = [NSString stringWithFormat:kPlansPerProjectPathFormat, project.key];
    NSDictionary* expandParameters = @{kExpandParameterKey: kPlansExpandParameterValue};
    [sessionManager
     GET:pathToFetch
     parameters:expandParameters
     success:^(NSURLSessionDataTask *task, id responseObject) {
         if (completionBlock != nil)
         {
             completionBlock(nil);
         }
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         if (completionBlock != nil)
         {
             completionBlock(error);
         }
     }];
}

@end