//
//  UNMPoisData.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 01/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

@import Foundation;
#import <Mantle.h>
#import "UNMPoiData.h"

@interface UNMPoiGroupData : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic) NSString* groupLabel; // e.g. @"Région : Île de France"

@property (strong, nonatomic) NSArray* pois; // array of UNMPoiData*

- (NSUInteger) sizeOfPoiData;

- (UNMPoiData*) poiDataAtIndex:(NSUInteger)row;

//- (UNMPoiData*) poiDataById:(NSUInteger*) poiId;

@end

@interface UNMPoisData : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSArray* poiGroups; // array of UNMPoiGroupData*

- (NSUInteger) sizeOfPoiGroupData;

- (UNMPoiGroupData*) poiGroupDataAtIndex:(NSUInteger)row;

@end