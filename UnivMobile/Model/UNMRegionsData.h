//
//  UNMRegionsData.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 09/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UNMRegionData.h"

@interface UNMRegionsData : NSObject

@property (strong, nonatomic) NSDate* refreshedAt;

@property (weak, nonatomic, readonly) NSArray* regions; // array of UNMRegionData*

- (NSUInteger) sizeOfRegionData;

- (UNMRegionData*) getRegionDataAtIndex:(NSUInteger)row;

- (UNMRegionData*) getRegionDataById:(NSString*)regionId;

- (UNMUniversityData*) getUniversityDataById:(NSString*)universityId;

- (void)addRegionWithId:(NSString*)id label:(NSString*)label;

- (void)addUniversityId:(NSString*)id title:(NSString*)title toRegionId:(NSString*)regionId;

- (NSString*)lastDataRefreshDayAsString;
- (NSString*)lastDataRefreshTimeAsString;

@end
