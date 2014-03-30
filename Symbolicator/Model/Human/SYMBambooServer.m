#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "SYMBambooClient+Projects.h"
#import "SYMBambooProject.h"
#import "SYMBambooServer.h"
#import "SYMNotificationConstants.h"
#import "SYMPreferencesController.h"
#import "NSURLProtectionSpace+SYMAdditions.h"

@interface SYMBambooServer ()

@end

@implementation SYMBambooServer

+ (instancetype)selectedServer
{
    NSString* selectedServerURLString = [[NSUserDefaults standardUserDefaults]
                                         stringForKey:kSelectedBambooURLDefaultsKey];
    if (selectedServerURLString == nil)
    {
        return nil;
    } else
    {
        SYMBambooServer* server = [[self class] MR_findFirstByAttribute:SYMBambooServerAttributes.url
                                                              withValue:selectedServerURLString];
        return server;
    }
}


- (void)setUrl:(NSString *)url
{
    [self setPrimitiveUrl:url];
    [self initializeURLProtectionSpaceWithURL:[NSURL URLWithString:url]];
}


- (void)initializeURLProtectionSpaceWithURL:(NSURL *)URL
{
    NSURLProtectionSpace* protectionSpace = [[NSURLProtectionSpace alloc]
                                             initWithURL:URL
                                             realm:nil
                                             authenticationMethod:NSURLAuthenticationMethodHTTPBasic];
    [self setPrimitiveUrlProtectionSpace:protectionSpace];
}


- (void)setUsername:(NSString *)username password:(NSString *)password
{
    NSParameterAssert(self.urlProtectionSpace != nil);
    
    NSURLCredential* credential = [NSURLCredential credentialWithUser:username
                                                             password:password
                                                          persistence:NSURLCredentialPersistencePermanent];
    [[NSURLCredentialStorage sharedCredentialStorage] setCredential:credential
                                                 forProtectionSpace:self.urlProtectionSpace];
}


- (NSURLCredential *)loginCredential
{
    NSDictionary* matchingCredentials = [[NSURLCredentialStorage sharedCredentialStorage]
                                         credentialsForProtectionSpace:self.urlProtectionSpace];
    // TODO: Add support for picking between multiple matching credentials.
    NSArray* allCredentials = [matchingCredentials allValues];
    if ([allCredentials count] > 0)
    {
        return allCredentials[0];
    } else
    {
        return nil;
    }
}


- (void)logout
{
    NSURLCredentialStorage* credentialStorage = [NSURLCredentialStorage sharedCredentialStorage];
    NSDictionary* matchingCredentials = [credentialStorage
                                         credentialsForProtectionSpace:self.urlProtectionSpace];
    NSArray* allCredentials = [matchingCredentials allValues];
    for (NSURLCredential* credential in allCredentials)
    {
        [credentialStorage removeCredential:credential
                         forProtectionSpace:self.urlProtectionSpace];
    }
}


- (void)prefetchProjects
{
    [[SYMBambooClient sharedClient]
     fetchProjectsOnBambooServer:self
     withCompletionBlock:^(NSError *error) {
         if (error != nil)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [[NSNotificationCenter defaultCenter] postNotificationName:SYMBambooProjectsUpdatedNotification
                                                                     object:self];
             });
         }
     }];
}


#pragma mark - Tree node methods


- (NSArray *)orderedChildren
{
    NSArray* sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:SYMBambooProjectAttributes.name
                                                               ascending:YES],
                                 [NSSortDescriptor sortDescriptorWithKey:SYMBambooProjectAttributes.key
                                                               ascending:YES]];
    NSArray* ordered = [self.projects sortedArrayUsingDescriptors:sortDescriptors];
    return ordered;
}


- (instancetype)childAtIndex:(NSInteger)index
{
    NSArray* allChildren = [self orderedChildren];
    if (index < [allChildren count])
    {
        return allChildren[index];
    } else
    {
        return nil;
    }
}


- (NSInteger)numberOfChildren
{
    return [self.projects count];
}


- (BOOL)isLeaf
{
    BOOL isLeaf = ([self numberOfChildren] == 0);
    return isLeaf;
}

@end
