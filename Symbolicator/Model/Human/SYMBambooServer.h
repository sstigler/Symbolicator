#import "_SYMBambooServer.h"

@interface SYMBambooServer : _SYMBambooServer {}

/**
 Sets the username and password for the client to transmit to the server when making requests.
 @param username Username
 @param password Password
 */
- (void)setUsername:(NSString *)username password:(NSString *)password;

/**
 @return The HTTP basic authentication header to use when authenticating to this Bamboo server.
 */
- (NSDictionary *)HTTPBasicAuthenticationHeader;

@end
