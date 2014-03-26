//
//  SYMBambooClient.h
//  Symbolicator
//
//  Created by Sam Stigler on 3/23/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import <AFNetworking/AFHTTPSessionManager.h>
#import <Foundation/Foundation.h>

@class SYMBambooServer;

/** 
 All-inclusive Bamboo client that manages AFHTTPSessionManagers for one or more Bamboo servers.
 */
@interface SYMBambooClient : NSObject

/**
 Shared singleton Bamboo client.
 */
+ (instancetype)sharedClient;

/** 
 Registers the given server base URL with the Bamboo client.
 @discussion This is the method that creates a session manager for the given base URL. This method
 does nothing if the base URL is already registered with the Bamboo client.
 @param baseURL The base URL to register with the client.
 */
+ (void)registerBaseURL:(NSString *)baseURL;

/**
 Unregisters the given server base URL from the Bamboo client.
 @discussion This is the method that destroys a pre-existing session manager (if any) for the given
 base URL. This method does nothing if the base URL is not already registered with the Bamboo client.
 @param baseURL The base URL to unregister from the client.
 */
+ (void)unregisterBaseURL:(NSString *)baseURL;

/**
 Fetches the server version of the specified Bamboo server, and updates the persistent store if necessary.
 @param server The Bamboo server to fetch the version number of.
 @return The completion block returns the version number returned, or an error. Either
 the version number or the error can be nil.
 */
- (void)fetchServerVersionOfBambooServer:(SYMBambooServer *)server
                     withCompletionBlock:(void (^)(NSNumber *version, NSError *error))completionBlock;

/**
 Fetches the projects on the specified Bamboo server, and updates the persistent store if necessary.
 @param server The Bamboo server to fetch the projects on.
 @return The completion block returns an array of the projects on the server
 */
- (void)fetchProjectsOnBambooServer:(SYMBambooServer *)server
                withCompletionBlock:(void (^)(NSArray *projects, NSError *error))completionBlock;

@end
