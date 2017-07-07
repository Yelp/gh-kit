//
//  GHNSURL+Utils.m
//
//  Created by Gabe on 3/19/08.
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


#import "GHNSURL+Utils.h"

/**
 NSURLComponents conforms to RFC 3986, which has subtle incompatibilities with the more commonly seen RFC 1738 (JavaScript, Python, etc.), e.g. + in a query component will be escaped under RFC 1738 but not RFC 3986.
 For compatibility, we escape using the most widely agreed-upon set of allowed characters.
 */
static NSString * RFC1738EscapedString(NSString *s) {
  return [s stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!'()*-.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~"]];
}

@implementation NSURL(GHUtils)


- (NSMutableDictionary *)gh_queryDictionary {
  return [NSURL gh_queryStringToDictionary:[self query]];
}

+ (NSString *)gh_dictionaryToQueryString:(NSDictionary *)queryDictionary {
  if (!queryDictionary) return nil;
  NSMutableArray *queryItems = [NSMutableArray array];
  NSArray *sortedKeys = [[queryDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
  for (NSString *key in sortedKeys) {
    id value = [queryDictionary valueForKey:key];
    NSString *valueDescription = nil;
    
    if ([value respondsToSelector:@selector(objectEnumerator)]) {
      NSEnumerator *enumerator = [value objectEnumerator];
      valueDescription = [[enumerator allObjects] componentsJoinedByString:@","];
    } else if ([value isEqual:[NSNull null]]) {
      continue;
    } else {
      valueDescription = [value description];
    }
    
    if (!valueDescription) continue;
    NSString *item = [NSString stringWithFormat:@"%@=%@", RFC1738EscapedString(key), RFC1738EscapedString(valueDescription)];
    [queryItems addObject:item];
  }
  return [queryItems componentsJoinedByString:@"&"];
}

+ (NSMutableDictionary *)gh_queryStringToDictionary:(NSString *)string {
  NSURLComponents *components = [[[NSURLComponents alloc] init] autorelease];
  components.percentEncodedQuery = string;
  
  NSMutableDictionary *queryDictionary = [NSMutableDictionary dictionary];
  for (NSURLQueryItem *queryItem in components.queryItems) {
    queryDictionary[queryItem.name] = queryItem.value;
  }
  return queryDictionary;
}

@end
