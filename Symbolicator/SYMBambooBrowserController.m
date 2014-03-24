//
//  SYMBambooBrowserController.m
//  Symbolicator
//
//  Created by Sam Stigler on 3/23/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "SYMBambooBrowserController.h"
#import "SYMBambooServer.h"

typedef NS_ENUM(NSInteger, SYMBambooBrowserColumn)
{
    SYMBambooBrowserColumnProjects = 0,
    SYMBambooBrowserColumnPlans = 1,
    SYMBambooBrowserColumnBuilds = 2,
    SYMBambooBrowserColumnArtifacts = 3
};

@interface SYMBambooBrowserController () <NSBrowserDelegate>

@end

@implementation SYMBambooBrowserController

#pragma mark - Browser delegate methods

- (NSInteger)browser:(NSBrowser *)sender numberOfRowsInColumn:(NSInteger)column
{
    NSInteger numberOfRows = 0;
    
    if (column == SYMBambooBrowserColumnProjects)
    {
        return [self numberOfServers];
    } else if (column == SYMBambooBrowserColumnPlans)
    {
        NSIndexPath* selectionIndexPath = [sender selectionIndexPath];
        if (selectionIndexPath == nil)
        {
            numberOfRows = 0;
        } else
        {
            
        }
        
    }
    
    return numberOfRows;
}


- (NSInteger)numberOfServers
{
    NSNumber* serverCount = [SYMBambooServer MR_numberOfEntities];
    return [serverCount integerValue];
}


- (NSInteger)numberOfPlansInProjectWithURL:(NSString *)projectURLString
{
    
}

@end
