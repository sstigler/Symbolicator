//
//  SYMAppController.m
//  Symbolicator
//
//  Created by Sam Stigler on 3/13/14.
//  Copyright (c) 2014 Sam Stigler. All rights reserved.
//

#import "SYMAppController.h"
#import "SYMSymbolicator.h"

@interface SYMAppController ()

- (IBAction)chooseCrashReport:(id)sender;
- (IBAction)chooseDSYM:(id)sender;
- (IBAction)symbolicate:(id)sender;
- (IBAction)export:(id)sender;

@end

@implementation SYMAppController

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


- (void)symbolicate:(id)sender
{
    __weak typeof(self) weakSelf = self;
    
    [SYMSymbolicator
     symbolicateCrashReport:self.crashReportURL
     dSYM:self.dSYMURL
     withCompletionBlock:^(NSString *symbolicatedReport) {
         weakSelf.symbolicatedReport = symbolicatedReport;
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
    [openPanel setCanChooseDirectories:NO];
    [openPanel setCanChooseFiles:YES];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setAllowedFileTypes:@[extension]];
    [openPanel setCanCreateDirectories:NO];
    [openPanel setPrompt:@"Choose"];
    [openPanel setMessage:message];
    [openPanel setTreatsFilePackagesAsDirectories:NO];
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
