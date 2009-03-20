//
//  GHNSFileManager+Utils.m
//
//  Created by Gabe on 3/23/08.
//  Copyright 2008 Gabriel Handford
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "GHNSFileManager+Utils.h"
#import "GHNSString+Utils.h"
#import "GHNSError+Utils.h"

@implementation NSFileManager (GHUtils)

/*!
 @method gh_fileSize
 @abstract Get size of file
 @param filePath Path
 @result File size
*/
+ (NSNumber *)gh_fileSize:(NSString *)filePath {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  BOOL isDir;
  if ([fileManager fileExistsAtPath:filePath isDirectory:&isDir] && !isDir) {
    NSDictionary *fileAttributes = [fileManager fileAttributesAtPath:filePath traverseLink:YES];    
    if (fileAttributes) 
      return [fileAttributes objectForKey:NSFileSize];
  }    
  return nil;
}

/*!
 @method gh_isDirectory
 @param filePath Path
 @abstract Check if is directory
 @result YES if directory, NO otherwise
*/
+ (BOOL)gh_isDirectory:(NSString *)filePath {
  BOOL isDir;
  return ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir] && isDir);
}

/*!
 @method gh_exist 
 @param filePath Path
 @result YES if exists, NO otherwise
*/
+ (BOOL)gh_exist:(NSString *)filePath {
  return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+ (NSString *)gh_temporaryFile:(NSString *)appendPath deleteIfExists:(BOOL)deleteIfExists error:(NSError **)error {
  NSString *tmpFile = NSTemporaryDirectory();
	if (appendPath) tmpFile = [tmpFile stringByAppendingPathComponent:appendPath];
  if (deleteIfExists && [self gh_exist:tmpFile]) {
    [[NSFileManager defaultManager] removeItemAtPath:tmpFile error:error];
  }
  return tmpFile;
}

+ (BOOL)gh_ensureDirectoryExists:(NSString *)directory created:(BOOL *)created error:(NSError **)error {
	if (![self gh_exist:directory]) {
		BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:error];
		if (success && created) *created = YES;
		return success;
	} else if (![self gh_isDirectory:directory]) {
		if (error) *error = [NSError gh_errorWithDomain:@"GHNSFileManager" code:-1 localizedDescription:@"Path exists but is not a directory"];
		return NO;
	} else {
		// Path existed and was a directory
		return YES;
	}
}

/*!
  @method gh_uniquePathWithNumber
  @abstract Get unique filename based on the specified path. If file does not already exist, the same object is returned. 
    Example: foo.txt and that path already exists, will return foo-1.txt, and if that exists foo-2.txt, and so on...  
*/
+ (NSString *)gh_uniquePathWithNumber:(NSString *)path {
  NSInteger index = 1;
  NSString *uniquePath = path;
  NSString *prefixPath = nil, *pathExtension = nil;
  
  while([self gh_exist:uniquePath]) {
    if (!prefixPath) prefixPath = [path stringByDeletingPathExtension];
    if (!pathExtension) pathExtension = [path gh_fullPathExtension];
    uniquePath = [NSString stringWithFormat:@"%@-%d%@", prefixPath, index, pathExtension];
    index++;
  }
  return uniquePath;
}

@end
