#import "SYMBambooClient+Plans.h"
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
             [[NSNotificationCenter defaultCenter]
              postNotificationName:SYMBambooPlansUpdatedNotification
              object:self];
         }
     }];
}


@end
