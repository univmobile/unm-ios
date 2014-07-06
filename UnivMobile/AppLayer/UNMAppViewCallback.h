//
//  UNMAppViewCallback.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 06/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UNMAppViewCallback <NSObject>

@optional

- (void) callbackSetSelectedRegionIdInList:(NSString*)regionId;

- (void) callbackSetSelectedUniversityIdInList:(NSString*)universityId;

- (void) callbackGoBackFromRegions;

- (void) callbackShowUniversityList;

@end
