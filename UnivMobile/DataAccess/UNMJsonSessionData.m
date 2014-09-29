//
//  UNMJsonSessionData.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 29/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMJsonSessionData.h"

@interface UNMJsonSessionData ()

@property (copy, atomic) NSString* jsonBaseURL;

@end

@implementation UNMJsonSessionData

- (instancetype) init {
	
	NSLog(@"IllegalStateException: UNMJsonSessionData.init()");
	
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

- (UNMAppToken*) fetchAppToken:(NSObject<UNMJsonFetcher>*)jsonFetcher
					withApiKey:(NSString*)apiKey
						 login:(NSString*)login
					  password:(NSString*)password
				  errorHandler:(void(^)(NSError*))onError {
	
	// NSLog(@"fetchAppToken... login:%@ password:%@", login, password);
	
	NSString* const url = [self.jsonBaseURL stringByAppendingString:@"session"];

	id const json = [jsonFetcher syncJsonPostURL:url
									  withParams:@{ @"login"     : login,
													@"password" : password,
													@"apiKey": apiKey
													}
									 errorHandler:onError];
	
	// NSLog(@"fetchAppToken -> json: %@", json);
	
	if (!json) return nil; // Error is already handled by callback
	
	NSError* error = nil;
	
	id appToken = [MTLJSONAdapter modelOfClass:[UNMAppToken class] fromJSONDictionary:json error:&error];
	
	if (error) {
		
		NSLog(@"Error: %@", error);
		
		if (onError) onError(error);
		
		return nil;
	}
	
	if (!appToken) {
		
		NSLog(@"Error: appToken == nill");
		
		if (onError) onError([NSError errorWithDomain:@"UNMJsonSessionData" code:2 userInfo:nil]);
		
		return nil;
	}
	
	return appToken;
}

@end
