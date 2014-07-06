//
//  UNMAppLayer.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 06/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UNMRegionData.h"

// Objects in the App Layer (applicative layer) are responsible for
// the data and the coordination between View Controllers.
@interface UNMAppLayer : NSObject

@property (copy, nonatomic) NSString* selectedRegionId;
@property (copy, nonatomic) NSString* selectedUniversityId;

- (NSUInteger) sizeOfRegionData;

- (UNMRegionData*) getRegionDataAtIndex:(NSUInteger)row;

- (UNMRegionData*) getRegionDataById:(NSString*)regionId;

- (UNMUniversityData*) getUniversityDataById:(NSString*)universityId;

// Allow callbacks
- (void) setSelectedRegionIdInList:(NSString*)regionId;

// Allow callbacks
- (void) setSelectedUniversityIdInList:(NSString*)universityId;

// Allow callbacks
- (void) goBackFromRegions;

// Allow callbacks
- (void) showUniversityList;

- (void) addCallback:(NSObject*)callback;

@end
