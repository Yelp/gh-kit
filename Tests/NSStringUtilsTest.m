//
//  NSStringUtilsTest.m
//  GHKit
//
//  Created by Gabe on 3/30/08.
//  Copyright 2008 rel.me. All rights reserved.
//

#import "GHNSString+Utils.h"

@interface NSStringUtilsTest : XCTestCase { }
@end

@implementation NSStringUtilsTest

- (void)testContainsAny {
	NSString *s = @"TestUppercase";
	XCTAssertTrue([s gh_containsAny:[NSCharacterSet uppercaseLetterCharacterSet]]);
}

- (void)testLastSplitWithString {
	XCTAssertEqualObjects(@"bar", [@"foo:bar" gh_lastSplitWithString:@":" options:NSCaseInsensitiveSearch], @"Split is invalid");
	XCTAssertEqualObjects(@"foobar", [@"foobar" gh_lastSplitWithString:@":" options:NSCaseInsensitiveSearch], @"Split is invalid");
	
	XCTAssertEqualObjects(@"foobar", [@"foobar" gh_lastSplitWithString:@"" options:NSCaseInsensitiveSearch], @"Split is invalid");
	XCTAssertEqualObjects(@"ar", [@"foobar" gh_lastSplitWithString:@"oob" options:NSCaseInsensitiveSearch], @"Split is invalid");
  
  XCTAssertEqualObjects(@"bar:baz", [@"foo:bar:baz" gh_lastSplitWithString:@":" options:NSCaseInsensitiveSearch], @"Split is invalid");	
}

- (void)testSeparate1 {	
	NSArray *expected = [NSArray arrayWithObjects:@"foo", @":", @":", @"bar", nil];	
	NSArray *separated = [@"foo::bar" gh_componentsSeparatedByString:@":" include:YES];
	XCTAssertEqualObjects(separated, expected);
}

- (void)testSeparate2 {	
	NSArray *expected = [NSArray arrayWithObjects:@"foo", @"\n", @"bar", nil];	
	NSArray *separated = [@"foo\nbar" gh_componentsSeparatedByString:@"\n" include:YES];
	XCTAssertEqualObjects(separated, expected);
}

- (void)testSeparate3 {	
	NSArray *expected = [NSArray arrayWithObjects:@"foo", @"\n", @"\n", @"bar", @"\n", nil];	
	NSArray *separated = [@"foo\n\nbar\n" gh_componentsSeparatedByString:@"\n" include:YES];
	XCTAssertEqualObjects(separated, expected);
}

- (void)testUUID {
	NSLog(@"%@", [NSString gh_uuid]);
	// TODO(gabe): Test
}

- (void)testReverse {
	XCTAssertEqualObjects([@"reversetest" gh_reverse], @"tsetesrever"); // odd # of letters
	XCTAssertEqualObjects([@"reverseit!" gh_reverse], @"!tiesrever"); // even # of letters
}

- (void)testStartsWith {
  XCTAssertTrue([@"www.test.com" gh_startsWith:@"www." options:0]);
  XCTAssertTrue([@"www.test.com" gh_startsWith:@"www.test.com" options:0]);
  XCTAssertFalse([@"www.test.com" gh_startsWith:@"" options:0]);
  
  XCTAssertTrue([@"www.test.com" gh_startsWith:@"WWW." options:NSCaseInsensitiveSearch]);
  XCTAssertTrue([@"www.test.com" gh_startsWith:@"WWW.test.com" options:NSCaseInsensitiveSearch]);
  XCTAssertFalse([@"www.test.com" gh_startsWith:@"" options:NSCaseInsensitiveSearch]);
}

- (void)testEndsWith {
  XCTAssertTrue([@"path/" gh_endsWith:@"/" options:0]);
  XCTAssertFalse([@"path" gh_endsWith:@"/" options:0]);  
  XCTAssertTrue([@"path-" gh_endsWith:@"-" options:NSLiteralSearch]);

  XCTAssertTrue([@"www.test.com" gh_endsWith:@".com" options:0]);
  XCTAssertTrue([@"www.test.com" gh_endsWith:@"www.test.com" options:0]);
  XCTAssertFalse([@"www.test.com" gh_endsWith:@"" options:0]);
  
  XCTAssertTrue([@"www.test.com" gh_endsWith:@".COM" options:NSCaseInsensitiveSearch]);
  XCTAssertTrue([@"www.test.com" gh_endsWith:@"www.test.COM" options:NSCaseInsensitiveSearch]);
  XCTAssertFalse([@"www.test.com" gh_endsWith:@"" options:NSCaseInsensitiveSearch]);
}

- (void)testCount {
	XCTAssertTrue([@"\n \n\n   \n" gh_count:@"\n"] == 4, @"1");
	XCTAssertTrue([@"\n" gh_count:@"\n"] == 1, @"2");
	XCTAssertTrue([@"" gh_count:@"\n"] == 0, @"3");
	XCTAssertTrue([@" " gh_count:@"\n"] == 0, @"4");
}

- (void)testSubStringSegmentsWithin {
	
	NSString *test1 = @"This <START>is a<END> test.";
	NSArray *segments1 = [test1 gh_substringSegmentsWithinStart:@"<START>" end:@"<END>"];
	NSArray *expected1 = [NSArray arrayWithObjects:
												[GHNSStringSegment string:@"This " isMatch:NO], 
												[GHNSStringSegment string:@"is a" isMatch:YES], 
												[GHNSStringSegment string:@" test." isMatch:NO], nil];
	XCTAssertEqualObjects(segments1, expected1, @"Segments is invalid");		
	
	NSString *test2 = @"This is a test.";
	NSArray *segments2 = [test2 gh_substringSegmentsWithinStart:@"<START>" end:@"<END>"];
	NSArray *expected2 = [NSArray arrayWithObjects:[GHNSStringSegment string:@"This is a test." isMatch:NO], nil];
	XCTAssertEqualObjects(segments2, expected2, @"Segments is invalid");	
	
	NSString *test3 = @"<START>This is a test.<END>";
	NSArray *segments3 = [test3 gh_substringSegmentsWithinStart:@"<START>" end:@"<END>"];
	NSArray *expected3 = [NSArray arrayWithObjects:[GHNSStringSegment string:@"This is a test." isMatch:YES], nil];
	XCTAssertEqualObjects(segments3, expected3, @"Segments is invalid");	

	NSString *test4 = @"<START>This is a test.<END> ";
	NSArray *segments4 = [test4 gh_substringSegmentsWithinStart:@"<START>" end:@"<END>"];
	NSArray *expected4 = [NSArray arrayWithObjects:
												[GHNSStringSegment string:@"This is a test." isMatch:YES], 
												[GHNSStringSegment string:@" " isMatch:NO], nil];
	XCTAssertEqualObjects(segments4, expected4, @"Segments is invalid");	
	
	NSString *test5 = @" <START>This is a test.<END> <END>";
	NSArray *segments5 = [test5 gh_substringSegmentsWithinStart:@"<START>" end:@"<END>"];
	NSArray *expected5 = [NSArray arrayWithObjects:
												[GHNSStringSegment string:@" " isMatch:NO], 
												[GHNSStringSegment string:@"This is a test." isMatch:YES], 
												[GHNSStringSegment string:@" <END>" isMatch:NO], nil];
	XCTAssertEqualObjects(segments5, expected5, @"Segments is invalid");	
	
	// TODO: Ok to kill the start token?
	NSString *test6 = @"<START>This is a test.";
	NSArray *segments6 = [test6 gh_substringSegmentsWithinStart:@"<START>" end:@"<END>"];
	NSArray *expected6 = [NSArray arrayWithObjects:[GHNSStringSegment string:@"This is a test." isMatch:YES], nil];
	XCTAssertEqualObjects(segments6, expected6, @"Segments is invalid");	
	
	// TODO: Return nil on empty string input?
	NSString *test7 = @"";
	NSArray *segments7 = [test7 gh_substringSegmentsWithinStart:@"<START>" end:@"<END>"];
	NSArray *expected7 = [NSArray array];
	XCTAssertEqualObjects(segments7, expected7, @"Segments is invalid");	
}

- (void)testRightStrip {
	NSString *text = @"this is a string to right strip   ";
	NSString *expected = @"this is a string to right strip";
	XCTAssertEqualObjects([text gh_rightStrip], expected);
}

- (void)testLeftStrip {
	NSString *text = @"   this is a string to left strip";
	NSString *expected = @"this is a string to left strip";
	XCTAssertEqualObjects([text gh_leftStrip], expected);
}

- (void)testIsEqualIgnoreCase {
	XCTAssertTrue([@"FOoO" gh_isEqualIgnoreCase:@"fooO"]);
}

- (void)testFloatValue {
  XCTAssertEqual(5.0f, [@"5.0.1" floatValue]);
}
	
@end
