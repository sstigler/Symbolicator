//
//  SYMBambooPaginationManager.m
//  Symbolicator
//
//  Created by Sam Stigler on 3/28/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import "SYMBambooPaginationManager.h"
#import "SYMBambooProject.h"

static NSString* const kJSONProjectsKey = @"projects";
static NSString* const kJSONTotalCountKey = @"size";
static NSString* const kJSONStartIndexKey = @"start-index";
static NSString* const kJSONResultsPerPageKey = @"max-result";

static NSInteger const kMaxResultsPerPage = 25;

@interface SYMBambooPaginationManager ()

@property(nonatomic, copy) NSString* requestURN;
@property(nonatomic, strong) NSDictionary* requestData;
@property(nonatomic, strong) Class recordClass;

@property(nonatomic, assign) NSInteger totalCount;
@property(nonatomic, assign) NSInteger currentStartIndex;
@property(nonatomic, assign) NSInteger countOfResultsOnCurrentPage;

@end

@implementation SYMBambooPaginationManager

#pragma mark - Public method overrides

- (instancetype)initWithResponseObject:(NSDictionary *)dict
                            requestURN:(NSString *)requestURN
                           requestData:(NSDictionary *)requestData
                           recordClass:(Class)recordClass
{
    self = [super init];
    
    if (self != nil)
    {
        NSAssert(recordClass == [SYMBambooProject class],
                 @"Bamboo pagination manager currently only supports entities of type SYMBambooProject.");
        
        _requestURN = [requestURN copy];
        _requestData = requestData;
        _recordClass = recordClass;
        _totalCount = -1;
        _currentStartIndex = -1;
        
        [self initializeForProjectEntityWithResponseObject:dict];
    }
    
    return self;
}


- (void)initializeForProjectEntityWithResponseObject:(NSDictionary *)dict
{
    NSDictionary* projectsDictionary = dict[kJSONProjectsKey];
    if (projectsDictionary != nil)
    {
        self.totalCount = [self totalProjectCountFromProjectsDictionary:projectsDictionary];
        self.currentStartIndex = [self currentProjectStartIndexFromProjectsDictionary:projectsDictionary];
        self.countOfResultsOnCurrentPage = [self resultsPerPageFromProjectsDictionary:projectsDictionary];
    } else
    {
        _totalCount = 0;
        _currentStartIndex = 0;
    }
}


- (NSInteger)totalResultsCount
{
    NSAssert(self.totalCount >= 0, @"totalCount hasn't been initialized yet!");
    return self.totalCount;
}


- (NSInteger)resultsPerPage
{
    return self.countOfResultsOnCurrentPage;
}


- (BOOL)canRequestNextPage
{
    BOOL nextPageExists = ((self.countOfResultsOnCurrentPage == kMaxResultsPerPage) &&
                           (self.currentStartIndex < self.totalCount));
    return nextPageExists;
}


- (NSString *)nextPageURN
{
    return self.requestURN;
}


- (NSDictionary *)nextPageData
{
    NSMutableDictionary* nextPageParameters = [NSMutableDictionary dictionaryWithDictionary:self.requestData];
    
    NSInteger nextStartIndex = self.currentStartIndex + self.countOfResultsOnCurrentPage;
    nextPageParameters[kJSONStartIndexKey] = @(nextStartIndex);
    return nextPageParameters;
}


#pragma mark - Private methods


- (NSInteger)totalProjectCountFromProjectsDictionary:(NSDictionary *)projectsDictionary
{
    NSNumber* totalCountNumber = projectsDictionary[kJSONTotalCountKey];
    NSInteger totalCount = [totalCountNumber integerValue];
    return totalCount;
}


- (NSInteger)currentProjectStartIndexFromProjectsDictionary:(NSDictionary *)projectsDictionary
{
    NSNumber* startIndexNumber = projectsDictionary[kJSONStartIndexKey];
    NSInteger startIndex = [startIndexNumber integerValue];
    return startIndex;
}


- (NSInteger)resultsPerPageFromProjectsDictionary:(NSDictionary *)projectsDictionary
{
    NSNumber* resultsPerPageNumber = projectsDictionary[kJSONResultsPerPageKey];
    NSInteger resultsPerPage = [resultsPerPageNumber integerValue];
    return resultsPerPage;
}

@end
