#import "_SYMBambooProject.h"
#import "SYMTreeNode.h"

@interface SYMBambooProject : _SYMBambooProject <SYMTreeNode> {}

/**
 Prefetches all the build plans for this project.
 */
- (void)prefetchPlans;


@end
