//
//  UNMJsonPoisData.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 01/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UNMPoisData.h"
#import "UNMJsonFetcher.h"

@interface UNMJsonPoisData : NSObject

- (instancetype) initWithJSONBaseURL:(NSString*)jsonBaseURL;

- (UNMPoisData*) fetchPoisData:(NSObject<UNMJsonFetcher>*)jsonFetcher
					withErrorHandler:(void(^)(NSError*))onError;

@end
