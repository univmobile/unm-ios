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
#import "UNMAppLayer.h"

@interface UNMJsonPoisData : NSObject

- (instancetype) initWithAppLayer:(UNMAppLayer*)appLayer jsonBaseURL:(NSString*)jsonBaseURL;

- (UNMPoisData*) fetchPoisData:(NSObject<UNMJsonFetcher>*)jsonFetcher
					withErrorHandler:(void(^)(NSError*))onError;

@end
