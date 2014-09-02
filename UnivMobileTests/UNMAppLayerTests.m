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
	
	self.appLayer = [[UNMAppLayer alloc] initWithBundle:[NSBundle bundleForClass:[UNMAppLayer class]]
											jsonFetcher:jsonFetcher];
}

- (void)tearDown {
	
    [super tearDown];
}

- (void)testAppLayer_loadInitialData_sizeOfRegionsIs3 {
	
	UNMRegionsData* const regionsData = self.appLayer.loadInitialRegionsData;

	XCTAssertEqual(3, [regionsData.regions count]);
}

- (void)testAppLayer_loadInitialData_sizeOfUniversitiesIleDeFranceIs18 {
	
	UNMRegionsData* const regionsData = self.appLayer.loadInitialRegionsData;
	
	XCTAssertEqual(18, [[regionsData regionDataById:@"ile_de_france"].universities count]);
}

- (void)testAppLayer_loadInitialData_regionByIdTotoIsNill {
	
	UNMRegionsData* const regionsData = self.appLayer.loadInitialRegionsData;
	
	XCTAssertNil([regionsData regionDataById:@"toto"]);
}

- (void)testAppLayer_loadInitialData_regionByIdBretagneTitleIsBretagne {
	
	UNMRegionsData* const regionsData = self.appLayer.loadInitialRegionsData;
	
	XCTAssertEqualObjects(@"Bretagne", [regionsData regionDataById:@"bretagne"].label);
}

- (void)testAppLayer_loadInitialData_regionByIdBretagneIdIsBretagne {
	
	UNMRegionsData* const regionsData = self.appLayer.loadInitialRegionsData;
	
	XCTAssertEqualObjects(@"bretagne", [regionsData regionDataById:@"bretagne"].id);
}

- (void)testAppLayer_loadInitialData_universityByIdParis11TitleIsParisSud {
	
	UNMRegionsData* const regionsData = self.appLayer.loadInitialRegionsData;
	
	XCTAssertEqualObjects(@"Paris-Sud", [regionsData universityDataById:@"paris11"].title);
}

- (void)testAppLayer_loadInitialData_universityByIdParis11IdIsParis11 {
	
	UNMRegionsData* const regionsData = self.appLayer.loadInitialRegionsData;
	
	XCTAssertEqualObjects(@"paris11", [regionsData universityDataById:@"paris11"].id);
}

- (void)testAppLayer_refreshRegionsData_sizeOfRegionsIs3 {

	const UNMRegionsData* regionsData = self.appLayer.loadInitialRegionsData;

	[self.appLayer refreshRegionsData];
	
	regionsData = self.appLayer.regionsData;
	
	XCTAssertEqual(3, [regionsData.regions count]);
}

- (void)testAppLayer_refreshRegionsData_newDateIsDifferent {
	
	const NSDate* date = self.appLayer.loadInitialRegionsData.refreshedAt;
	
	[self.appLayer refreshRegionsData];
	
	XCTAssertNotEqualObjects(date, self.appLayer.regionsData.refreshedAt);
}

- (void)testAppLayer_refreshRegionsData_newDataObjectIsDifferent {
	
	const UNMRegionsData* const regionsData = self.appLayer.loadInitialRegionsData;
	
	[self.appLayer refreshRegionsData];
	
	XCTAssertNotEqual(regionsData, self.appLayer.regionsData);
}

- (void)testAppLayer_refreshRegionsData_sizeOfUniversitiesIleDeFranceIs18 {
	
	[self.appLayer loadInitialRegionsData];
	
	[self.appLayer refreshRegionsData];
	
	XCTAssertEqual(18, [[self.appLayer.regionsData regionDataById:@"ile_de_france"].universities count]);
}

- (void)testAppLayer_refreshRegionsData_regionByIdTotoIsNill {
	
	[self.appLayer loadInitialRegionsData];
	
	[self.appLayer refreshRegionsData];
	
	XCTAssertNil([self.appLayer.regionsData regionDataById:@"toto"]);
}

- (void)testAppLayer_refreshRegionsData_regionByIdBretagneTitleIsBretagne {
	
	[self.appLayer loadInitialRegionsData];
	
	[self.appLayer refreshRegionsData];
	
	XCTAssertEqualObjects(@"Bretagne", [self.appLayer.regionsData regionDataById:@"bretagne"].label);
}

- (void)testAppLayer_refreshRegionsData_regionByIdBretagneIdIsBretagne {
	
	[self.appLayer loadInitialRegionsData];
	
	[self.appLayer refreshRegionsData];
	
	XCTAssertEqualObjects(@"bretagne", [self.appLayer.regionsData regionDataById:@"bretagne"].id);
}

- (void)testAppLayer_refreshRegionsData_universityByIdParis11TitleIsParisSud {
	
	[self.appLayer loadInitialRegionsData];
	
	[self.appLayer refreshRegionsData];
	
	XCTAssertEqualObjects(@"Paris-Sud", [self.appLayer.regionsData universityDataById:@"paris11"].title);
}

- (void)testAppLayer_refreshRegionsData_universityByIdParis11IdIsParis11 {
	
	[self.appLayer loadInitialRegionsData];
	
	[self.appLayer refreshRegionsData];
	
	XCTAssertEqualObjects(@"paris11", [self.appLayer.regionsData universityDataById:@"paris11"].id);
}

@end
