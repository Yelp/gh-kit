//
//  NSInvocation+UtilsTest.m
//  GHKit
//
//  Created by Gabriel Handford on 1/17/09.
//  Copyright 2009. All rights reserved.
//

#import "GHNSInvocation+Utils.h"
#import "GHNSObject+Invocation.h"
#import "GHNSInvocationProxy.h"

@interface NSInvocationUtilsTest : XCTestCase {
	BOOL invokeTesting1Called_;
	BOOL invokeTesting2Called_;
	BOOL invokeTesting3Called_;
	BOOL invokeTesting4Called_;
	BOOL invokeTestingMainThreadCalled_;
	BOOL invokeTestingNestedCalled_;
	BOOL invokeTestArgumentProxyCalled_;
	BOOL invokeDetachCalled_;
}

@end

@interface NSInvocationUtilsTest ()
- (void)_invokeTesting4:(NSInteger)n;
- (void)_invokeTestingNested:(NSInteger)n;
- (void)_invokeTestingMainThread:(NSInteger)n;
- (void)_invokeDetach:(NSInteger)n;
@end

@protocol TestArgumentProxy 
- (void)s:(NSString *)s n:(NSInteger)n b:(BOOL)b;
@end

@implementation NSInvocationUtilsTest

- (void)setUpClass {
  invokeTesting1Called_ = NO;
  invokeTesting2Called_ = NO;
  invokeTesting3Called_ = NO;
  invokeTesting4Called_ = NO;
  invokeTestingMainThreadCalled_ = NO;
  invokeTestingNestedCalled_ = NO;
  invokeTestArgumentProxyCalled_ = NO;
  invokeDetachCalled_ = NO;
}

- (void)testInvoke {
	
	[NSInvocation gh_invokeWithTarget:self selector:@selector(_invokeTesting1:withObject:withObject:) 
												withObjects:[NSNumber numberWithInteger:1], [NSNumber numberWithInteger:2], [NSNumber numberWithInteger:3], nil];
	
	XCTAssertTrue(invokeTesting1Called_, @"Method was not called");
}

- (void)_invokeTesting1:(NSNumber *)number1 withObject:number2 withObject:number3 {
	XCTAssertEqualObjects([NSNumber numberWithInteger:1], number1);
	XCTAssertEqualObjects([NSNumber numberWithInteger:2], number2);
	XCTAssertEqualObjects([NSNumber numberWithInteger:3], number3);
	invokeTesting1Called_ = YES;
}

- (void)testInvokeWithArgumentsArrayAndNSNull {
	NSArray *arguments = [NSArray arrayWithObjects:[NSNumber numberWithInteger:1], [NSNull null], [NSNumber numberWithInteger:3], nil];
	[NSInvocation gh_invokeWithTarget:self selector:@selector(_invokeTesting2:withObject:withObject:) arguments:arguments];
	
	XCTAssertTrue(invokeTesting2Called_, @"Method was not called");
}

- (void)_invokeTesting2:(NSNumber *)number1 withObject:nilValue withObject:number3 {
	XCTAssertEqualObjects([NSNumber numberWithInteger:1], number1);
	XCTAssertNil(nilValue, @"Should be nil");
	XCTAssertEqualObjects([NSNumber numberWithInteger:3], number3);
	invokeTesting2Called_ = YES;
}

- (void)testInvokeWithDelay {
	
	[NSInvocation gh_invokeWithTarget:self 
													 selector:@selector(_invokeTesting3:) 
												 afterDelay:0.1
													arguments:[NSArray arrayWithObjects:[NSNumber numberWithInteger:1], nil]];
	
	XCTAssertFalse(invokeTesting3Called_, @"Method should be delayed");
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
	XCTAssertTrue(invokeTesting3Called_, @"Method was not called");
}

- (void)_invokeTesting3:(NSNumber *)number1 {
	XCTAssertEqualObjects([NSNumber numberWithInteger:1], number1);
	invokeTesting3Called_ = YES;
}


- (void)testInvokeProxy {
	[[self gh_proxyAfterDelay:0.1] _invokeTesting4:1];
	
	XCTAssertFalse(invokeTesting4Called_, @"Method should be delayed");
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
	XCTAssertTrue(invokeTesting4Called_, @"Method was not called");
}

- (void)_invokeTesting4:(NSInteger)n {
	XCTAssertTrue(n == 1, @"Should be equal to 1 but was %ld", (long)n);
	invokeTesting4Called_ = YES;
}

- (void)testInvokeOnMainThread {
	[[self gh_proxyOnMainThread:YES] _invokeTestingMainThread:1];
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
	XCTAssertTrue(invokeTestingMainThreadCalled_, @"Method was not called");
}

- (void)_invokeTestingMainThread:(NSInteger)n {
	XCTAssertTrue([NSThread isMainThread]);
	XCTAssertTrue(n == 1, @"Should be equal to 1 but was %ld", (long)n);
	invokeTestingMainThreadCalled_ = YES;
}

// TODO(gabe): This isn't a real failure
- (void)_testInvokeNestedProxy {
	[[[self gh_proxyOnMainThread:YES] gh_proxyAfterDelay:0.1] _invokeTestingNested:1];
	
	XCTAssertFalse(invokeTestingNestedCalled_, @"Method should be delayed");
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
	XCTAssertTrue(invokeTestingNestedCalled_, @"Method was not called");
}

- (void)_invokeTestingNested:(NSInteger)n {
  NSLog(@"invokeTestingNestedCalled on main thread: %d", [NSThread isMainThread]);
	XCTAssertTrue([NSThread isMainThread], @"Should be on main thread; This is currently an expected failure!");
	XCTAssertTrue(n == 1, @"Should be equal to 1 but was %ld", (long)n);
	invokeTestingNestedCalled_ = YES;
}

- (void)testArgumentProxy {
	SEL selector = @selector(_invokeTestArgumentProxy:n:b:);
	[[self gh_argumentProxy:selector] s:@"test" n:20 b:NO];
	XCTAssertTrue(invokeTestArgumentProxyCalled_);
}

- (void)_invokeTestArgumentProxy:(NSString *)s n:(NSInteger)n b:(BOOL)b {
	XCTAssertEqualObjects(@"test", s);
	XCTAssertTrue(20 == n);
	XCTAssertFalse(b);
	invokeTestArgumentProxyCalled_ = YES;
}

- (void)testDetach {
	NSLog(@"Calling on thread: %@", [NSThread currentThread]);
	[[self gh_proxyDetachThreadWithCallback:self action:@selector(_detachCallback:) context:nil] _invokeDetach:1];
	// Wait for thread to call back
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
	[NSThread sleepForTimeInterval:0.1];
	XCTAssertTrue(invokeDetachCalled_);
}

- (void)_invokeDetach:(NSInteger)n {
	NSLog(@"Detached thread: %@", [NSThread currentThread]);
	[NSNumber numberWithInteger:n]; // Create object to make sure we have autorelease pool
	XCTAssertTrue(1 == n);
	invokeDetachCalled_ = YES;
}

// TODO(gabe): Fix test so this does something, but seems to work
- (void)_detachCallback:(id)context {  }

@end
