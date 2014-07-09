//
//  UNMAppLayer.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 06/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

@import Foundation;
#import "UNMRegionsData.h"
#import "UNMAppViewCallback.h"
#import "UNMBuildInfo.h"
#import "UNMJsonFetcher.h"

// Objects in the App Layer (applicative layer) are responsible for
// the data and the coordination between View Controllers.
@interface UNMAppLayer : NSObject

@property (copy, nonatomic) NSString* selectedRegionId;
@property (copy, nonatomic) NSString* selectedUniversityId;
@property (strong, nonatomic, readonly) UNMRegionsData* regionsData;
@property (strong, nonatomic, readonly) UNMBuildInfo* buildInfo;

- (instancetype) initWithJsonFetcher:(NSObject<UNMJsonFetcher>*) jsonFetcher;

- (UNMRegionsData*) loadInitialRegionsData;

// Allow callbacks
- (void) setSelectedRegionIdInList:(NSString*)regionId;

// Allow callbacks
- (void) setSelectedUniversityIdInList:(NSString*)universityId;

// Allow callbacks
- (void) goBackFromRegions;

// Allow callbacks
- (void) showUniversityList;

// Allow callbacks
- (void) refreshRegionsData;

- (void) addCallback:(NSObject<UNMAppViewCallback>*)callback;

@end
