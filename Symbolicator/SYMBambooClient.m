//
//  SYMBambooClient.m
//  Symbolicator
//
//  Created by Sam Stigler on 3/23/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import <MagicalRecord/CoreData+MagicalRecord.h>
#import <MMRecord/AFMMRecordResponseSerializationMapper.h>
#import "SYMBambooClient.h"
#import "SYMBambooPlan.h"
#import "SYMBambooProject.h"
#import "SYMBambooServer.h"

static NSString* const kServerInformationPath = @"rest/api/latest/info.json";
NSString* const kProjectsPath = @"rest/api/latest/projects.json";
static NSString* const kPlansPath = @"rest/api/latest/plans.json";
static NSString* const kServerVersionJSONKey = @"version";

/**
 Keeps a strong reference to each of the AFHTTPSessionManagers (one per server).
 @discussion The keys are server base URL strings and the values are their corresponding 
 AFHTTPSessionManagers.
 */
static NSMutableDictionary* sessionManagersByServerURL;

@implementation SYMBambooClient

+ (instancetype)sharedClient
{
    static SYMBambooClient* clientSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        clientSingleton = [[SYMBambooClient alloc] init];
    });
    return clientSingleton;
}


+ (void)registerBaseURL:(NSString *)baseURL
{
    NSParameterAssert(baseURL != nil);
    
    [[self class] initializeSessionManagersDictionaryIfNecessary];
    
    if ([[sessionManagersByServerURL allKeys] containsObject:baseURL] == NO)
    {
        [self setSessionManager:[self createJSONHTTPSessionManagerWithBaseURL:baseURL]
                     forBaseURL:baseURL];
    }
}


+ (void)unregisterBaseURL:(NSString *)baseURL
{
    NSParameterAssert(baseURL != nil);
    
    [sessionManagersByServerURL removeObjectForKey:baseURL];
}


- (void)fetchServerVersionOfBambooServer:(SYMBambooServer *)server
                     withCompletionBlock:(void (^)(NSNumber *version, NSError *error))completionBlock
{
    
    if (completionBlock != nil)
    {
        AFHTTPSessionManager* sessionManager = [[self class] sessionManagerForServer:server];
        [sessionManager
         GET:kServerInformationPath
         parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             NSString* versionString = [responseObject valueForKey:kServerVersionJSONKey];
             NSNumber* versionNumber = @([versionString integerValue]);
             [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                 server.version = versionNumber;
             }];
             completionBlock(versionNumber, nil);
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             completionBlock(nil, error);
         }];
    }
}


#pragma mark - AFHTTPSessionManager utility methods


+ (AFHTTPSessionManager *)createJSONHTTPSessionManagerWithBaseURL:(NSString *)baseURLString
{
    NSParameterAssert(baseURLString != nil);
    NSURL* baseURL = [NSURL URLWithString:baseURLString];
    NSAssert(baseURL != nil,
             @"Expected baseURLString to represent a valid URL.");
    
    AFHTTPSessionManager* sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    sessionManager.responseSerializer = [[self class] MMRecordResponseSerializer];
    return sessionManager;
}


+ (void)setSessionManager:(AFHTTPSessionManager *)sessionManager forBaseURL:(NSString *)baseURL
{
    NSParameterAssert(sessionManager != nil);
    NSParameterAssert(baseURL != nil);
    
    [[self class] initializeSessionManagersDictionaryIfNecessary];
    
    sessionManagersByServerURL[baseURL] = sessionManager;
}


+ (AFHTTPSessionManager *)sessionManagerForServer:(SYMBambooServer *)server
{
    NSParameterAssert(server != nil);
    
    AFHTTPSessionManager* sessionManager = [[self class] sessionManagerForBaseURL:server.url];
    if (sessionManager == nil)
    {
        [self registerBaseURL:server.url];
        sessionManager = [[self class] sessionManagerForBaseURL:server.url];
    }
    
    return sessionManager;
}


+ (AFHTTPSessionManager *)sessionManagerForBaseURL:(NSString *)baseURL
{
    NSParameterAssert(baseURL != nil);
    
    [[self class] initializeSessionManagersDictionaryIfNecessary];
    
    return sessionManagersByServerURL[baseURL];
}


+ (void)initializeSessionManagersDictionaryIfNecessary
{
    if (sessionManagersByServerURL == nil)
    {
        sessionManagersByServerURL = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
}


+ (AFMMRecordResponseSerializer *)MMRecordResponseSerializer
{
    AFMMRecordResponseSerializationMapper* responseSerializationMapper = [[AFMMRecordResponseSerializationMapper alloc] init];
    [responseSerializationMapper registerEntityName:NSStringFromClass([SYMBambooServer class])
                           forEndpointPathComponent:kServerInformationPath];
    [responseSerializationMapper registerEntityName:NSStringFromClass([SYMBambooProject class])
                           forEndpointPathComponent:kProjectsPath];
    [responseSerializationMapper registerEntityName:NSStringFromClass([SYMBambooPlan class])
                           forEndpointPathComponent:kPlansPath];
    
    AFJSONResponseSerializer* JSONResponseSerializer = [[AFJSONResponseSerializer alloc] init];
    NSManagedObjectContext* context = [NSManagedObjectContext MR_contextForCurrentThread];
    AFMMRecordResponseSerializer* MMRecordResponseSerializer = [AFMMRecordResponseSerializer
                                                                serializerWithManagedObjectContext:context
                                                                responseObjectSerializer:JSONResponseSerializer
                                                                entityMapper:responseSerializationMapper];
    return MMRecordResponseSerializer;
}


#pragma mark - Helper methods


- (id)JSONObjectFromData:(NSData *)data error:(NSError *)error
{
    id JSONObject = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                      error:&error];
    return JSONObject;
}

@end
