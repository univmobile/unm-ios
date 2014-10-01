//
//  UNMAppLayer.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 06/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

@import Foundation;
#import "UNMRegionsData.h"
#import "UNMPoisData.h"
#import "UNMAppViewCallback.h"
#import "UNMBuildInfo.h"
#import "UNMJsonFetcher.h"
#import "UNMAppToken.h"
#import <CoreLocation/CLLocation.h>

// Objects in the App Layer (applicative layer) are responsible for
// the data and the coordination between View Controllers.
@interface UNMAppLayer : NSObject

@property (copy, nonatomic) NSString* selectedRegionId;
@property (copy, nonatomic) NSString* selectedUniversityId;
@property (strong, nonatomic, readonly) UNMRegionsData* regionsData;
@property (strong, nonatomic, readonly) UNMPoisData* poisData;
@property (strong, nonatomic, readonly) UNMBuildInfo* buildInfo;
@property (strong, nonatomic, readonly) UNMAppToken* appToken;
@property (strong, nonatomic, readonly) CLLocation* location;

- (instancetype) initWithBundle:(NSBundle*)bundle jsonFetcher:(NSObject<UNMJsonFetcher>*)jsonFetcher;

- (UNMRegionsData*) loadInitialRegionsData;

- (UNMPoiData*) poiById:(NSInteger)poiId;

- (NSArray*) loadCommentsForPoi:(const UNMPoiData*)poi;

- (BOOL) login:(NSString*)login password:(NSString*)password apiKey:(NSString*)apiKey;

- (void) addCallback:(NSObject<UNMAppViewCallback>*)callback;

// Allow callbacks
- (void) setSelectedRegionIdInList:(NSString*)regionId;

// Allow callbacks
- (void) setSelectedUniversityIdInList:(NSString*)universityId;

// Allow callbacks
- (void) goBackFromRegions;

// Allow callbacks
- (void) goBackFromGeocampus;

// Allow callbacks
- (void) goBackFromLogin;

// Allow callbacks
- (void) goBackFromLoginClassic;

// Allow callbacks
- (void) goFromLoginToLoginClassic;

// Allow callbacks
- (void) goFromLoginClassicToProfile;

// Allow callbacks
- (void) goBackFromProfile;

// Allow callbacks
- (void) showUniversityList;

// Allow callbacks
- (void) refreshRegionsData;

// Allow callbacks
- (void) refreshPoisData;

// Allow callbacks
- (void) logout;

// Allow callbacks
- (void) updateLocation:(CLLocation*)location;

@end
