//
//  UNMRegionsData.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 09/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMRegionsData.h"

@interface UNMRegionsData ()

@property (retain, nonatomic, readonly) NSMutableArray* regionsMutable; // Mutable array of UNMRegionData*

@end

@implementation UNMRegionsData

- (instancetype)init {
		
	self = [super init];
	
	if (self) {
		
		_regionsMutable = [[NSMutableArray alloc] init];
		
		_regions = _regionsMutable;
	}
	
	return self;
}

- (void)addRegionWithId:(NSString*)id label:(NSString*)label {
	
	UNMRegionData* const regionData = [[UNMRegionData alloc] initWithId:id label:label];
	
	[self.regionsMutable addObject:regionData];
}

- (void)addUniversityId:(NSString*)id title:(NSString*)title toRegionId:(NSString*)regionId {
	
	UNMRegionData* const regionData = [self getRegionDataById:regionId];
	
	if (regionData) {
		
		[regionData addUniversityWithId:id title:title];
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
	dateFormatter.timeStyle = NSDateFormatterShortStyle;

	return [dateFormatter stringFromDate:self.refreshedAt];
}

- (NSUInteger) sizeOfRegionData {
	
	return [self.regions count];
}

- (UNMRegionData*) getRegionDataAtIndex:(NSUInteger)row {
	
	return [self.regions objectAtIndex:row];
}

- (UNMRegionData*)getRegionDataById:(NSString*)regionId {
	
	for (UNMRegionData* const regionData in self.regions) {
		
		if ([regionData.id isEqualToString:regionId]) {
			
			return regionData;
		}
	}
	
	return nil;
}

- (UNMUniversityData*)getUniversityDataById:(NSString*)universityId {
	
	for (UNMRegionData* const regionData in self.regions) {
		
		for (UNMUniversityData* const universityData in regionData.universities) {
			
			if ([universityData.id isEqualToString:universityId]) {
				
				return universityData;
			}
		}
	}
	
	return nil;
}

@end
