//
//  NSURLProtectionSpaceAdditionsTests.m
//  Symbolicator
//
//  Created by Sam Stigler on 3/23/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSURLProtectionSpace+SYMAdditions.h"

@interface NSURLProtectionSpaceAdditionsTests : XCTestCase

@end

@implementation NSURLProtectionSpaceAdditionsTests

- (void)testThrowsExceptionIfPassedNilURL
{
    XCTAssertThrows([[NSURLProtectionSpace alloc] initWithURL:nil
                                                        realm:nil
                                         authenticationMethod:NSURLAuthenticationMethodHTTPBasic],
                    @"Expected that passing a nil URL would result in an assertion failure.");
}


- (void)testDoesNotThrowExceptionIfPassedNilRealm
{
    XCTAssertNoThrow([[NSURLProtectionSpace alloc] initWithURL:[NSURL URLWithString:@"bamboo.com"]
                                                         realm:nil
                                          authenticationMethod:NSURLAuthenticationMethodHTTPBasic],
                     @"Expected that passing in a nil realm would not result in an assertion failure.");
}


- (void)testThrowsExceptionIfPassedNilAuthenticationMethod
{
    XCTAssertThrows([[NSURLProtectionSpace alloc] initWithURL:[NSURL URLWithString:@"bamboo.com"]
                                                        realm:nil
                                         authenticationMethod:nil],
                    @"Expected that passing a nil authentication method would result in an assertion failure.");
}


- (void)testReturnsNSURLProtectionSpaceIfPassedValidParameters
{
    id test = [[NSURLProtectionSpace alloc] initWithURL:[NSURL URLWithString:@"test.com:8088"]
                                                  realm:nil
                                   authenticationMethod:NSURLAuthenticationMethodHTTPBasic];
    XCTAssertTrue([test isKindOfClass:[NSURLProtectionSpace class]],
                  @"Expected instance of NSURLProtectionSpace, got %@.", test);
}


- (void)testReturnValueHasCorrectHostIfPassedTestDotCom
{
    NSURLProtectionSpace* test = [[NSURLProtectionSpace alloc] initWithURL:[NSURL URLWithString:@"test.com"]
                                                                     realm:nil
                                                      authenticationMethod:NSURLAuthenticationMethodHTTPBasic];
    NSString* actual = [test host];
    XCTAssertEqualObjects(actual, @"test.com",
                          @"Expected 'test.com', got %@.", actual);
}


- (void)testReturnValueHasCorrectHostIfPassedBambooDotTestDotNet
{
    NSURLProtectionSpace* test = [[NSURLProtectionSpace alloc] initWithURL:[NSURL URLWithString:@"bamboo.test.net"]
                                                                     realm:nil
                                                      authenticationMethod:NSURLAuthenticationMethodHTTPBasic];
    NSString* actual = [test host];
    XCTAssertEqualObjects(actual, @"bamboo.test.net",
                          @"Expected 'bamboo.test.net', got %@.", actual);
}


- (void)testReturnValueHasCorrectPortIfPassedURLWithPort80
{
    NSURLProtectionSpace* test = [[NSURLProtectionSpace alloc] initWithURL:[NSURL URLWithString:@"test.com:80"]
                                                                     realm:nil
                                                      authenticationMethod:NSURLAuthenticationMethodHTTPBasic];
    XCTAssertEqual([test port], 80,
                   @"Expected 80, got %ld.", (long)[test port]);
}


- (void)testReturnValueHasCorrectPortIfPassedURLWithPort5789
{
    NSURLProtectionSpace* test = [[NSURLProtectionSpace alloc] initWithURL:[NSURL URLWithString:@"test.com:5789"]
                                                                     realm:nil
                                                      authenticationMethod:NSURLAuthenticationMethodHTTPBasic];
    XCTAssertEqual([test port], 5789,
                   @"Expected 5789, got %ld.", (long)[test port]);
}


- (void)testReturnValueHasCorrectRealmIfPassedNilRealm
{
    NSURLProtectionSpace* test = [[NSURLProtectionSpace alloc] initWithURL:[NSURL URLWithString:@"test.com:5789"]
                                                                     realm:nil
                                                      authenticationMethod:NSURLAuthenticationMethodHTTPBasic];
    XCTAssertNil([test realm],
                 @"Expected nil, got %@.", [test realm]);
}


- (void)testReturnValueHasCorrectRealmIfPassedUsersRealm
{
    NSURLProtectionSpace* test = [[NSURLProtectionSpace alloc] initWithURL:[NSURL URLWithString:@"test.com:5789"]
                                                                     realm:@"users"
                                                      authenticationMethod:NSURLAuthenticationMethodHTTPBasic];
    XCTAssertNil([test realm],
                 @"Expected 'users', got %@.", [test realm]);
}


- (void)testReturnValueHasCorrectAuthenticationMethodIfPassedHTTPBasicAuthentication
{
    NSURLProtectionSpace* test = [[NSURLProtectionSpace alloc] initWithURL:[NSURL URLWithString:@"test.com"]
                                                                     realm:nil
                                                      authenticationMethod:NSURLAuthenticationMethodHTTPBasic];
    XCTAssertEqualObjects([test authenticationMethod], NSURLAuthenticationMethodHTTPBasic,
                          @"Expected %@, got %@.",
                          NSURLAuthenticationMethodHTTPBasic,
                          [test authenticationMethod]);
}


- (void)testReturnValueHasCorrectAuthenticationMethodIfPassedNTLMAuthentication
{
    NSURLProtectionSpace* test = [[NSURLProtectionSpace alloc] initWithURL:[NSURL URLWithString:@"test.com"]
                                                                     realm:nil
                                                      authenticationMethod:NSURLAuthenticationMethodNTLM];
    XCTAssertEqualObjects([test authenticationMethod], NSURLAuthenticationMethodNTLM,
                          @"Expected %@, got %@.",
                          NSURLAuthenticationMethodNTLM,
                          [test authenticationMethod]);
}

@end
