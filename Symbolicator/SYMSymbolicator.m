//
//  SYMSymbolicator.m
//  Symbolicator
//
//  Created by Sam Stigler on 3/17/14.
//  Copyright (c) 2014 Sam Stigler. All rights reserved.
//

#import "SYMSymbolicator.h"

static NSString* const kPathToSymbolicateTool = @"/Applications/Xcode.app/Contents/SharedFrameworks/DTDeviceKitBase.framework/Versions/A/Resources/symbolicatecrash";

static NSString* const kXcodeBundleID = @"com.apple.dt.Xcode";

@implementation SYMSymbolicator

+ (void)symbolicateCrashReport:(NSURL *)crashReportURL
                          dSYM:(NSURL *)dSYMURL
           withCompletionBlock:(void (^)(NSString *))completionBlock
{
    if (completionBlock != nil)
    {
        __weak typeof(self) weakSelf = self;
        
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(concurrentQueue, ^{
            NSPipe* outputPipe = [NSPipe pipe];
            NSFileHandle* outputFileHandle = [outputPipe fileHandleForReading];
            
            NSTask* symbolicationTask = [weakSelf
                                         createSymbolicationTaskWithOutputPipe:outputPipe
                                         crashReportURL:crashReportURL
                                         dSYMURL:dSYMURL];
            [symbolicationTask launch];
            [symbolicationTask waitUntilExit];
            
            NSString* symbolicated = [weakSelf stringFromFileHandle:outputFileHandle];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(symbolicated);
            });
        });
    }
}


#pragma mark - Helper methods


+ (NSTask *)createSymbolicationTaskWithOutputPipe:(NSPipe *)outputPipe
                                   crashReportURL:(NSURL *)crashReportURL
                                          dSYMURL:(NSURL *)dSYMURL
{
    NSArray* arguments = @[[crashReportURL path],
                           [dSYMURL path]];
    
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


+ (NSURL *)XcodeURL
{
    return [[NSWorkspace sharedWorkspace] URLForApplicationWithBundleIdentifier:kXcodeBundleID];
}


+ (NSString *)developerDirectoryPath
{
    NSString* XcodePath = [[self XcodeURL] path];
    NSString* developerDirectoryPath = [XcodePath stringByAppendingPathComponent:@"Contents"];
    return [developerDirectoryPath stringByAppendingPathComponent:@"Developer"];
}


+ (NSString *)stringFromFileHandle:(NSFileHandle *)readingHandle
{
    NSData* data = [readingHandle readDataToEndOfFile];
    return[[NSString alloc] initWithData:data
                                encoding:NSUTF8StringEncoding];
}


@end
