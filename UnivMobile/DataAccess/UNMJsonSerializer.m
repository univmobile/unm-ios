//
//  UNMJsonSerializer.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 09/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMJsonSerializer.h"

@implementation UNMJsonSerializer

+ (id) jsonDeserialize:(NSData*)data withErrorHandler:(void(^)(NSError*))onError {

	if (!data) {
		
		NSLog(@"Error: data == nill");
		
		if (onError) onError([NSError errorWithDomain:@"UNMJsonFetcherFileSystem" code:1 userInfo:nil]);
		
		return nil;
	}

	NSError* error = nil;
	
	id const json = [NSJSONSerialization JSONObjectWithData:data
													options:kNilOptions
													  error:&error];
	
	if (error) {
		
		NSLog(@"Error: %@", error);
		
		if (onError) onError(error);
		
		return nil;
	}
	
	return json;
}

@end
