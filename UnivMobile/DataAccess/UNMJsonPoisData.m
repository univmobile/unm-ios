//
//  UNMJsonPoisData.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 01/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMJsonPoisData.h"
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle.h>

@interface UNMJsonPoisData ()

@property (copy, atomic) NSString* jsonBaseURL;

@end

@implementation UNMJsonPoisData

- (instancetype) init {
	
	NSLog(@"IllegalStateException: UNMJsonPoisData.init()");
	
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

- (UNMPoisData*) fetchPoisData:(NSObject<UNMJsonFetcher>*)jsonFetcher
					withErrorHandler:(void(^)(NSError*))onError {

	// NSLog(@"fetchPoisData...");

	NSString* const url = [self.jsonBaseURL stringByAppendingString:@"pois"];
	
	// NSLog(@"fetchPoisData:url: %@", url);
	
	id const json = [jsonFetcher syncFetchJsonAtURL:url withErrorHandler:onError];
	
	// NSLog(@"fetchPoisData -> json: %@", json);
	
	if (!json) return nil; // Error is already handled by callback
	
	NSError* error = nil;
	
	id poisData = [MTLJSONAdapter modelOfClass:[UNMPoisData class] fromJSONDictionary:json error:&error];
	
	if (error) {
		
		NSLog(@"Error: %@", error);
		
		if (onError) onError(error);
		
		return nil;
	}
	
	// NSLog(@"fetchPoisData:poisData: %@", poisData);
	
	if (!poisData) {
		
		NSLog(@"Error: poisData == nill");
		
		if (onError) onError([NSError errorWithDomain:@"UNMJsonPoiData" code:2 userInfo:nil]);
		
		return nil;
	}
	
	for (UNMPoiGroupData* const poiGroupData in ((UNMPoisData*)poisData).poiGroups) {

		// NSLog(@"poiGroup: %@", poiGroupData.groupLabel);
		/*
		NSString* const universitiesUrl = regionData.universitiesUrl;
		
		NSLog(@"universitiesUrl: %@", universitiesUrl);
		
		id const universitiesJson = [jsonFetcher syncFetchJsonAtURL:universitiesUrl withErrorHandler:onError];
		
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
		 */
	}
	
	return poisData;
}

@end
