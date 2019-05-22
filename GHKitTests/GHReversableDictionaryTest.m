//
//  GHReversableDictionaryTest.m
//  GHKit
//
//  Created by Gabriel Handford on 1/25/10.
//  Copyright 2010. All rights reserved.
//

#import "GHReversableDictionary.h"

@interface GHReversableDictionaryTest : XCTestCase { }
@end

@implementation GHReversableDictionaryTest

- (void)test {
  GHReversableDictionary *dict = [[[GHReversableDictionary alloc] initWithObjectsAndKeys:
                                   @"value1", @"key1",
                                   @"value2", @"key2",
                                   nil] autorelease];
  [dict setObject:@"value3" forKey:@"key3"];
  
  XCTAssertEqualObjects([dict objectForKey:@"key1"], @"value1");
  XCTAssertEqualObjects([dict keyForObject:@"value1"], @"key1");
  XCTAssertEqualObjects([dict objectForKey:@"key3"], @"value3");
  XCTAssertEqualObjects([dict keyForObject:@"value3"], @"key3");

}

@end
