//
//  UNMJsonFetcher.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 09/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UNMJsonFetcher <NSObject>

@required

- (id) syncJsonGetURL:(NSString*)path
	 withErrorHandler:(void(^)(NSError*))onError;

- (id) syncJsonPostURL:(NSString*)path
			withParams:(NSDictionary*)params
		  errorHandler:(void(^)(NSError*))onError;

@end
