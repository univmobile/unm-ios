//
//  UNMJsonCommentsData.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 02/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMJsonCommentsData.h"

@implementation UNMJsonCommentsData

- (UNMCommentsData*) fetchCommentsData:(NSObject<UNMJsonFetcher>*)jsonFetcher
							   withPoi:(UNMPoiData*)poi
					  errorHandler:(void(^)(NSError*))onError {
	
	//NSLog(@"fetchCommentsData... poi null?%d", poi == nil);
	
	NSString* const url = poi.commentsUrl;
	
	 //NSLog(@"fetchCommentsData: %@", url);
	
	id const json = [jsonFetcher syncJsonGetURL:url withErrorHandler:onError];
	
	// NSLog(@"fetchCommentsData -> json: %@", json);
	
	if (!json) return nil; // Error is already handled by callback
	
	NSError* error = nil;
	
	id commentsData = [MTLJSONAdapter modelOfClass:[UNMCommentsData class] fromJSONDictionary:json error:&error];
	
	if (error) {
		
		NSLog(@"Error: %@", error);
		
		if (onError) onError(error);
		
		return nil;
	}
	
	if (!commentsData) {
		
		NSLog(@"Error: commentsData == nill");
		
		if (onError) onError([NSError errorWithDomain:@"UNMJsonCommentsData" code:2 userInfo:nil]);
		
		return nil;
	}
	
	return commentsData;
}

@end
