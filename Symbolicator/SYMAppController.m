//
//  SYMAppController.m
//  Symbolicator
//
//  Created by Sam Stigler on 3/13/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import "SYMAppController.h"

static NSString* const kPathToSymbolicateTool = @"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/PrivateFrameworks/DTDeviceKitBase.framework/Versions/A/Resources/symbolicatecrash";

static NSString* const kXcodeBundleID = @"com.apple.dt.Xcode";

@interface SYMAppController ()

@property(nonatomic, assign) IBOutlet NSTextView* symbolicatedView; // NSTextView doesn't support weak references.

@property(nonatomic, copy) NSString* symbolicatedReport;

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
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(concurrentQueue, ^{
        NSPipe* outputPipe = [NSPipe pipe];
        NSFileHandle* outputFileHandle = [outputPipe fileHandleForReading];
        
        NSTask* symbolicationTask = [weakSelf createSymbolicationTaskWithOutputPipe:outputPipe];
        [symbolicationTask launch];
        
        weakSelf.symbolicatedReport = [weakSelf stringFromFileHandle:outputFileHandle];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.symbolicatedView setString:weakSelf.symbolicatedReport];
        });
    });
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


- (NSTask *)createSymbolicationTaskWithOutputPipe:(NSPipe *)outputPipe
{
    NSArray* arguments = @[[self.crashReportURL path],
                           [self.dSYMURL path]];
    
    NSString* developerDirectoryPath = [self developerDirectoryPath];
    NSDictionary* existingEnvironentVariables = [[NSProcessInfo processInfo] environment];
    NSMutableDictionary* environment = [NSMutableDictionary dictionaryWithDictionary:existingEnvironentVariables];
    environment[@"DEVELOPER_DIR"] = developerDirectoryPath;
    
    NSFileHandle* nullFileHandle = [NSFileHandle fileHandleWithNullDevice];
    
    NSTask* symbolicationTask = [[NSTask alloc] init];
    [symbolicationTask setLaunchPath:kPathToSymbolicateTool];
    [symbolicationTask setArguments:arguments];
    [symbolicationTask setEnvironment:environment];
    [symbolicationTask setStandardOutput:outputPipe];
    [symbolicationTask setStandardError:nullFileHandle];
    
    return symbolicationTask;
}


- (NSURL *)XcodeURL
{
    return [[NSWorkspace sharedWorkspace] URLForApplicationWithBundleIdentifier:kXcodeBundleID];
}


- (NSString *)developerDirectoryPath
{
    NSString* XcodePath = [[self XcodeURL] path];
    NSString* developerDirectoryPath = [XcodePath stringByAppendingPathComponent:@"Contents"];
    return [developerDirectoryPath stringByAppendingPathComponent:@"Developer"];
}


- (NSString *)stringFromFileHandle:(NSFileHandle *)readingHandle
{
    NSData* data = [readingHandle readDataToEndOfFile];
    return[[NSString alloc] initWithData:data
                                encoding:NSUTF8StringEncoding];
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
