//
//  SYMBambooPaginationManager.h
//  Symbolicator
//
//  Created by Sam Stigler on 3/28/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYMBambooPaginationManager : NSObject

- (instancetype)initWithResponseObject:(NSDictionary *)dict
                            requestURN:(NSString *)requestURN
                           requestData:(NSDictionary *)requestData
                           recordClass:(Class)recordClass;

- (BOOL)canRequestNextPage;

- (NSDictionary *)nextPageData;

- (NSString *)nextPageURN;

@end
