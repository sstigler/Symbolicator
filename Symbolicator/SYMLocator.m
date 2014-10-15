//
//  SYMLocator.m
//  Symbolicator
//
//  Created by Sergey Sedov on 15/10/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import "SYMLocator.h"

NSString *const kDSYMSearchDirectory = @"/Users/sidslog/Public/Archives";

@implementation SYMLocator

+ (NSURL *) findDSYMWithPlistUrl: (NSURL *) plistUrl {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    
    if ([fm fileExistsAtPath:kDSYMSearchDirectory isDirectory:&isDir] && isDir) {
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
            NSURL *url = [SYMLocator findDSYMForVersion:version];
            return url;
        }
    }

    return nil;
}

+ (NSURL *) findDSYMForVersion: (NSString *) version {
    
    NSPipe* outputPipe = [NSPipe pipe];
    NSFileHandle* outputFileHandle = [outputPipe fileHandleForReading];
    
    NSTask* task = [self createSearchTaskWithOutputPipe:outputPipe andVersion:version];
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


+ (NSTask *)createSearchTaskWithOutputPipe:(NSPipe *)outputPipe andVersion: (NSString *) version
{
    NSArray* arguments = @[@"-rnil",
                           @"--include=Info.plist",
                           [NSString stringWithFormat:@"<string>%@</string>", version],
                           kDSYMSearchDirectory,
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
