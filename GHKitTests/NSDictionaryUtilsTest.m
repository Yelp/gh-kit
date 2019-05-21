//
//  NSDictionaryUtilsTest.m
//  GHKit
//
//  Created by Gabriel Handford on 6/4/09.
//  Copyright 2009. All rights reserved.
//


#import "GHNSDictionary+Utils.h"

@interface NSDictionaryUtilsTest : XCTestCase { }
@end

@implementation NSDictionaryUtilsTest

- (void)testBoolValue {
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
												@"1", @"key1", 
												[NSNumber numberWithBool:YES], @"key2", 
												[NSNumber numberWithBool:NO], @"key3", 
												[NSNull null], @"key4", 
												nil];
	
	XCTAssertTrue([[dict gh_boolValueForKey:@"key1"] boolValue]);
	XCTAssertTrue([[dict gh_boolValueForKey:@"key2"] boolValue]);
	XCTAssertFalse([[dict gh_boolValueForKey:@"key3"] boolValue]);
	XCTAssertFalse([[dict gh_boolValueForKey:@"key4"] boolValue]);
}

- (void)testHasAllKeys {
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
												@"1", @"key1", 
												[NSNumber numberWithBool:YES], @"key2", 
												[NSNumber numberWithBool:NO], @"key3", 
												[NSNull null], @"key4", 
												nil];
	
	BOOL b;
	b = [dict gh_hasAllKeys:nil];
	XCTAssertTrue(b);	
	b = [dict gh_hasAllKeys:@"key1", nil];
	XCTAssertTrue(b);
	b = [dict gh_hasAllKeys:@"key1", @"key3", nil];
	XCTAssertTrue(b);
	b = [dict gh_hasAllKeys:@"key1", @"key4", nil];
	XCTAssertFalse(b);
	b = [dict gh_hasAllKeys:@"key1", @"key5", nil];
	XCTAssertFalse(b);
	b = [dict gh_hasAllKeys:@"key5", @"key1", nil];
	XCTAssertFalse(b);
}

- (void)testSubsetWithKeys {
  NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
												@"1", @"key1", 
                        @"2", @"key2", 
												nil];
  
  NSDictionary *dictSubset = [dict gh_dictionarySubsetWithKeys:[NSArray arrayWithObject:@"key1"]];
  NSDictionary *expected = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"key1", nil];
  XCTAssertEqualObjects(dictSubset, expected);
  
  // Test missing key
  NSDictionary *dictSubset2 = [dict gh_dictionarySubsetWithKeys:[NSArray arrayWithObject:@"key3"]];
  NSDictionary *expected2 = [NSDictionary dictionary];
  XCTAssertEqualObjects(dictSubset2, expected2);  
}

- (void)testCompact {
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"1", @"key1",
                               [NSNull null], @"key2", 
                               nil];
  
  NSDictionary *expected = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"1", @"key1",
                                   nil];

	NSDictionary *after = [dict gh_compactDictionary];
  XCTAssertEqualObjects(after, expected);
}

@end
