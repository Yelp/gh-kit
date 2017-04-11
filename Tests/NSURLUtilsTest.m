//
//  NSURL+UtilsTest.m
//  GHKit
//
//  Created by Gabriel Handford on 1/13/09.
//

#import "GHNSURL+Utils.h"
#import "GHNSDictionary+NSNull.h"

@interface NSURLUtilsTest : XCTestCase { }
@end

@implementation NSURLUtilsTest

- (void)testDictionaryToQueryString {
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"value1", @"key1", @"value2", @"key2", nil];
	NSString *s = [NSURL gh_dictionaryToQueryString:dict];
	XCTAssertEqualObjects(s, @"key1=value1&key2=value2");
	
	NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"value1", @"AAA", @"value2", @"BBB", @"value3", @"CCC", nil];
	NSString *s2 = [NSURL gh_dictionaryToQueryString:dict2];
	XCTAssertEqualObjects(s2, @"AAA=value1&BBB=value2&CCC=value3");	
}

- (void)testDictionaryWithObjectsToQueryString {
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:1], @"key1", @"[]", @"key2", nil];
	NSString *s = [NSURL gh_dictionaryToQueryString:dict];
	XCTAssertEqualObjects(s, @"key1=1&key2=%5B%5D");
}

- (void)testDictionaryWithNSNull {
	NSDictionary *dict = [NSDictionary gh_dictionaryWithKeysAndObjectsMaybeNil:@"key1", @"value1", @"key2", nil, nil];
	NSString *s = [NSURL gh_dictionaryToQueryString:dict];
	XCTAssertEqualObjects(s, @"key1=value1");
}

- (void)testQueryStringToDictionary {
	NSDictionary *dict = [NSURL gh_queryStringToDictionary:@"key1=value1&key2=value2"];
	XCTAssertEqualObjects(@"value1", [dict objectForKey:@"key1"]);
	XCTAssertEqualObjects(@"value2", [dict objectForKey:@"key2"]);
	
	NSDictionary *dict2 = [NSURL gh_queryStringToDictionary:@"key1==value1&&key2=value2%20&key3=value3=more"];
	XCTAssertEqualObjects(@"=value1", [dict2 objectForKey:@"key1"]);
	XCTAssertEqualObjects(@"value2 ", [dict2 objectForKey:@"key2"]);
	XCTAssertEqualObjects(@"value3=more", [dict2 objectForKey:@"key3"]);
}

- (void)testQueryDictionaryWithArray {
	NSArray *array1 = [NSArray arrayWithObjects:@"va", @"vb", @"vc", nil];
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:array1, @"key1", @"value2", @"key2", nil];
	NSString *s = [NSURL gh_dictionaryToQueryString:dict];
	XCTAssertEqualObjects(s, @"key1=va,vb,vc&key2=value2");	
}

- (void)testQueryDictionaryWithSet {
	NSSet *set1 = [NSSet setWithObjects:@"va", @"vb", nil];
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:set1, @"key1", nil];
	NSString *s = [NSURL gh_dictionaryToQueryString:dict];
	XCTAssertTrue([s isEqualToString:@"key1=va,vb"] || [s isEqualToString:@"key1=vb,va"]);
}

@end
