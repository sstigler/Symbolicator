//
//  SYMBambooClient+Plans.h
//  Symbolicator
//
//  Created by Sam Stigler on 3/29/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import "SYMBambooClient.h"

@class SYMBambooProject;
@class SYMBambooServer;

@interface SYMBambooClient (Plans)

/**
 Fetches all the plans for the specified Bamboo project on the specified Bamboo server, and updates
 the persistent store if necessary.
 @param project The Bamboo project to fetch the plans on.
 @param server The Bamboo server to fetch the plans on.
 @param completionBlock The completion block to execute when the response is received.
 */
- (void)fetchAllPlansForBambooProject:(SYMBambooProject *)project
                             onServer:(SYMBambooServer *)server
                  withCompletionBlock:(void (^)(NSError *error))completionBlock;

@end
