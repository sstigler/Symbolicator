//
//  SYMLocator.h
//  Symbolicator
//
//  Created by Sergey Sedov on 15/10/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYMLocator : NSObject

+ (void) findDSYMWithPlistUrl: (NSURL *) crashReportURL inFolder: (NSURL *) folderURL completion: (void(^)(NSURL *dSYMURL, NSString *version)) completion;

@end
