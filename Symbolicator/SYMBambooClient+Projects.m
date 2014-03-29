//
//  SYMBambooClient+Projects.m
//  Symbolicator
//
//  Created by Sam Stigler on 3/28/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "SYMBambooClient+Paging.h"
#import "SYMBambooClient+Projects.h"
#import "SYMBambooClient_Subclass.h"
#import "SYMBambooPaginationManager.h"
#import "SYMBambooProject.h"

@implementation SYMBambooClient (Projects)

- (void)fetchProjectsOnBambooServer:(SYMBambooServer *)server
                withCompletionBlock:(void (^)(NSError *error))completionBlock
{
    [self
     startPagedRequestOnServer:server
     URN:kProjectsPath
     parameters:nil
     recordClass:[SYMBambooProject class]
     completionBlock:completionBlock];
}

@end
