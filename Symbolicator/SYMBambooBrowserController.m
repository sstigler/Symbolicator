//
//  SYMBambooBrowserController.m
//  Symbolicator
//
//  Created by Sam Stigler on 3/23/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "SYMBambooArtifact.h"
#import "SYMBambooBrowserController.h"
#import "SYMBambooBuild.h"
#import "SYMBambooClient.h"
#import "SYMBambooProject.h"
#import "SYMBambooPlan.h"
#import "SYMBambooServer.h"
#import "SYMNotificationConstants.h"
#import "SYMTreeNode.h"
#import "SYMPreferencesController.h"

typedef NS_ENUM(NSInteger, SYMBambooBrowserColumn)
{
    SYMBambooBrowserColumnProjects = 0,
    SYMBambooBrowserColumnPlans = 1,
    SYMBambooBrowserColumnBuilds = 2,
    SYMBambooBrowserColumnArtifacts = 3
};

@interface SYMBambooBrowserController () <NSBrowserDelegate>

@property(nonatomic, weak) IBOutlet NSBrowser* browser;

@property(nonatomic, strong) SYMBambooClient* bambooClient;

// Cached values.
@property(nonatomic, assign) BOOL isProjectsColumnValid;
@property(nonatomic, assign) BOOL isPlansColumnValid;
@property(nonatomic, assign) BOOL isBuildsColumnValid;
@property(nonatomic, assign) BOOL isArtifactsColumnValid;
@property(nonatomic, strong) SYMBambooServerID* objectIDOfSelectedServer;
@property(nonatomic, strong) SYMBambooProjectID* objectIDOfSelectedProject;

@end

static NSString* const kProjectsColumnTitle = @"Projects";
static NSString* const kPlansColumnTitle = @"Plans";
static NSString* const kBuildsColumnTitle = @"Builds";
static NSString* const kArtifactsColumnTitle = @"Artifacts";

@implementation SYMBambooBrowserController

- (instancetype)init
{
    self = [super init];
    if (self != nil)
    {
        _bambooClient = [[SYMBambooClient alloc] init];
        
        [self registerForNotifications];
        
        [[SYMBambooServer selectedServer] prefetchProjects];
    }
    return self;
}


- (void)registerForNotifications
{
    __weak typeof(self) weakSelf = self;
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center
     addObserverForName:NSUserDefaultsDidChangeNotification
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         [[SYMBambooServer selectedServer] prefetchProjects];
         [weakSelf.browser loadColumnZero];
     }];
    
    [center
     addObserverForName:SYMBambooProjectsUpdatedNotification
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         NSAssert([[note object] isKindOfClass:[SYMBambooServer class]],
                  @"Expected notification's object to be a SYMBambooServer.");
         SYMBambooServer* server = (SYMBambooServer *)[note object];
         [weakSelf prefetchAllBuildPlansForAllKnownProjectsOnServer:server];
         weakSelf.isArtifactsColumnValid = NO;
         weakSelf.isBuildsColumnValid = NO;
         weakSelf.isPlansColumnValid = NO;
         weakSelf.isProjectsColumnValid = YES;
         [weakSelf.browser reloadColumn:SYMBambooBrowserColumnProjects];
     }];
    
    [center
     addObserverForName:SYMBambooPlansUpdatedNotification
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         NSAssert([[note object] isKindOfClass:[SYMBambooPlan class]],
                  @"Expected notification's object to be a SYMBambooPlan.");
         SYMBambooProject* project = (SYMBambooProject *)[note object];
         // TODO: Prefetch all builds for all known plans for this project.
         weakSelf.isArtifactsColumnValid = NO;
         weakSelf.isBuildsColumnValid = NO;
         weakSelf.isPlansColumnValid = YES;
         weakSelf.isProjectsColumnValid = YES;
         [weakSelf.browser reloadColumn:SYMBambooBrowserColumnPlans];
     }];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Browser delegate methods


/**
 @return The currently-selected server.
 */
- (id)rootItemForBrowser:(NSBrowser *)browser
{
    SYMBambooServer* selectedServer = [SYMBambooServer selectedServer];
    return selectedServer;
}


- (NSInteger)browser:(NSBrowser *)browser numberOfChildrenOfItem:(id)item
{
    NSParameterAssert([item conformsToProtocol:@protocol(SYMTreeNode)]);
    return [item numberOfChildren];
}


- (id)browser:(NSBrowser *)browser child:(NSInteger)index ofItem:(id)item
{
    NSParameterAssert([item conformsToProtocol:@protocol(SYMTreeNode)]);
    return [item childAtIndex:index];
}


- (BOOL)browser:(NSBrowser *)browser isLeafItem:(id)item
{
    NSParameterAssert([item conformsToProtocol:@protocol(SYMTreeNode)]);
    return [item isLeaf];
}


- (BOOL)browser:(NSBrowser *)sender isColumnValid:(NSInteger)column
{
    BOOL isValid = NO;
    switch (column) {
        case SYMBambooBrowserColumnProjects:
            isValid = self.isProjectsColumnValid;
            break;
        case SYMBambooBrowserColumnPlans:
            isValid = self.isPlansColumnValid;
            break;
        case SYMBambooBrowserColumnBuilds:
            isValid = self.isBuildsColumnValid;
            break;
        case SYMBambooBrowserColumnArtifacts:
            isValid = self.isArtifactsColumnValid;
            break;
    }
    return isValid;
}


#pragma mark - Interaction with model


- (void)prefetchAllBuildPlansForAllKnownProjectsOnServer:(SYMBambooServer *)server
{
    NSManagedObjectContext* context = [NSManagedObjectContext MR_contextForCurrentThread];
    NSPredicate* predicate = [self predicateMatchingAllProjectsOnServer:server];
    NSArray* allProjects = [SYMBambooProject MR_findAllWithPredicate:predicate
                                                           inContext:context];
    for (SYMBambooProject* project in allProjects)
    {
        [project prefetchPlans];
    }
}


#pragma mark - Helper methods


- (NSPredicate *)predicateMatchingAllProjectsOnServer:(SYMBambooServer *)server
{
    NSString* serverURLKeyPath = [NSString stringWithFormat:@"%@.%@",
                                  SYMBambooProjectRelationships.server,
                                  SYMBambooServerAttributes.url];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K MATCHES %@",
                              serverURLKeyPath, server.url];
    return predicate;
}

@end
