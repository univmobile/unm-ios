//
//  UNMAppLayerTests.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 03/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMAppLayer.h"
#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "UNMJsonFetcherFileSystem.h"

@interface UNMAppLayerTests : XCTestCase

@property (strong, nonatomic) UNMAppLayer* appLayer;

@end

@implementation UNMAppLayerTests

- (void)setUp {
	
    [super setUp];
	
	NSObject<UNMJsonFetcher>* const jsonFetcher = [UNMJsonFetcherFileSystem new];
	
	self.appLayer = [[UNMAppLayer alloc] initWithJsonFetcher:jsonFetcher];
}

- (void)tearDown {
	
    [super tearDown];
}

- (void)testAppLayer_loadInitialData_sizeOfRegionsIs3 {
	
	UNMRegionsData* const regionsData = self.appLayer.loadInitialRegionsData;

	XCTAssertEqual(3, [regionsData.regions count]);
}

@end
