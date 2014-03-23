//
//  SYMAppDelegate.m
//  Symbolicator
//
//  Created by Sam Stigler on 3/13/14.
//  Copyright (c) 2014 Sam Stigler. All rights reserved.
//
#import <MagicalRecord/CoreData+MagicalRecord.h>

#import "SYMAppDelegate.h"

@implementation SYMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [MagicalRecord setupCoreDataStack];
}


- (void)applicationWillTerminate:(NSNotification *)notification
{
    [MagicalRecord cleanUp];
}

@end
