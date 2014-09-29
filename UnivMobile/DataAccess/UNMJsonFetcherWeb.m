//
//  UNMJsonFetcherWeb.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 09/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMJsonFetcherWeb.h"
#import "UNMJsonSerializer.h"
#import "UNMUtils.h"

@interface UNMURLConnectionHandler : NSObject

@property (strong, atomic) NSURLRequest* request;

@property (strong, atomic) NSError* error;

@property (strong, atomic) NSData* data;

- (instancetype) initWithRequest:(NSURLRequest*)request;

- (NSError*) execute;

@end

@implementation UNMURLConnectionHandler

- (instancetype) initWithRequest:(NSURLRequest*)request {
	
	self = [super init];
	
	if (self) {
		
		self.request = request;
	}
	
	return self;
}

- (NSError*) execute {
	
	dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
	
	[NSURLConnection sendAsynchronousRequest:self.request
									   queue:[[NSOperationQueue alloc] init]
						   completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {
							   
							   if (error) {
								   
								   self.error = error;
								   
								   dispatch_semaphore_signal(semaphore);
								   
							   } else {
								   
								   NSHTTPURLResponse* const httpResponse = (NSHTTPURLResponse*)response;
								   
								   const long responseStatusCode = [httpResponse statusCode];
								   
								   if (responseStatusCode != 200) {
									
									   NSLog(@"UNMJsonFetcherWeb:HTTP Error %ld for request: %@", responseStatusCode, self.request);

									   self.error = [NSError errorWithDomain:@"UNMJsonFetcherWeb" code:3 userInfo:nil];
									   
									   dispatch_semaphore_signal(semaphore);
									   
									   // NSLog(@"Data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
									   
									   return;
								   }
								   
								   self.data = data;
								   
								   dispatch_semaphore_signal(semaphore);
							   }
						   }];

	const dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW,
                                            (int64_t)(self.request.timeoutInterval * NSEC_PER_SEC));
    
	
//	while (
	dispatch_semaphore_wait(semaphore, timeout);
	//) {
		
	//	NSDate* const now = [NSDate date];
		
		//NSLog(@"wait %@ -- %@", now, timeoutDate);
		
//		if ([now compare:timeoutDate] >= 0) {
			
//			break;
//		}
	//}

	
	if (!self.error && !self.data) {
		
		NSLog(@"UNMJsonFetcherWeb:Timeout for request: %@", self.request);
		
		self.error = [NSError errorWithDomain:@"UNMJsonFetcherWeb" code:8 userInfo:nil];
	}

	
	//dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
	
	//dispatch_release(semaphore);
	
	return self.error;
}

@end

@implementation UNMJsonFetcherWeb

- (id) syncJsonGetURL:(NSString*)path withErrorHandler:(void(^)(NSError*))onError {
	
	//NSURL* const url = [path hasPrefix: // @"http://univmobile.vswip.com/unm-backend-mock/"] //
	//					@"https://univmobile-dev.univ-paris1.fr/json/regions"] //
	//? [NSURL URLWithString:path] //
	//: [NSURL URLWithString:[ //@"http://univmobile.vswip.com/unm-backend-mock/listUniversities_"
	//						@"http://univmobile-dev.univ-paris1.fr/unm-backend-mock-0.0.2/listUniversities_"
	//										 stringByAppendingString:path]];

	NSURL* const url = [NSURL URLWithString:path];
	
	if (!url) {
		
		NSLog(@"Error: no URL");
		
		NSDictionary* const userInfo = @{
										 NSLocalizedDescriptionKey: NSLocalizedString(@"Le rapatriement des données a échoué.", nil),
										 NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"L’URL JSON est inconnue.", nil),
										 NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Contactez l’administrateur.", nil)
										 };
		
		if (onError) onError([NSError errorWithDomain:@"UnivMobile"
												 code:-10
											 userInfo:userInfo]);
		
		return nil;
	}
	
	NSURLRequest* const request=[NSURLRequest requestWithURL:url
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:10.0];
//	const NSDataReadingOptions options;
	
//	NSData* const data = //[NSData dataWithContentsOfURL:url options:options error:&error];
//	[NSURLSession send]
	
//	NSURLConnection* cxn = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	UNMURLConnectionHandler* handler = [[UNMURLConnectionHandler alloc] initWithRequest:request];
	
	NSError* const error = [handler execute];
	
	if (error) {
		
		NSLog(@"Error: %@", error);
		
		if (onError) onError(error);
		
		return nil;
	}
	
	return [UNMJsonSerializer jsonDeserialize:handler.data withErrorHandler:onError];
	
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

- (id) syncJsonPostURL:(NSString*)path withParams:(NSDictionary*)params errorHandler:(void(^)(NSError*))onError {
	
	NSURL* const url = [NSURL URLWithString:path];
	
	NSLog(@"syncJsonPostURL(Web):%@...", url);
	
	if (!url) {
		
		NSLog(@"Error: no URL");
		
		NSDictionary* const userInfo = @{
										 NSLocalizedDescriptionKey: NSLocalizedString(@"Le rapatriement des données a échoué.", nil),
										 NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"L’URL JSON est inconnue.", nil),
										 NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Contactez l’administrateur.", nil)
										 };
		
		if (onError) onError([NSError errorWithDomain:@"UnivMobile"
												 code:-10
											 userInfo:userInfo]);
		
		return nil;
	}
	
	//NSError* error = nil;
	
//	const NSDataReadingOptions options;
	
//	NSData* const data = [NSData dataWithContentsOfURL:url options:options error:&error];

	NSMutableString* const bodyData = [[NSMutableString alloc] init];
	//= @"key1=val1&key2=val2";
	
	__block BOOL start = true;
	
	[params enumerateKeysAndObjectsUsingBlock: ^(id name, id value, BOOL* stop) {

		if (start) {
			start = false;
		} else {
			[bodyData appendString:@"&"];
		}
		
		[bodyData appendString:name];
		[bodyData appendString:@"="];
		[bodyData appendString:[UNMUtils urlEncode:value]];
	}];

	// NSLog(@"bodyData: %@", bodyData);
	
	//NSData* const bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
	
	//NSString* const bodyLength = [NSString stringWithFormat:@"%d", [bodyData length]];
	
	NSMutableURLRequest* const request = [NSMutableURLRequest requestWithURL:url];
	
	//[request setURL:url];
	[request setTimeoutInterval:10.0];
	[request setHTTPMethod:@"POST"];
	//[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
	
	UNMURLConnectionHandler* handler = [[UNMURLConnectionHandler alloc] initWithRequest:request];
	
	NSError* const error = [handler execute];
	
	if (error) {
		
		NSLog(@"Error: %@", error);
		
		if (onError) onError(error);
		
		return nil;
	}
	
	NSLog(@"data: %@", [[NSString alloc] initWithData:handler.data encoding:NSUTF8StringEncoding]);
	
	if (handler.data.length == 0) return nil;
	
	return [UNMJsonSerializer jsonDeserialize:handler.data withErrorHandler:onError];
}

@end
