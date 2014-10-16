//
//  SYMLocator.m
//  Symbolicator
//
//  Created by Sergey Sedov on 15/10/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import "SYMLocator.h"

@interface SYMLocator ()

@property (nonatomic, strong) NSURL *crashReportURL;
@property (nonatomic, strong) NSURL *folderURL;
@property (nonatomic, copy) void(^completion)(NSURL *dSYMURL, NSString *version);

@end

@implementation SYMLocator

+ (void) findDSYMWithPlistUrl: (NSURL *) crashReportURL inFolder: (NSURL *) folderURL completion: (void(^)(NSURL * dSYMURL, NSString *version)) completion {
    
    SYMLocator *locator = [SYMLocator new];
    locator.crashReportURL = crashReportURL;
    locator.folderURL = folderURL;
    locator.completion = completion;
    
    [locator execute];
}

- (void) execute {
    NSString *version = [self crashReportVersion];
    if (version.length > 0) {
        [self searchDSYM: version];
    } else {
        self.completion(nil, version);
    }
}

- (NSString *) crashReportVersion {
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    
    if ([fm fileExistsAtPath:self.folderURL.path isDirectory:&isDir] && isDir) {
        NSError *error = nil;
        NSString *str = [NSString stringWithContentsOfURL:self.crashReportURL encoding:NSUTF8StringEncoding error:&error];
        
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
        
        return version;
    }

    return nil;
}

- (NSURL *) searchDSYM: (NSString *) version {
    
    NSPipe* outputPipe = [NSPipe pipe];
    NSFileHandle* outputFileHandle = [outputPipe fileHandleForReading];
    
    
    NSTask* task = [self createSearchTaskWithOutputPipe:outputPipe version:version folder:self.folderURL];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [task launch];
        [task waitUntilExit];
        
        NSData* data = [outputFileHandle readDataToEndOfFile];
        NSString *result =[[NSString alloc] initWithData:data
                                                encoding:NSUTF8StringEncoding];
        
        NSString *pattern = @"/Contents/Info.plist";
        NSString *dSYMExtension = @".dSYM";
        
        NSURL *dSYMURL = nil;
        for (NSString *res in [result componentsSeparatedByString:@"\n"]) {
            if ([res rangeOfString:pattern].location + pattern.length == res.length) {
                NSString *dSYMPath = [res stringByReplacingOccurrencesOfString:pattern withString:@""];
                if ([dSYMPath rangeOfString:dSYMExtension].location + dSYMExtension.length == dSYMPath.length) {
                    dSYMURL = [NSURL fileURLWithPath:dSYMPath];
                    break;
                }
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            self.completion(dSYMURL, version);
        });
    });
    return nil;
}

- (NSTask *)createSearchTaskWithOutputPipe:(NSPipe *)outputPipe version: (NSString *) version folder: (NSURL *) folderURL
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
