//
//  NSString+HMACTest.m
//  GHKit
//
//  Created by Gabe on 7/2/08.
//  Copyright 2008 rel.me. All rights reserved.
//

#import "GHNSString+HMAC.h"

@interface NSStringHMACTest : XCTestCase { }
@end

@implementation NSStringHMACTest

- (void)testHmacSha1 {  
  NSString *signature1 = [@"what do ya want for nothing?" gh_HMACSHA1:@"Jefe"];
  NSLog(@"Signature #1: %@", signature1);
  XCTAssertEqualObjects(@"7/zfauXrL6LSdBbV8YTfnCWafHk=", signature1, @"HMAC SHA1 signature is not correct");
  
  NSString *signature2 = [@"This is a test" gh_HMACSHA1:@"SECRETKEY"];
  NSLog(@"Signature #2: %@", signature2);
  XCTAssertEqualObjects(@"14HjU+kYFlZuSlhgd0UVJWTM4+w=", signature2, @"HMAC SHA1 signature is not correct");
}

@end
