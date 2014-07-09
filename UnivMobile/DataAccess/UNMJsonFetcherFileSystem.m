//
//  UNMJsonFetcherFileSystem.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 09/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMJsonFetcherFileSystem.h"
#import "UNMJsonSerializer.h"

@implementation UNMJsonFetcherFileSystem

- (id) syncFetchJsonAtURL:(NSString*)path withErrorHandler:(void(^)(NSError*))onError {
	
	// @"http://univmobile.vswip.com/unm-backend-mock/regions"
	
	NSString* filePath = nil;
	
	if (path.length > 8 && [[path substringFromIndex:[path length] - 8] isEqual:@"/regions"]) {
		
		filePath = @"/Users/dandriana/Documents/xcode/unm-ios/src/test/json/regions.json";
		
	} else if (![[path substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"http"]) {
		
		filePath = [NSString
					stringWithFormat:
					@"/Users/dandriana/Documents/xcode/unm-ios/src/test/json/listUniversities_%@.json",path];
	}
	
	if (!filePath) return nil;
	
	const NSDataReadingOptions options;
	
	NSError* error = nil;
	
	NSData* const data = [NSData dataWithContentsOfFile:filePath options:options error:&error];
	
	if (error) {
		
		NSLog(@"Error: %@", error);
		
		if (onError) onError(error);
		
		return nil;
	}
	
	return [UNMJsonSerializer jsonDeserialize:data withErrorHandler:onError];
}

@end
