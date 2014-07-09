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

@implementation UNMJsonRegionsData

+ (UNMRegionsData*) fetchRegionsData:(NSObject<UNMJsonFetcher>*)jsonFetcher
					withErrorHandler:(void(^)(NSError*))onError {
	
	NSString* const url = @"http://univmobile.vswip.com/unm-backend-mock/regions";
	
	id const json = [jsonFetcher syncFetchJsonAtURL:url withErrorHandler:onError];

	if (!json) return nil; // Error is already handled by callback
	
	NSError* error = nil;
	
	id regionsData = [MTLJSONAdapter modelOfClass:[UNMRegionsData class] fromJSONDictionary:json error:&error];
	
	if (error) {
		
		NSLog(@"Error: %@", error);
		
		if (onError) onError(error);
		
		return nil;
	}
	
	if (!regionsData) {
		
		NSLog(@"Error: regionsData == nill");
		
		if (onError) onError([NSError errorWithDomain:@"UNMJsonRegionsData" code:2 userInfo:nil]);
		
		return nil;
	}

	return regionsData;
}


@end
