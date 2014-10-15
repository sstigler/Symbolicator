//
//  SYMLocator.m
//  Symbolicator
//
//  Created by Sergey Sedov on 15/10/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import "SYMLocator.h"

NSString *const kDefaultArchiveDirectory = @"/Public/Archives";
NSString *const kApplicationName = @"Boardmaps";

@implementation SYMLocator

+ (NSURL *) findDSYMWithPlistUrl: (NSURL *) plistUrl {
    NSError *error = nil;
    NSString *str = [NSString stringWithContentsOfURL:plistUrl encoding:NSUTF8StringEncoding error:&error];
    
    NSRange versionRange = [str rangeOfString:@"Version:         "];
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

    return nil;
}

+ (NSURL *) findDSYMForVersion: (NSString *) version {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *archivesDir = [NSHomeDirectory() stringByAppendingString:kDefaultArchiveDirectory];
    NSError *error = nil;
    NSArray *list = [fm contentsOfDirectoryAtPath:archivesDir error:&error];
    assert(error == nil);
    
    for (NSString *fileName in list) {
        NSString *dirName = [archivesDir stringByAppendingPathComponent:fileName];
        
        if ([fileName isEqualToString:@".DS_Store"]) {
            continue;
        }
        NSArray *archivesList = [fm contentsOfDirectoryAtPath:dirName error:&error];
        assert(error == nil);
        
        for (NSString *archiveName in archivesList) {
            NSString *archiveDir = [dirName stringByAppendingPathComponent:archiveName];
            
            if ([archiveName isEqualToString:@".DS_Store"]) {
                continue;
            }
            
            NSArray *contentList = [fm contentsOfDirectoryAtPath:archiveDir error:&error];
            assert(error == nil);
            
            for (NSString *file in contentList) {
                if ([file isEqualToString:@"Info.plist"]) {
                    NSString *plistPath = [archiveDir stringByAppendingPathComponent: file];
                    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
                    NSString *newVersion = dict[@"ApplicationProperties"][@"CFBundleVersion"];
                    if ([newVersion isEqualToString:version]) {
                        NSString *dSYMPath = [[archiveDir stringByAppendingPathComponent:@"dSYMs"] stringByAppendingPathComponent:@"Boardmaps.app.dSYM"];
                        
                        return [NSURL fileURLWithPath:dSYMPath];
                        
                    }
                }
            }
            
        }
        
    }
    
    return nil;

}

@end
