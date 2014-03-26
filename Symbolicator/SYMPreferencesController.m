//
//  SYMPreferencesController.m
//  Symbolicator
//
//  Created by Sam Stigler on 3/23/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "SYMPreferencesController.h"
#import "SYMBambooServer.h"

static NSString* const kBambooServerEntityName = @"BambooServer";
static NSString* const kNoBambooServersMenuPlaceholderString = @"No Bamboo servers are saved.";
static NSString* const kAddBambooServerMenuItemString = @"Add Server...";

NSString* const kSelectedBambooURLDefaultsKey = @"selectedBambooURLIndex";

static NSInteger const kDefaultHTTPPort = 80;
static NSInteger const kDefaultHTTPSPort = 443;

@interface SYMPreferencesController () <NSTableViewDelegate>

@property(nonatomic, weak) IBOutlet NSPanel* preferencesWindow;
@property(nonatomic, weak) IBOutlet NSPanel* addBambooServerSheet;
@property(nonatomic, weak) IBOutlet NSTextField* addBambooServer_URLField;
@property(nonatomic, weak) IBOutlet NSTextField* addBambooServer_UsernameField;
@property(nonatomic, weak) IBOutlet NSSecureTextField* addBambooServer_PasswordField;
@property(nonatomic, weak) IBOutlet NSArrayController* bambooServersArrayControllerForPreferences;
@property(nonatomic, weak) IBOutlet NSTableView* bambooServersTableView;

@property(nonatomic, strong) NSMenu* bambooServersPopUpMenu;
@property(nonatomic, readonly) NSArray* bambooServersToPickFrom;

- (IBAction)showAddBambooServerSheet:(id)sender;
- (IBAction)cancelAddBambooServerSheet:(id)sender;
- (IBAction)addBambooServerFromAddBambooServerSheet:(id)sender;
- (IBAction)removeSelectedBambooServer:(id)sender;

@end


@implementation SYMPreferencesController

- (void)awakeFromNib
{
    NSString* bambooURLToSelect = [[NSUserDefaults standardUserDefaults]
                                   stringForKey:kSelectedBambooURLDefaultsKey];
    if (bambooURLToSelect != nil)
    {
        NSUInteger indexToSelectInTableView = [[self bambooServersToPickFrom]
                                               indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                                                   return [obj isEqualToString:bambooURLToSelect];
                                               }];
        if (indexToSelectInTableView != NSNotFound)
        {
            NSIndexSet* rowToSelect = [NSIndexSet indexSetWithIndex:indexToSelectInTableView];
            [self.bambooServersTableView selectRowIndexes:rowToSelect byExtendingSelection:NO];
        }
    }
}


- (NSArray *)bambooServersToPickFrom
{
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:kBambooServerEntityName];
    [request setResultType:NSDictionaryResultType];
    [request setPropertiesToFetch:@[[self URLPropertyDescription]]];
    
    NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];
    NSArray* servers = [[context executeFetchRequest:request error:nil] valueForKey:SYMBambooServerAttributes.url];
    return servers;
}


- (NSPropertyDescription *)URLPropertyDescription
{
    static NSPropertyDescription* URLPropertyDescription = nil;
    if (URLPropertyDescription == nil)
    {
        NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];
        NSEntityDescription* entity = [NSEntityDescription entityForName:kBambooServerEntityName
                                                  inManagedObjectContext:context];
        URLPropertyDescription = [[entity propertiesByName] valueForKey:SYMBambooServerAttributes.url];
    }
    return URLPropertyDescription;
}


- (NSMenuItem *)emptyServerListMenuPlaceholder
{
    NSMenuItem* placeholder = [[NSMenuItem alloc] initWithTitle:kNoBambooServersMenuPlaceholderString
                                                         action:NULL
                                                  keyEquivalent:@""];
    return placeholder;
}


#pragma mark - Add Bamboo Server


- (NSMenuItem *)addAServerBambooMenuItem
{
    NSMenuItem* addServerMenuItem = [[NSMenuItem alloc] initWithTitle:kAddBambooServerMenuItemString
                                                               action:@selector(showAddBambooServerSheet:)
                                                        keyEquivalent:@""];
    [addServerMenuItem setTarget:self];
    return addServerMenuItem;
}


- (IBAction)showAddBambooServerSheet:(id)sender
{
    [self.preferencesWindow
     beginSheet:self.addBambooServerSheet
     completionHandler:^(NSModalResponse returnCode) {
         
     }];
}


- (IBAction)cancelAddBambooServerSheet:(id)sender
{
    [self clearAllFieldsInAddBambooServerSheet];
    [self.preferencesWindow endSheet:self.addBambooServerSheet
                          returnCode:NSModalResponseCancel];
}


- (IBAction)addBambooServerFromAddBambooServerSheet:(id)sender
{
    [self validateBambooServerURLField];
    [self validateBambooServerUsernameField];
    [self validateBambooServerPasswordField];
    
    if (([self isAddBambooServerPasswordFieldValid] == NO) ||
        ([self isAddBambooServerURLFieldValid] == NO) ||
        ([self isAddBambooServerUsernameFieldValid] == NO))
    {
        NSBeep();
    } else
    {
        [self appendPortNumberToAddBambooServerURLFieldIfItIsMissingOne];
        [self saveNewlyAddedBambooServerToPersistentStore];
        [self.preferencesWindow endSheet:self.addBambooServerSheet
                              returnCode:NSModalResponseOK];
        [self clearAllFieldsInAddBambooServerSheet];
    }
}


- (void)clearAllFieldsInAddBambooServerSheet
{
    [self.addBambooServer_PasswordField setStringValue:@""];
    [self.addBambooServer_URLField setStringValue:@""];
    [self.addBambooServer_UsernameField setStringValue:@""];
}


- (void)validateBambooServerURLField
{
    BOOL URLIsValid = [self isAddBambooServerURLFieldValid];
    if (URLIsValid == NO)
    {
        [self.addBambooServer_URLField setBackgroundColor:[NSColor redColor]];
    } else
    {
        [self.addBambooServer_URLField setBackgroundColor:[NSColor controlColor]];
    }
}


- (void)validateBambooServerUsernameField
{
    BOOL usernameIsValid = [self isAddBambooServerUsernameFieldValid];
    if (usernameIsValid == NO)
    {
        [self.addBambooServer_UsernameField setBackgroundColor:[NSColor redColor]];
    } else
    {
        [self.addBambooServer_UsernameField setBackgroundColor:[NSColor controlColor]];
    }
}


- (void)validateBambooServerPasswordField
{
    BOOL passwordIsValid = [self isAddBambooServerPasswordFieldValid];
    if (passwordIsValid == NO)
    {
        [self.addBambooServer_PasswordField setBackgroundColor:[NSColor redColor]];
    } else
    {
        [self.addBambooServer_PasswordField setBackgroundColor:[NSColor controlColor]];
    }
}


- (BOOL)isAddBambooServerURLFieldValid
{
    NSURL* URL = [NSURL URLWithString:[self.addBambooServer_URLField stringValue]];
    BOOL isSchemeValid = ([[URL scheme] isEqualToString:@"http"] ||
                          [[URL scheme] isEqualToString:@"https"]);
    BOOL isValid = ((URL != nil) &&
                    isSchemeValid &&
                    ([[URL host] length] > 0));
    return isValid;
}


- (BOOL)isAddBambooServerPasswordFieldValid
{
    BOOL isValid = ([[self.addBambooServer_PasswordField stringValue] length] > 1);
    return isValid;
}


- (BOOL)isAddBambooServerUsernameFieldValid
{
    BOOL isValid = ([[self.addBambooServer_UsernameField stringValue] length] > 1);
    return isValid;
}


- (void)appendPortNumberToAddBambooServerURLFieldIfItIsMissingOne
{
    NSURL* URL = [NSURL URLWithString:[self.addBambooServer_URLField stringValue]];
    NSNumber* port = [URL port];
    if (port == nil)
    {
        if ([[URL scheme] isEqualToString:@"http"])
        {
            port = @(kDefaultHTTPPort);
        } else
        {
            port = @(kDefaultHTTPSPort);
        }
        NSString* newURLString = [NSString stringWithFormat:@"%@://%@:%@%@",
                                  [URL scheme],
                                  [URL host],
                                  port,
                                  [URL path]];
        [self.addBambooServer_URLField setStringValue:newURLString];
    }
}


- (void)saveNewlyAddedBambooServerToPersistentStore
{
    __weak typeof(self) weakSelf = self;
    [self willChangeValueForKey:NSStringFromSelector(@selector(bambooServersToPickFrom))];
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        SYMBambooServer* server = [SYMBambooServer MR_createInContext:localContext];
        server.url = [weakSelf.addBambooServer_URLField stringValue];
    }];
    [self didChangeValueForKey:NSStringFromSelector(@selector(bambooServersToPickFrom))];
}


#pragma mark - Remove Bamboo Server


- (IBAction)removeSelectedBambooServer:(id)sender
{
    [self willChangeValueForKey:NSStringFromSelector(@selector(bambooServersToPickFrom))];
    NSString* selectedURL = [self.bambooServersArrayControllerForPreferences selectedObjects][0];
    SYMBambooServer* serverToRemove = [SYMBambooServer MR_findFirstByAttribute:SYMBambooServerAttributes.url
                                                                     withValue:selectedURL];
    [serverToRemove MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    [self didChangeValueForKey:NSStringFromSelector(@selector(bambooServersToPickFrom))];
}


#pragma mark - Bamboo Server list table view delegate


- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSString* selectedURL = [self.bambooServersArrayControllerForPreferences selectedObjects][0];
    [[NSUserDefaults standardUserDefaults] setObject:selectedURL
                                              forKey:kSelectedBambooURLDefaultsKey];
}

@end
