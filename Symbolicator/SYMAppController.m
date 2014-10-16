//
//  SYMAppController.m
//  Symbolicator
//
//  Created by Sam Stigler on 3/13/14.
//  Copyright (c) 2014 Sam Stigler. All rights reserved.
//

#import "SYMAppController.h"
#import "SYMLocator.h"
#import "SYMSymbolicator.h"

NSString *const kSearchDirectory = @"kSearchDirectory";

@interface SYMAppController ()

- (IBAction)chooseCrashReport:(id)sender;
- (IBAction)chooseDSYM:(id)sender;
- (IBAction)chooseDSYMFolder:(id)sender;
- (IBAction)symbolicate:(id)sender;
- (IBAction)export:(id)sender;

@end

@implementation SYMAppController


- (id) init {
    if (self = [super init]) {
        NSString *searchFolderPath = [[NSUserDefaults standardUserDefaults] objectForKey:kSearchDirectory];
        if (searchFolderPath) {
            self.dSYMFolder = [NSURL fileURLWithPath:searchFolderPath];
        }
    }
    return self;
}

- (void)chooseCrashReport:(id)sender
{
    __weak typeof(self) weakSelf = self;
    
    NSOpenPanel* reportChooser = [self fileChooserWithMessage:@"Which crash report is it?" fileType:@"crash"];
    [reportChooser
     beginSheetModalForWindow:[NSApp mainWindow]
     completionHandler:^(NSInteger result) {
         if (result == NSFileHandlingPanelOKButton)
         {
             weakSelf.crashReportURL = [reportChooser URL];
             if (self.dSYMFolder) {
                 [self findDSYMFile];
             }
         }
     }];
}

- (void)chooseDSYM:(id)sender
{
    __weak typeof(self) weakSelf = self;
    
    NSOpenPanel* dSYMChooser = [self fileChooserWithMessage:@"Which dSYM goes with the crash report?" fileType:@"dSYM"];
    [dSYMChooser
     beginSheetModalForWindow:[NSApp mainWindow]
     completionHandler:^(NSInteger result) {
         if (result == NSFileHandlingPanelOKButton)
         {
             weakSelf.dSYMURL = [dSYMChooser URL];
         }
     }];
}
    
- (void)chooseDSYMFolder:(id)sender
{
    __weak typeof(self) weakSelf = self;
    
    NSOpenPanel* folderChooser = [self folderChooserWithMessage:@"Choose folder with the dSYM files or Xcode archives."];
    [folderChooser
     beginSheetModalForWindow:[NSApp mainWindow]
     completionHandler:^(NSInteger result) {
         if (result == NSFileHandlingPanelOKButton)
         {
             weakSelf.dSYMFolder = [folderChooser URL];
             weakSelf.dSYMURL = nil;
             if (weakSelf.crashReportURL) {
                 [self.symbolicateButton setTitle:@"Search for the dSYM file"];
                 [self.symbolicateButton setEnabled:YES];
             }
         }
     }];
}

- (void) findDSYMFile {
    
    [self.symbolicateButton setEnabled:NO];
    
    [self.symbolicateButton setTitle:@"Searching for dSYM file..."];
    [SYMLocator findDSYMWithPlistUrl:self.crashReportURL inFolder:self.dSYMFolder completion:^(NSURL * dSYMURL, NSString *version) {
        self.dSYMURL = dSYMURL;
        
        if (self.dSYMURL) {
            [self symbolicate:nil];
        } else {
            NSString *title = [NSString stringWithFormat:@"dSYM file not found for app version: %@", version];
            [self.symbolicateButton setTitle:title];
        }
    }];
}

- (void)symbolicate:(id)sender
{
    if (!self.dSYMURL && self.crashReportURL && self.dSYMFolder) {
        [self findDSYMFile];
        return;
    }
    
    __weak typeof(self) weakSelf = self;

    [[NSUserDefaults standardUserDefaults] setObject:self.dSYMFolder.path forKey:kSearchDirectory];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.symbolicateButton setEnabled:NO];
    [self.symbolicateButton setTitle:@"Symbolication in process.."];
    
    [SYMSymbolicator
     symbolicateCrashReport:self.crashReportURL
     dSYM:self.dSYMURL
     withCompletionBlock:^(NSString *symbolicatedReport) {
         weakSelf.symbolicatedReport = symbolicatedReport;
         [weakSelf.symbolicateButton setEnabled:YES];
         [weakSelf.symbolicateButton setTitle:@"Symbolicate"];
     }];
}


- (void)export:(id)sender
{
    __weak typeof(self) weakSelf = self;
    
    NSSavePanel* exportSheet = [self exportSheet];
    [exportSheet
     beginSheetModalForWindow:[NSApp mainWindow]
     completionHandler:^(NSInteger result) {
         if (result == NSFileHandlingPanelOKButton)
         {
             dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
             dispatch_async(concurrentQueue, ^{
                 NSError* error = nil;
                 BOOL success = [weakSelf.symbolicatedReport
                                 writeToURL:exportSheet.URL
                                 atomically:NO
                                 encoding:NSUTF8StringEncoding
                                 error:&error];
                 
                 if ((success == NO) &&
                     (error != nil))
                 {
                     [weakSelf showAlertForError:error];
                 }
             });
         }
     }];
}


- (NSOpenPanel *) folderChooserWithMessage:(NSString *)message {
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setCanChooseFiles:NO];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setCanCreateDirectories:NO];
    [openPanel setPrompt:@"Choose"];
    [openPanel setMessage:message];
    return openPanel;
}

- (NSOpenPanel *)fileChooserWithMessage:(NSString *)message fileType:(NSString *)extension
{
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setCanChooseFiles:YES];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setAllowedFileTypes:@[extension]];
    [openPanel setCanCreateDirectories:NO];
    [openPanel setPrompt:@"Choose"];
    [openPanel setMessage:message];
    [openPanel setTreatsFilePackagesAsDirectories:YES];
    return openPanel;
}


- (NSSavePanel *)exportSheet
{
    NSSavePanel* savePanel = [NSSavePanel savePanel];
    [savePanel setTitle:@"Export"];
    [savePanel setPrompt:@"Export"];
    [savePanel setAllowedFileTypes:@[@"crash"]];
    [savePanel setTreatsFilePackagesAsDirectories:NO];
    [savePanel setExtensionHidden:NO];
    return savePanel;
}


- (void)showAlertForError:(NSError *)error
{
    NSParameterAssert(error != nil);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAlert* alert = [NSAlert alertWithError:error];
        [alert runModal];
    });
}

@end
