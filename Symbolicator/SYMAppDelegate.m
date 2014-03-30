//
//  SYMAppDelegate.m
//  Symbolicator
//
//  Created by Sam Stigler on 3/13/14.
//  Copyright (c) 2014 Sam Stigler. All rights reserved.
//
#import <MagicalRecord/CoreData+MagicalRecord.h>

#import "SYMAppDelegate.h"

static BOOL coreDataSetUp;

@implementation SYMAppDelegate

+ (void)initialize
{
    if (coreDataSetUp == NO)
    {
        [[self class] setUpCoreData];
    }
}


+ (void)setUpCoreData
{
    [MagicalRecord setupCoreDataStack];
    coreDataSetUp = YES;
}


+ (BOOL)isCoreDataSetUp
{
    return coreDataSetUp;
}


- (void)applicationWillTerminate:(NSNotification *)notification
{
    [MagicalRecord cleanUp];
}

@end
