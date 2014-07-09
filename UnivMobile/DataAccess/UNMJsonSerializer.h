//
//  UNMJsonSerializer.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 09/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNMJsonSerializer : NSObject

+ (id) jsonDeserialize:(NSData*)data withErrorHandler:(void(^)(NSError*))onError;

@end
