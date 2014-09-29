//
//  UNMJsonSessionData.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 29/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UNMJsonFetcher.h"
#import "UNMAppToken.h"

@interface UNMJsonSessionData : NSObject

- (instancetype) initWithJSONBaseURL:(NSString*)jsonBaseURL;

- (UNMAppToken*) fetchAppToken:(NSObject<UNMJsonFetcher>*)jsonFetcher
					withApiKey:(NSString*)apiKey
						 login:(NSString*)login
					  password:(NSString*)password
				  errorHandler:(void(^)(NSError*))onError;

@end
