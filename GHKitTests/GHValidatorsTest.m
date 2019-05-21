//
//  GHValidatorsTest.m
//  GHKitIPhone
//
//  Created by Gabriel Handford on 10/1/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "GHValidators.h"
#import "GHNSDate+Utils.h"


@interface GHValidatorsTest : XCTestCase { }
@end

@implementation GHValidatorsTest

- (void)testValidateEmail {
  XCTAssertTrue([GHValidators isEmailAddress:@"test@domain.com"], @"Should be valid");
  XCTAssertFalse([GHValidators isEmailAddress:@"foo"], @"Should be invalid");
  XCTAssertFalse([GHValidators isEmailAddress:@""], @"Should be invalid");
  XCTAssertFalse([GHValidators isEmailAddress:nil], @"Should be invalid");
  XCTAssertFalse([GHValidators isEmailAddress:@"~gabrielh@gmail.com"], @"Should be invalid");
  XCTAssertTrue([GHValidators isEmailAddress:@"gabrielh@gmail.commmmmmm"], @"Should be valid");
}

- (void)testValidateCreditCard {
  XCTAssertFalse([GHValidators isCreditCardNumber:@" "], @"Should be invalid");
  XCTAssertFalse([GHValidators isCreditCardNumber:@""], @"Should be invalid");
  XCTAssertFalse([GHValidators isCreditCardNumber:nil], @"Should be invalid");
  XCTAssertTrue([GHValidators isCreditCardNumber:@"49927398716"], @"Should be valid");
  XCTAssertFalse([GHValidators isCreditCardNumber:@"1234"], @"Should be invalid");
  XCTAssertFalse([GHValidators isCreditCardNumber:@"abc"], @"Should be invalid");
}

- (void)testValidateCreditCardExpiration {
  NSDate *date = [NSDate gh_dateWithDay:1 month:12 year:2011 timeZone:nil];
  
  // Valid
  XCTAssertTrue([GHValidators isCreditCardExpiration:@"01/12" date:date], @"Should be valid");
  XCTAssertTrue([GHValidators isCreditCardExpiration:@"1/12" date:date], @"Should be valid");
  XCTAssertTrue([GHValidators isCreditCardExpiration:@"1/2012" date:date], @"Should be valid");
  XCTAssertTrue([GHValidators isCreditCardExpiration:@"01/12" date:date], @"Should be valid");
  
  // Empty
  XCTAssertFalse([GHValidators isCreditCardExpiration:@" " date:date], @"Should be invalid");
  XCTAssertFalse([GHValidators isCreditCardExpiration:@"" date:date], @"Should be invalid");
  XCTAssertFalse([GHValidators isCreditCardExpiration:nil date:date], @"Should be invalid");

  // Expired but valid on the one day
  XCTAssertTrue([GHValidators isCreditCardExpiration:@"11/11" date:date], @"Should be valid");
  NSDate *nextDay = [NSDate gh_dateWithDay:2 month:12 year:2011 timeZone:nil];
  XCTAssertFalse([GHValidators isCreditCardExpiration:@"11/11" date:nextDay], @"Should be invalid");
  
  // Invalid month or year
  XCTAssertFalse([GHValidators isCreditCardExpiration:@"13/12" date:date], @"Should be invalid");
  XCTAssertFalse([GHValidators isCreditCardExpiration:@"0/12" date:date], @"Should be invalid");
  
  // Expired
  XCTAssertFalse([GHValidators isCreditCardExpiration:@"1/2010" date:date], @"Should be invalid");
}

@end
