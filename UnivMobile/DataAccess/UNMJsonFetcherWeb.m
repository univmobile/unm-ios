//
//  UNMJsonFetcherWeb.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 09/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMJsonFetcherWeb.h"
#import "UNMJsonSerializer.h"

@implementation UNMJsonFetcherWeb

- (id) syncFetchJsonAtURL:(NSString*)path withErrorHandler:(void(^)(NSError*))onError {
	
	NSURL* const url = [NSURL URLWithString:path];

	NSLog(@"syncFetchJsonAtURL(Web):%@...", url);
	
	NSError* error = nil;
	
	const NSDataReadingOptions options;
	
	NSData* const data = [NSData dataWithContentsOfURL:url options:options error:&error];
	
	if (error) {
		
		NSLog(@"Error: %@", error);
		
		if (onError) onError(error);
		
		return nil;
	}
	
	return [UNMJsonSerializer jsonDeserialize:data withErrorHandler:onError];
	
	/*
	 NSURLSessionConfiguration* const config = [NSURLSessionConfiguration defaultSessionConfiguration];
	 
	 NSURLSession* const session = [NSURLSession sessionWithConfiguration:config];
	 
	 //	RACSignal* const signal = [[RACSignal createSignal:^RACDisposable*(id<RACSubscriber> subscriber) {
	 
	 NSURLSessionDataTask* const dataTask = [session dataTaskWithURL:url
	 completionHandler:^(NSData* data,
	 NSURLResponse* response,
	 NSError* error) {
	 
	 if (error) {
	 NSLog(@"Error in JSON fetching: %@",error);
	 } else {
	 NSError* jsonError = nil;
	 id const json = [NSJSONSerialization
	 JSONObjectWithData:data
	 options:kNilOptions
	 error:&jsonError];
	 
	 if (jsonError) {
	 NSLog(@"Error in JSON parsing: %@",jsonError);
	 } else {
	 NSLog(@"json:%@", json);
	 }
	 //		  [subscriber sendNext:json];
	 //	  }
	 //  else {
	 //	  [subscriber sendError:jsonError];
	 // }
	 
	 }
	 
	 //	  [subscriber sendCompleted];
	 }];
	 
	 [dataTask resume];
	 
	 //        return [RACDisposable disposableWithBlock:^{
	 //          [dataTask cancel];
	 //    }];
	 
	 //    }] doError:^(NSError* error) {
	 
	 //      NSLog(@"Error in RACSignal: %@",error);
	 //}];
	 
	 //[dataTask cancel];
	 */
	
	//NSLog(@"json:%@", data);
	
	//return nil;
}

@end