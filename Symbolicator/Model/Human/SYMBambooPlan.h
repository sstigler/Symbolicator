#import "_SYMBambooPlan.h"

@interface SYMBambooPlan : _SYMBambooPlan {}

/**
 Prefetches all the builds for this project.
 @param maximumCountToFetch The maximum number of builds to fetch from the server.
 @discussion The builds will be fetched in reverse-chronological order.
 */
- (void)prefetchBuildsWithLimit:(NSUInteger)maximumCountToFetch;

@end
