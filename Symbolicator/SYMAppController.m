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
- (IBAction)findDSYMFile:(id)sender;
- (IBAction)export:(id)sender;

@end

@implementation SYMAppController


- (instancetype) init {
    if (self = [super init]) {
        NSString *searchFolderPath = [[NSUserDefaults standardUserDefaults] objectForKey:kSearchDirectory];
        if (searchFolderPath) {
            self.dSYMURL = [NSURL fileURLWithPath:searchFolderPath];
        }
        [self updateStatus];
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
             [weakSelf updateStatus];
         }
     }];
}

- (void)chooseDSYM:(id)sender
{
    __weak typeof(self) weakSelf = self;
    
    NSOpenPanel* chooser = [self fileChooserWithMessage:@"Select dSYM file or a folder which contains dSYM file" fileType:@"dSYM"];
    [chooser
     beginSheetModalForWindow:[NSApp mainWindow]
     completionHandler:^(NSInteger result) {
         if (result == NSFileHandlingPanelOKButton)
         {
             weakSelf.dSYMURL = [chooser URL];
             [weakSelf updateStatus];
         }
     }];
}

- (void) findDSYMFile:(id) sender {
    [self setEnabled:NO withStatusString:@"Searching for dSYM file..."];
    __weak typeof(self) weakSelf = self;
    
    [SYMLocator findDSYMWithPlistUrl:self.crashReportURL inFolder:self.dSYMURL completion:^(NSURL * dSYMURL, NSString *version) {
        if (dSYMURL) {
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.dSYMURL.path forKey:kSearchDirectory];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            weakSelf.dSYMURL = dSYMURL;
            [weakSelf symbolicate:nil];
        } else {
            [weakSelf setEnabled:NO withStatusString:[NSString stringWithFormat:@"dSYM file not found for app version: %@", version]];
        }
    }];
}

- (void)symbolicate:(id)sender
{
    [self setEnabled:NO withStatusString:@"Symbolication in process..."];
    __weak typeof(self) weakSelf = self;
    
    [SYMSymbolicator
     symbolicateCrashReport:self.crashReportURL
     dSYM:self.dSYMURL
     withCompletionBlock:^(NSString *symbolicatedReport) {
         weakSelf.symbolicatedReport = symbolicatedReport;
         [weakSelf setEnabled:YES withStatusString:@"Symbolicate"];
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

- (NSOpenPanel *)fileChooserWithMessage:(NSString *)message fileType:(NSString *)extension
{
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:YES];
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

- (void) updateStatus {
    if (self.dSYMURL && self.crashReportURL) {
        NSString *statusString;
        if ([[self.dSYMURL pathExtension] isEqualToString:@"dSYM"]) {
            statusString = @"Symbolicate";
        } else {
            statusString = @"Search for the dSYM file";
        }
        [self setEnabled:YES withStatusString:statusString];
    } else {
        [self setEnabled:NO withStatusString:@"Select crash report and a folder with dSYMs or concrete dSYM file."];
    }
}

- (void) setEnabled: (BOOL) enabled withStatusString: (NSString *) string {
    self.canSymbolicate = enabled;
    self.symbolicateStatus = string;
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
