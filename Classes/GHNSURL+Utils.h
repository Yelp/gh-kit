//
//  GHNSURL+Utils.h
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

/*!
 Utilities for URLs, for example, encoding, escaping, parsing, splitting out or sorting query params, and more.
 */
@interface NSURL(GHUtils)

/*!
 Get dictionary from NSURL query parameter.
 
 @result Dictionary of key, value pairs from parsing query parameter
 */
- (NSMutableDictionary *)gh_queryDictionary;

/*!
 Dictionary to query string. Escapes any encoded characters. Sorts query params alphabetically by key.
 
 @param queryDictionary Dictionary of key value params
 @result Query string, key1=value1&amp;key2=value2
 */
+ (NSString *)gh_dictionaryToQueryString:(NSDictionary *)queryDictionary;

/*!
 Convert URL query string to dictionary.
 
 @param string URL params string, key1=value1&amp;key2=value2
 @result Dictionary
 */
+ (NSMutableDictionary *)gh_queryStringToDictionary:(NSString *)string;

@end
