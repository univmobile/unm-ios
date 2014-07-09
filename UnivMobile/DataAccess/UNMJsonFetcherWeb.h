//
//  UNMJsonFetcherWeb.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 09/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UNMJsonFetcher.h"

@interface UNMJsonFetcherWeb : NSObject <UNMJsonFetcher>

- (id) syncFetchJsonAtURL:(NSString*)path withErrorHandler:(void(^)(NSError*))onError;

@end
