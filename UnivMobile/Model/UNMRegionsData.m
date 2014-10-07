//
//  UNMRegionsData.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 09/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMRegionsData.h"

@interface UNMRegionsData ()

@end

@implementation UNMRegionsData

- (instancetype)init {
	
	self = [super init];
	
	if (self) {
		
	//	_regionsMutable = [[NSMutableArray alloc] init];
		
	//	_regions = _regionsMutable;
	}
	
	return self;
}

- (void)addRegionWithId:(NSString*)id label:(NSString*)label {
	
	UNMRegionData* const regionData = [[UNMRegionData alloc] initWithId:id label:label];
	
	NSMutableArray* const regionsMutable = [[NSMutableArray alloc] initWithArray:_regions];
	
	[regionsMutable addObject:regionData];
	
	_regions = regionsMutable;
}

- (void)addUniversityId:(NSString*)id title:(NSString*)title
shibbolethIdentityProvider:(NSString*)shibbolethIdentityProvider
toRegionId:(NSString*)regionId {
	
	UNMRegionData* const regionData = [self regionDataById:regionId];
	
	if (regionData) {
		
		[regionData addUniversityWithId:id title:title shibbolethIdentityProvider:shibbolethIdentityProvider];
	}
}

- (NSString*)lastDataRefreshDayAsString {
	
	NSDateFormatter* const dateFormatter = [NSDateFormatter new];
	
	dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
	
	dateFormatter.dateStyle = NSDateFormatterShortStyle;
	dateFormatter.timeStyle = NSDateFormatterNoStyle;
	
	return [dateFormatter stringFromDate:self.refreshedAt];
}

- (NSString*)lastDataRefreshTimeAsString {
	
	NSDateFormatter* const dateFormatter = [NSDateFormatter new];
	
	dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
	
	dateFormatter.dateStyle = NSDateFormatterNoStyle;
	dateFormatter.timeStyle = NSDateFormatterMediumStyle;
	
	return [dateFormatter stringFromDate:self.refreshedAt];
}

- (NSUInteger) sizeOfRegionData {
	
	return [self.regions count];
}

- (UNMRegionData*) regionDataAtIndex:(NSUInteger)row {
	
	return [self.regions objectAtIndex:row];
}

- (UNMRegionData*)regionDataById:(NSString*)regionId {
	
	for (UNMRegionData* const regionData in self.regions) {
		
		if ([regionData.id isEqualToString:regionId]) {
			
			return regionData;
		}
	}
	
	return nil;
}

- (UNMUniversityData*)universityDataById:(NSString*)universityId {
	
	for (UNMRegionData* const regionData in self.regions) {
		
		for (UNMUniversityData* const universityData in regionData.universities) {
			
			if ([universityData.id isEqualToString:universityId]) {
				
				return universityData;
			}
		}
	}
	
	return nil;
}

// Override: MTLJSONSerializing
+ (NSDictionary*) JSONKeyPathsByPropertyKey {
	
	NSMutableDictionary* const map = [NSMutableDictionary new];
	
	// add: [super JSONKeyPathsByPropertyKey];
	
	[map addEntriesFromDictionary:@{
									@"regions": @"regions"
									}];
	
	return map;
}

// Override: MTLJSONSerializing
+ (NSValueTransformer*)regionsJSONTransformer {
	
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[UNMRegionData class]];
}

@end
