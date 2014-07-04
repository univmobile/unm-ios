//
//  UNMHomeCallback.h
//  UnivMobile
//
//  Created by David on 04/07/2014.
//  Copyright (c) 2014 David. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UNMHomeCallback <NSObject>

@property (copy, nonatomic) NSString* selectedRegionId;
@property (copy, nonatomic) NSString* selectedUniversityId;

- (void)goBackFromRegions;

@end
