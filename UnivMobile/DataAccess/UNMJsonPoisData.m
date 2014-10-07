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

@property (weak, atomic) UNMAppLayer* appLayer;
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

- (instancetype) initWithAppLayer:(UNMAppLayer*)appLayer jsonBaseURL:(NSString*)jsonBaseURL {
	
	self = [super init];
	
	if (self) {
		
		self.appLayer = appLayer;
		self.jsonBaseURL = jsonBaseURL;
	}
	
	return self;
}

- (UNMPoisData*) fetchPoisData:(NSObject<UNMJsonFetcher>*)jsonFetcher
					withErrorHandler:(void(^)(NSError*))onError {

	// NSLog(@"fetchPoisData...");

	NSString* const url = self.appLayer.location
		? [self.jsonBaseURL stringByAppendingFormat:@"pois?lat=%f&lng=%f",
		   self.appLayer.location.coordinate.latitude, self.appLayer.location.coordinate.longitude]
	:[self.jsonBaseURL stringByAppendingString:@"pois"];
	
	// NSLog(@"fetchPoisData:url: %@", url);
	
	id const json = [jsonFetcher syncJsonGetURL:url withErrorHandler:onError];
	
	// NSLog(@"fetchPoisData -> json: %@", json);
	
	if (!json) return nil; // Error is already handled by callback
	
	NSError* error = nil;
	
	UNMPoisData* const poisData = [MTLJSONAdapter modelOfClass:[UNMPoisData class] fromJSONDictionary:json error:&error];
	
	if (error) {
		
		NSLog(@"Error: %@", error);
		
		if (onError) onError(error);
		
		return nil;
	}
	
	// NSLog(@"fetchPoisData:poisData: %@", poisData);
	
	if (!poisData) {
		
		NSLog(@"Error: poisData == nill");
		
		if (onError) onError([NSError errorWithDomain:@"UNMJsonPoisData" code:2 userInfo:nil]);
		
		return nil;
	}
	
	return poisData;
}

@end
