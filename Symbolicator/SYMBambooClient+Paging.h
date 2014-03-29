//
//  SYMBambooClient+Paging.h
//  Symbolicator
//
//  Created by Sam Stigler on 3/29/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import "SYMBambooClient.h"

@class SYMBambooPaginationManager;
@class SYMBambooServer;

@interface SYMBambooClient (Paging)

/**
 Starts a paged request for the given URN, with the given parameters.
 @param server The Bamboo server on which to start the paged request.
 @param URN The URN to start the paged request for.
 @param parameters The parameters (if any) to pass into the paged request. Can be nil.
 @param recordClass The entity class to create instances of from the response.
 @param completionBlock The completion block to execute when the method has finished receiving 
 responses for the paged request. Can be nil.
 */
- (void)startPagedRequestOnServer:(SYMBambooServer *)server
                              URN:(NSString *)URN
                       parameters:(NSDictionary *)parameters
                      recordClass:(Class)recordClass
                  completionBlock:(void(^)(NSError* error))completionBlock;

@end
