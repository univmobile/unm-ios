//
//  UNMJsonCommentsData.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 01/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UNMCommentsData.h"
#import "UNMPoiData.h"
#import "UNMJsonFetcher.h"

@interface UNMJsonCommentsData : NSObject

- (UNMCommentsData*) fetchCommentsData:(NSObject<UNMJsonFetcher>*)jsonFetcher
						   withPoi:(const UNMPoiData*)poi
			  errorHandler:(void(^)(NSError*))onError;

@end
