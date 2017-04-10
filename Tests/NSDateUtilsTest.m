//
//  NSDate+UtilsTest.m
//  GHKit
//
//  Created by Gabriel Handford on 2/18/09.
//  Copyright 2009. All rights reserved.
//

#import "GHNSDate+Utils.h"

@interface NSDateUtilsTest : XCTestCase { }
@end

@implementation NSDateUtilsTest

- (void)testYesterday {
	NSDate *date = [[NSDate date] dateByAddingTimeInterval:-(60 * 60 * 24)]; // This could fail daylight savings
	XCTAssertTrue([date gh_wasYesterday]);
}

- (void)testTomorrow {
	NSDate *date = [[NSDate date] dateByAddingTimeInterval:(60 * 60 * 24)]; // This could fail daylight savings
	XCTAssertTrue([date gh_isTomorrow]);
}

- (void)testWeekday {
	NSLog(@"[NSDate gh_tomorrow]: %@", [NSDate gh_tomorrow]);
	XCTAssertEqualObjects([[NSDate gh_yesterday] gh_weekday:nil], @"Yesterday");
	XCTAssertEqualObjects([[NSDate gh_tomorrow] gh_weekday:nil], @"Tomorrow");
	XCTAssertEqualObjects([[NSDate date] gh_weekday:nil], @"Today");
	
	NSDate *date = [[NSDate date] gh_addDays:-3];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"EEEE"];
	NSString *weekday = [dateFormatter stringFromDate:date];
	XCTAssertEqualObjects(weekday, [date gh_weekday:dateFormatter]);
}

- (void)testDate {
  NSDate *date = [NSDate gh_dateWithDay:1 month:1 year:2012 addDay:0 addMonth:0 addYear:-30 timeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
  [dateFormatter setDateStyle:NSDateFormatterShortStyle];
  NSString *dateString = [dateFormatter stringFromDate:date];
  XCTAssertEqualObjects(dateString, @"1/1/82");
}

- (void)testComponents {
  NSDate *date = [NSDate gh_dateWithDay:1 month:2 year:2012 timeZone:nil];
  XCTAssertTrue([date gh_day] == 1);
  XCTAssertTrue([date gh_month] == 2);
  XCTAssertTrue([date gh_year] == 2012);
}

- (void)testMonthSymbolsForFormat {
  NSArray *monthSymbols = [NSDate gh_monthSymbols];
  NSLog(@"%@", [monthSymbols description]);
}

- (void)testMillisSince1970 {
	NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
	[comps setDay:13];
	[comps setMonth:2];
	[comps setYear:2009];
	[comps setHour:23];
	[comps setMinute:31];
	[comps setSecond:30];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	[calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	NSDate *date = [calendar dateFromComponents:comps];	
		
	long long millis = [date gh_millisSince1970];
	NSLog(@"millis=%lld", millis);
	XCTAssertTrue(millis == 1234567890000);
	
	NSNumber *millisNumber = [date gh_millisNumberSince1970];
	XCTAssertEqualObjects(millisNumber, [NSNumber numberWithLongLong:1234567890000]);
}

@end
