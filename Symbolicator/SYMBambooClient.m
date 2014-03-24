//
//  SYMBambooClient.m
//  Symbolicator
//
//  Created by Sam Stigler on 3/23/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "SYMBambooClient.h"
#import "SYMBambooServer.h"

static NSString* const kServerInformationPath = @"info";
static NSString* const kServerVersionJSONKey = @"version";
static NSString* const kServerProjectsPath = @"projects";

@implementation SYMBambooClient

- (void)fetchServerVersionOfBambooServer:(SYMBambooServer *)server
                     withCompletionBlock:(void (^)(NSNumber *version, NSError *error))completionBlock
{
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration];
    __weak typeof(self) weakSelf = self;
    NSURL* URL = [[NSURL URLWithString:server.url] URLByAppendingPathComponent:kServerInformationPath];
    NSURLSessionDataTask* task = [session
                                  dataTaskWithURL:URL
                                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (completionBlock != nil)
                                      {
                                          if (error != nil)
                                          {
                                              completionBlock(nil, error);
                                          } else
                                          {
                                              id JSONObject = [weakSelf JSONObjectFromData:data
                                                                                     error:error];
                                              if (error != nil)
                                              {
                                                  completionBlock(nil, error);
                                              } else
                                              {
                                                  NSString* versionString = [JSONObject valueForKey:kServerVersionJSONKey];
                                                  NSNumber* versionNumber = @([versionString integerValue]);
                                                  [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                                                      server.version = versionNumber;
                                                  }];
                                                  completionBlock(versionNumber, nil);
                                              }
                                          }
                                      }
                                  }];
    [task resume];
}


- (void)fetchProjectsOnBambooServer:(SYMBambooServer *)server
                withCompletionBlock:(void (^)(NSArray *projects, NSError *error))completionBlock
{
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configuration];
    __weak typeof(self) weakSelf = self;
    NSURL* URL = [[NSURL URLWithString:server.url] URLByAppendingPathComponent:kServerProjectsPath];
    NSURLSessionDataTask* task = [session
                                  dataTaskWithURL:URL
                                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (completionBlock != nil)
                                      {
                                          if (error != nil)
                                          {
                                              completionBlock(nil, error);
                                          } else
                                          {
                                              id JSONObject = [weakSelf JSONObjectFromData:data
                                                                                     error:error];
                                              if (error != nil)
                                              {
                                                  completionBlock(nil, error);
                                              } else
                                              {
                                                  // TODO: Fill this in.
                                              }
                                          }
                                      }
                                  }];
}


#pragma mark - Helper methods


- (id)JSONObjectFromData:(NSData *)data error:(NSError *)error
{
    id JSONObject = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                      error:&error];
    return JSONObject;
}

@end
