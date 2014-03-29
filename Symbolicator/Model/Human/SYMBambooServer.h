#import "_SYMBambooServer.h"

@interface SYMBambooServer : _SYMBambooServer {}

/**
 @return The NSURLCredential to use when authenticating to this server. Returns nil if no username
 and password have been set yet, and it cannot find one saved in the user's keychain.
 */
@property(nonatomic, readonly) NSURLCredential* loginCredential;


/**
 @return The server that is currently selected in NSUserDefaults. Returns nil if no server is
 currently selected, or it can't find that server in the default managed object context.
*/
+ (instancetype)selectedServer;
 
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

/**
 Prefetches all the projects on this server.
 */
- (void)prefetchProjects;

@end
