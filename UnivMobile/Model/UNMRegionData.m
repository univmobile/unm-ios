//
//  UNMRegionData.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 04/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMRegionData.h"

@interface UNMRegionData ()

@property (strong, nonatomic) NSMutableArray* universitiesMutable; // mutable array of UNMUniversityData*

@end

@implementation UNMRegionData

- (instancetype)initWithId:(NSString*)id label:(NSString*)label {
	
    self = [super init];
    
	if (self) {
		
		_id = id;
		_label = label;
		
		_universitiesMutable = [[NSMutableArray alloc] init];
		
		_universities = self.universitiesMutable;
	}
	
    return self;
}

- (void)addUniversityWithId:(NSString*)id title:(NSString*)title
shibbolethIdentityProvider:(NSString*)shibbolethIdentityProvider {
	
	UNMUniversityData* const university = [[UNMUniversityData alloc] initWithId:id title:title
													  shibbolethIdentityProvider:shibbolethIdentityProvider];
	
	[self.universitiesMutable addObject:university];
}

// Override: MTLJSONSerializing
+ (NSDictionary*) JSONKeyPathsByPropertyKey {
	
	NSMutableDictionary* const map = [NSMutableDictionary new];
	
	// add: [super JSONKeyPathsByPropertyKey];
	
	[map addEntriesFromDictionary:@{
									@"id": @"id",
									@"label":@"label",
									@"universitiesUrl": @"url"
									}];
	
	return map;
}

@end

@implementation UNMUniversityData

- (instancetype)initWithId:(NSString*)id title:(NSString*)title
shibbolethIdentityProvider:(NSString*)shibbolethIdentityProvider {
	
    self = [super init];
    
	if (self) {
		
		_id = id;
		_title = title;
		_shibbolethIdentityProvider = shibbolethIdentityProvider;
	}
	
    return self;
}

// Override: MTLJSONSerializing
+ (NSDictionary*) JSONKeyPathsByPropertyKey {
	
	NSMutableDictionary* const map = [NSMutableDictionary new];
	
	// add: [super JSONKeyPathsByPropertyKey];
	
	[map addEntriesFromDictionary:@{
									@"id": @"id",
									@"title": @"title",
									@"shibbolethIdentityProvider": @"shibboleth.identityProvider"
									}];
	
	return map;
}

@end
