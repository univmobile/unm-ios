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
	
	if (!path) @throw [NSException
					   exceptionWithName:@"NullPointerException"
					   reason:@"syncFetchJsonAtURL(path = nil)"
					   userInfo:nil];

	// @"http://univmobile.vswip.com/unm-backend-mock/regions"
	// @"https://univmobile-dev.univ-paris1.fr/json/regions"
	
	NSString* filePath = nil;
	
	// e.g. @"/Users/dandriana/Documents/xcode/unm-ios/UnivMobile/DataAccess/UNMJsonFetcherFileSystem.m"
	NSString* const THIS_SRCFILE_PATH = [NSString stringWithFormat:@"%s", __FILE__];
	
	// e.g. @"/Users/dandriana/Documents/xcode/unm-ios/"
	NSString* const THIS_PROJECT_PATH = [THIS_SRCFILE_PATH
										 substringWithRange:NSMakeRange(0, THIS_SRCFILE_PATH.length - 48)];
	if (path.length > 8 && [[path substringFromIndex:[path length] - 8] isEqual:@"/regions"]) {
		
		filePath = [THIS_PROJECT_PATH stringByAppendingString:@"src/test/json/regions.json"];
		
//	} else if (![[path substringWithRange:NSMakeRange(0, 4)] isEqualToString:@"http"]) {
	} else  if ([path rangeOfString:@"/json/listUniversities_"].location != NSNotFound) {
		
		filePath = [NSString
					stringWithFormat:
					@"%@src/test/json/listUniversities_%@",THIS_PROJECT_PATH,
					//path];
					[path substringFromIndex:[path rangeOfString:@"/json/listUniversities_"].location +23
					 ]];
	}
	
	if (!filePath) return nil;
	
	const NSDataReadingOptions options;
	
	NSError* error = nil;
	
	//				NSLog(@"UNMJsonFetcherFileSystem.syncFetchJsonAtURL:filePath: %@", filePath);
					
	NSData* const data = [NSData dataWithContentsOfFile:filePath options:options error:&error];
	
	if (error) {
		
		NSLog(@"Error: %@", error);
		
		if (onError) onError(error);
		
		return nil;
	}
	
	return [UNMJsonSerializer jsonDeserialize:data withErrorHandler:onError];
}

@end
