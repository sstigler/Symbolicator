#import <MagicalRecord/CoreData+MagicalRecord.h>

#import "SYMBambooServer.h"

@interface SYMBambooServer ()

@end

static NSString* const kHTTPAuthorizationHeader = @"Authorization";

@implementation SYMBambooServer

#pragma mark - Authentication

- (void)setUsername:(NSString *)username password:(NSString *)password
{
    NSString* authString = [self base64EncodedAuthenticationStringFromUsername:username
                                                                      password:password];
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        self.authenticationString = authString;
    }];
}


- (NSDictionary *)HTTPBasicAuthenticationHeader
{
    NSDictionary* header = @{kHTTPAuthorizationHeader: self.authenticationString};
    return header;
}


- (NSString *)base64EncodedAuthenticationStringFromUsername:(NSString *)username
                                                   password:(NSString *)password
{
    NSString* authenticationString = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData* authenticationData = [authenticationString dataUsingEncoding:NSUTF8StringEncoding];
    NSString* base64EncodedAuthString = [authenticationData base64EncodedStringWithOptions:kNilOptions];
    return base64EncodedAuthString;
}

@end
