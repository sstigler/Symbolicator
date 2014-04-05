//
//  SYMBambooClient+Paging.m
//  Symbolicator
//
//  Created by Sam Stigler on 3/29/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import "SYMBambooClient+Paging.h"
#import "SYMBambooClient_Subclass.h"
#import "SYMBambooPaginationManager.h"
#import "SYMBambooProject.h"
#import "SYMBambooServer.h"

@implementation SYMBambooClient (Paging)

- (void)startPagedRequestOnServer:(SYMBambooServer *)server
                              URN:(NSString *)URN
                       parameters:(NSDictionary *)parameters
                      recordClass:(Class)recordClass
                  completionBlock:(void (^)(NSError *error))completionBlock
{
    __weak typeof(self) weakSelf = self;
    
    NSDictionary* nonNilParameters = parameters;
    if (parameters == nil)
    {
        nonNilParameters = @{};
    }
    
    AFHTTPSessionManager* sessionManager = [[self class] sessionManagerForServer:server];
    
    NSDictionary* credentials = [[NSURLCredentialStorage sharedCredentialStorage] credentialsForProtectionSpace:server.urlProtectionSpace];
    NSURLCredential* credential = [[credentials allValues] firstObject];
    
    [sessionManager.requestSerializer setAuthorizationHeaderFieldWithUsername:credential.user
                                                                     password:credential.password];
    [sessionManager
     GET:URN
     parameters:nonNilParameters
     success:^(NSURLSessionDataTask *task, id responseObject) {
         SYMBambooPaginationManager* paginationManager = [[SYMBambooPaginationManager alloc]
                                                          initWithResponseObject:responseObject
                                                          requestURN:URN
                                                          requestData:nonNilParameters
                                                          recordClass:[SYMBambooProject class]];
         if ([paginationManager canRequestNextPage])
         {
             NSDictionary* parametersToUse = [self combineDictionary:nonNilParameters
                                                      withDictionary:[paginationManager nextPageData]];
             [weakSelf
              startPagedRequestOnServer:server
              URN:URN
              parameters:parametersToUse
              recordClass:recordClass
              completionBlock:completionBlock];
         } else
         {
             if (completionBlock != nil)
             {
                 completionBlock(nil);
             }
         }
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         if (completionBlock != nil)
         {
             completionBlock(error);
         }
     }];
}


- (NSDictionary *)combineDictionary:(NSDictionary *)dictionary1
                     withDictionary:(NSDictionary *)dictionary2
{
    NSParameterAssert([dictionary1 isKindOfClass:[NSDictionary class]]);
    NSParameterAssert([dictionary2 isKindOfClass:[NSDictionary class]]);
    
    NSMutableDictionary* mutableDictionary = [dictionary1 mutableCopy];
    [mutableDictionary addEntriesFromDictionary:dictionary2];
    return [mutableDictionary copy];
}

@end
