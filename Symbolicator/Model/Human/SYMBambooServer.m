#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "SYMBambooClient+Projects.h"
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
        SYMBambooServer* server = [[self class] MR_findFirstByAttribute:selectedServerURLString
                                                              withValue:SYMBambooServerAttributes.url];
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
    __weak typeof(self) weakSelf = self;
    [[SYMBambooClient sharedClient]
     fetchProjectsOnBambooServer:self
     withCompletionBlock:^(NSError *error) {
         if (error != nil)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:SYMBambooProjectsUpdatedNotification
                                                                 object:weakSelf];
         }
     }];
}

@end
