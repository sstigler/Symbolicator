//
//  SYMBambooClient.h
//  Symbolicator
//
//  Created by Sam Stigler on 3/23/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SYMBambooServer;

@interface SYMBambooClient : NSObject

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
