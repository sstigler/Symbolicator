//
//  SYMLocator.m
//  Symbolicator
//
//  Created by Sergey Sedov on 15/10/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import "SYMLocator.h"

@implementation SYMLocator

+ (NSURL *) findDSYMWithPlistUrl: (NSURL *) plistUrl inFolder: (NSURL *) folderURL {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    
    if ([fm fileExistsAtPath:folderURL.path isDirectory:&isDir] && isDir) {
        NSError *error = nil;
        NSString *str = [NSString stringWithContentsOfURL:plistUrl encoding:NSUTF8StringEncoding error:&error];
        
        NSRange versionRange = [str rangeOfString:@"Version:"];
        NSInteger index = versionRange.location + versionRange.length;
        
        NSMutableString *version = [[NSMutableString alloc] init];
        BOOL inVersion = NO;
        
        while (true) {
            char c = [str characterAtIndex:index];
            index ++;
            
            if (c == '(') {
                inVersion = YES;
            } else if (c == ')') {
                break;
            } else if (inVersion) {
                [version appendFormat:@"%c", c];
            }
        }
        
        if (version.length > 0) {
            NSURL *url = [SYMLocator findDSYMForVersion:version inFolder:folderURL];
            return url;
        }
    }

    return nil;
}

+ (NSURL *) findDSYMForVersion: (NSString *) version inFolder: (NSURL *) folderURL {
    
    NSPipe* outputPipe = [NSPipe pipe];
    NSFileHandle* outputFileHandle = [outputPipe fileHandleForReading];
    
    NSTask* task = [self createSearchTaskWithOutputPipe:outputPipe version:version folder:folderURL];
    [task launch];
    [task waitUntilExit];
    
    NSData* data = [outputFileHandle readDataToEndOfFile];
    NSString *result =[[NSString alloc] initWithData:data
                                encoding:NSUTF8StringEncoding];

    NSString *pattern = @"/Contents/Info.plist";
    NSString *dSYMExtension = @".dSYM";
    for (NSString *res in [result componentsSeparatedByString:@"\n"]) {
        if ([res rangeOfString:pattern].location + pattern.length == res.length) {
            NSString *dSYMPath = [res stringByReplacingOccurrencesOfString:pattern withString:@""];
            if ([dSYMPath rangeOfString:dSYMExtension].location + dSYMExtension.length == dSYMPath.length) {
                return [NSURL fileURLWithPath:dSYMPath];
            }
        }
    }
    
    return nil;
}


+ (NSTask *)createSearchTaskWithOutputPipe:(NSPipe *)outputPipe version: (NSString *) version folder: (NSURL *) folderURL
{
    NSArray* arguments = @[@"-rnil",
                           @"--include=Info.plist",
                           [NSString stringWithFormat:@"<string>%@</string>", version],
                           folderURL.path,
                           ];
    
    NSDictionary* existingEnvironentVariables = [[NSProcessInfo processInfo] environment];
    NSMutableDictionary* environment = [NSMutableDictionary dictionaryWithDictionary:existingEnvironentVariables];
    
    NSFileHandle* nullFileHandle = [NSFileHandle fileHandleWithNullDevice];
    
    NSTask* task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/grep"];
    [task setArguments:arguments];
    [task setEnvironment:environment];
    [task setStandardOutput:outputPipe];
    [task setStandardError:nullFileHandle];
    
    return task;
}


@end
