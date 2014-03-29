//
//  SYMBambooClient+Projects.h
//  Symbolicator
//
//  Created by Sam Stigler on 3/28/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import "SYMBambooClient.h"

@interface SYMBambooClient (Projects)

/**
 Fetches the projects on the specified Bamboo server, and updates the persistent store if necessary.
 @param server The Bamboo server to fetch the projects on.
 @param completionBlock The completion block to execute when the response is received.
 */
- (void)fetchProjectsOnBambooServer:(SYMBambooServer *)server
                withCompletionBlock:(void (^)(NSError *error))completionBlock;

@end
