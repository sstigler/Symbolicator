#import "SYMBambooClient+Plans.h"
#import "SYMBambooPlan.h"
#import "SYMBambooProject.h"
#import "SYMNotificationConstants.h"

@interface SYMBambooProject ()

@end


@implementation SYMBambooProject

+ (NSString *)keyPathForResponseObject
{
    return @"projects.project";
}


- (void)prefetchPlans
{
    [[SYMBambooClient sharedClient]
     fetchAllPlansForBambooProject:self
     onServer:self.server
     withCompletionBlock:^(NSError *error) {
         if (error != nil)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [[NSNotificationCenter defaultCenter]
                  postNotificationName:SYMBambooPlansUpdatedNotification
                  object:self];
             });
         }
     }];
}


#pragma mark - Tree node methods


- (NSArray *)orderedChildren
{
    NSArray* sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:SYMBambooPlanAttributes.name
                                                               ascending:YES],
                                 [NSSortDescriptor sortDescriptorWithKey:SYMBambooPlanAttributes.key
                                                               ascending:YES]];
    NSArray* ordered = [self.plans sortedArrayUsingDescriptors:sortDescriptors];
    return ordered;
}


- (NSInteger)numberOfChildren
{
    return [self.plans count];
}


- (BOOL)isLeaf
{
    BOOL isLeaf = ([self numberOfChildren] == 0);
    return isLeaf;
}


- (instancetype)childAtIndex:(NSInteger)index
{
    if (index < [self numberOfChildren])
    {
        return [self orderedChildren][index];
    } else
    {
        return nil;
    }
}


- (NSString *)displayName
{
    return self.name;
}

@end
