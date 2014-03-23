#import "_SYMBambooServer.h"

@interface SYMBambooServer : _SYMBambooServer {}

/**
 @return The NSURLCredential to use when authenticating to this server. Returns nil if no username
 and password have been set yet, and it cannot find one saved in the user's keychain.
 */
@property(nonatomic, readonly) NSURLCredential* loginCredential;

/**
 Sets the username and password for the client to transmit to this server when making requests.
 @param username Username
 @param password Password
 */
- (void)setUsername:(NSString *)username password:(NSString *)password;

/**
 Deletes the user's saved login credentials (if any exist) for this server.
 */
- (void)logout;

@end
