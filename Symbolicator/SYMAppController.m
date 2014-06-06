//
//  SYMAppController.m
//  Symbolicator
//
//  Created by Sam Stigler on 3/13/14.
//  Copyright (c) 2014 Sam Stigler. All rights reserved.
//

#import "SYMAppController.h"

#import "SYMFilePickerView.h"
#import "SYMSymbolicator.h"

@interface SYMAppController () <SYMFilePickerViewDelegate>

@property(nonatomic, weak) IBOutlet SYMFilePickerView* crashReportFilePickerView;
@property(nonatomic, weak) IBOutlet SYMFilePickerView* dSYMFilePickerView;

- (IBAction)symbolicate:(id)sender;
- (IBAction)export:(id)sender;

@end

@implementation SYMAppController

- (void)awakeFromNib
{
    [self.crashReportFilePickerView setFileType:kCrashReportUTI];
    [self.crashReportFilePickerView setMode:SYMFilePickerModeFinderOnly];

    [self.dSYMFilePickerView setFileType:kDSYMUTI];
    [self.dSYMFilePickerView setMode:SYMFilePickerModeFinderAndBamboo];
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


#pragma mark - SYMFilePickerView delegate methods


- (void)filePickerView:(SYMFilePickerView *)filePickerView didPickFileURL:(NSURL *)fileURL
{
    if ([filePickerView.fileType isEqualToString:kCrashReportUTI])
    {
        self.crashReportURL = fileURL;
    }
    else if ([filePickerView.fileType isEqualToString:kDSYMUTI])
    {
        self.dSYMURL = fileURL;
    }
}

@end
