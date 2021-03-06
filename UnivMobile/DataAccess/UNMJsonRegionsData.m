//
//  UNMJsonRegionsData.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 09/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMJsonRegionsData.h"
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle.h>

@interface UNMUniversitiesData : MTLModel <MTLJSONSerializing>

@property (strong, atomic) NSArray* universities; // Array of UNMUniversityData

@end

@interface UNMJsonRegionsData ()

@property (copy, atomic) NSString* jsonBaseURL;

@end

@implementation UNMJsonRegionsData

- (instancetype) init {
	
	NSLog(@"IllegalStateException: UNMJsonRegionsData.init()");
	
	@throw [NSException
			exceptionWithName:@"IllegalStateException"
			reason:@"init() should not be called"
			userInfo:nil];
}

- (instancetype) initWithJSONBaseURL:(NSString*)jsonBaseURL {
	
	self = [super init];
	
	if (self) {

		self.jsonBaseURL = jsonBaseURL;
	}
	
	return self;
}

- (UNMRegionsData*) fetchRegionsData:(NSObject<UNMJsonFetcher>*)jsonFetcher
					withErrorHandler:(void(^)(NSError*))onError {
	
	NSString* const url = // @"http://univmobile.vswip.com/unm-backend-mock/regions";
	// @"https://univmobile-dev.univ-paris1.fr/json/regions";
	[self.jsonBaseURL stringByAppendingString:@"regions"];
	
	// NSLog(@"fetchRegionsData:url: %@", url);
	
	id const json = [jsonFetcher syncJsonGetURL:url withErrorHandler:onError];

	// NSLog(@"fetchRegionsData -> json: %@", json);

	if (!json) return nil; // Error is already handled by callback
	
	NSError* error = nil;
	
	id regionsData = [MTLJSONAdapter modelOfClass:[UNMRegionsData class] fromJSONDictionary:json error:&error];
	
	if (error) {
		
		NSLog(@"Error: %@", error);
		
		if (onError) onError(error);
		
		return nil;
	}
	
	// NSLog(@"fetchRegionsData:regionsData: %@", regionsData);
	
	if (!regionsData) {
		
		NSLog(@"Error: regionsData == nill");
		
		if (onError) onError([NSError errorWithDomain:@"UNMJsonRegionsData" code:2 userInfo:nil]);
		
		return nil;
	}

	for (UNMRegionData* const regionData in ((UNMRegionsData*)regionsData).regions) {
		
		NSString* const universitiesUrl = regionData.universitiesUrl;
		
		//NSLog(@"universitiesUrl: %@", universitiesUrl);
		
		id const universitiesJson = [jsonFetcher syncJsonGetURL:universitiesUrl withErrorHandler:onError];
		
		// TODO continue;? return nil;? Alert?
		if (!universitiesJson) continue; // Error is already handled by callback
		
		id const universitiesData = [MTLJSONAdapter modelOfClass:[UNMUniversitiesData class]
										 fromJSONDictionary:universitiesJson
													  error:&error];
		
		if (error) {
			
			NSLog(@"Error: %@", error);
			
			if (onError) onError(error);
			
			return nil;
		}
		
		if (!universitiesData) {
			
			NSLog(@"Error: universitiesData == nill");
			
			if (onError) onError([NSError errorWithDomain:@"UNMJsonRegionsData" code:3 userInfo:nil]);
			
			return nil;
		}
		
		regionData.universities = ((UNMUniversitiesData*)universitiesData).universities;
	}
	
	return regionsData;
}

@end

@implementation UNMUniversitiesData

// Override: MTLJSONSerializing
+ (NSDictionary*) JSONKeyPathsByPropertyKey {
	
	NSMutableDictionary* const map = [NSMutableDictionary new];
	
	// add: [super JSONKeyPathsByPropertyKey];
	
	[map addEntriesFromDictionary:@{
									@"universities": @"universities"
									}];
	
	return map;
}

// Override: MTLJSONSerializing
+ (NSValueTransformer*)universitiesJSONTransformer {
	
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[UNMUniversityData class]];
}

@end
