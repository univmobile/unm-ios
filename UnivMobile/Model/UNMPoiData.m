//
//  UNMPoiData.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 01/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMPoiData.h"

@implementation UNMPoiData

- (instancetype)initWithId:(NSUInteger)id name:(NSString *)name {
	
    self = [super init];
    
	if (self) {
		
		_id = id;
		_name = name;
	}
	
    return self;
}

// Override: MTLJSONSerializing
+ (NSDictionary*) JSONKeyPathsByPropertyKey {
	
	NSMutableDictionary* const map = [NSMutableDictionary new];
	
	// add: [super JSONKeyPathsByPropertyKey];
	
	[map addEntriesFromDictionary:@{
									@"id": @"id",
									@"name": @"name",
									@"address": @"address",
									@"openingHours":@"openingHours",
									@"floor":@"floor",
									@"itinerary":@"itinerary",
									@"email":@"email",
									@"phone":@"phone",
									@"url":@"url",
									@"coordinates":@"coordinates",
									@"lat":@"lat",
									@"lng":@"lng",
									@"commentsUrl":@"comments.url"
									}];
	
	return map;
}

@end
