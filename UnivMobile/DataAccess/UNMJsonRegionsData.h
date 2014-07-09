//
//  UNMJsonRegionsData.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 09/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

@import Foundation;
#import "UNMRegionsData.h"
#import "UNMJsonFetcher.h"

@interface UNMJsonRegionsData : NSObject

+ (UNMRegionsData*) fetchRegionsData:(NSObject<UNMJsonFetcher>*)jsonFetcher
					withErrorHandler:(void(^)(NSError*))onError;

@end
