//
//  UNMRegionsData.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 09/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

@import Foundation;
#import "UNMRegionData.h"
#import <Mantle/Mantle.h>

@interface UNMRegionsData : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSDate* refreshedAt;
@property (strong, nonatomic) NSArray* regions; // array of UNMRegionData*

- (NSUInteger) sizeOfRegionData;

- (UNMRegionData*) regionDataAtIndex:(NSUInteger)row;

- (UNMRegionData*) regionDataById:(NSString*)regionId;

- (UNMUniversityData*) universityDataById:(NSString*)universityId;

- (void)addRegionWithId:(NSString*)id label:(NSString*)label;

- (void)addUniversityId:(NSString*)id title:(NSString*)title
shibbolethIdentityProvider:(NSString*)shibbolethIdentityProvider
toRegionId:(NSString*)regionId;

- (NSString*)lastDataRefreshDayAsString;
- (NSString*)lastDataRefreshTimeAsString;

@end
