//
//  UNMPoisData.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 01/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMPoisData.h"

@implementation UNMPoiGroupData

- (NSUInteger) sizeOfPoiData {
	
	return [self.pois count];
}

- (UNMPoiData*) poiDataAtIndex:(NSUInteger)row {
	
	return [self.pois objectAtIndex:row];
}

// Override: MTLJSONSerializing
+ (NSDictionary*) JSONKeyPathsByPropertyKey {
	
	NSMutableDictionary* const map = [NSMutableDictionary new];
	
	// add: [super JSONKeyPathsByPropertyKey];
	
	[map addEntriesFromDictionary:@{
									@"groupLabel":@"groupLabel",
									@"pois": @"pois"
									}];
	
	return map;
}

// Override: MTLJSONSerializing
+ (NSValueTransformer*)poisJSONTransformer {
	
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[UNMPoiData class]];
}

@end

@implementation UNMPoisData

- (NSUInteger) sizeOfPoiGroupData {
	
	return [self.poiGroups count];
}

- (UNMPoiGroupData*) poiGroupDataAtIndex:(NSUInteger)row {
	
	return [self.poiGroups objectAtIndex:row];
}

// Override: MTLJSONSerializing
+ (NSDictionary*) JSONKeyPathsByPropertyKey {
	
	NSMutableDictionary* const map = [NSMutableDictionary new];
	
	// add: [super JSONKeyPathsByPropertyKey];
	
	[map addEntriesFromDictionary:@{
									@"poiGroups": @"groups"
									}];
	
	return map;
}

// Override: MTLJSONSerializing
+ (NSValueTransformer*)poiGroupsJSONTransformer {
	
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[UNMPoiGroupData class]];
}

@end
