//
//  UNMUtilsTest.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 29/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UNMUtils.h"

@interface UNMUtilsTest : XCTestCase

@end

@implementation UNMUtilsTest

- (void)setUp {

    [super setUp];

}

- (void)tearDown {

    [super tearDown];
}

- (void)test_urlEncode_simple {

	XCTAssertEqualObjects(@"toto", [UNMUtils urlEncode:@"toto"]);
}

- (void)test_urlEncode_spaces {
	
	XCTAssertEqualObjects(@"a%20b%20c", [UNMUtils urlEncode:@"a b c"]);
}

- (void)test_urlEncode_plus {
	
	XCTAssertEqualObjects(@"Hello%2BWorld%21", [UNMUtils urlEncode:@"Hello+World!"]);
}

- (void)test_urlEncode_amp {
	
	XCTAssertEqualObjects(@"Bob%26Alice", [UNMUtils urlEncode:@"Bob&Alice"]);
}

- (void)test_urlEncode_questionMark {
	
	XCTAssertEqualObjects(@"Really%3F", [UNMUtils urlEncode:@"Really?"]);
}

- (void)test_urlEncode_slash {
	
	XCTAssertEqualObjects(@"a%2Fb", [UNMUtils urlEncode:@"a/b"]);
}

- (void)test_urlEncode_colon {
	
	XCTAssertEqualObjects(@"a%3Ab", [UNMUtils urlEncode:@"a:b"]);
}

- (void)test_urlEncode_equalSign {
	
	XCTAssertEqualObjects(@"0%2B0%3D0", [UNMUtils urlEncode:@"0+0=0"]);
}

@end
