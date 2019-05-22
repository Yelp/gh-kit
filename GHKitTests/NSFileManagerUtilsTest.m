//
//  NSFileManager+UtilsTest.m
//  GHKit
//
//  Created by Gabriel Handford on 3/9/09.
//  Copyright 2009. All rights reserved.
//

#import "GHNSFileManager+Utils.h"

@interface NSFileManagerUtilsTest : XCTestCase { }
@end


@implementation NSFileManagerUtilsTest

- (void)testEnsureDirectory {
	NSError *error = nil;
	NSString *path = [NSFileManager gh_temporaryFile:nil deleteIfExists:YES error:&error];
	if (error) XCTFail(@"Error: %@", error);
	BOOL success = [NSFileManager gh_ensureDirectoryExists:path created:nil error:&error];
	if (error) XCTFail(@"Error: %@", error);
	XCTAssertTrue(success);
}

- (void)testFileSize {
  NSString *path = [[[NSBundle bundleForClass:[self class]] resourcePath] stringByAppendingPathComponent:@"test.file"];
  XCTAssertTrue([NSFileManager gh_exist:path]);
  NSNumber *fileSize = [NSFileManager gh_fileSize:path error:nil];
  XCTAssertEqual([fileSize longValue], 10L);
}

@end
