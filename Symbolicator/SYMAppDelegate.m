//
//  SYMAppDelegate.m
//  Symbolicator
//
//  Created by Sam Stigler on 3/13/14.
//  Copyright (c) 2014 Sam Stigler. All rights reserved.
//

#import "SYMAppDelegate.h"

#import "SYMSymbolicateViewController.h"

@interface SYMAppDelegate ()

@property(nonatomic, strong) SYMSymbolicateViewController* symbolicateViewController;

@end

@implementation SYMAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    self.symbolicateViewController = [[SYMSymbolicateViewController alloc] initWithNibName:NSStringFromClass([SYMSymbolicateViewController class])
                                                                                    bundle:nil];
    [self.window setContentView:self.symbolicateViewController.view];
}

@end
