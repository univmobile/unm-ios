//
//  UNMAuthDataBasic.h
//  unm-ios
//
//  Created by UnivMobile on 1/30/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UNMBasicDataSaving.h"

@interface UNMAuthDataBasic : UNMBasicDataSaving<NSCoding>
@property (strong,nonatomic) NSString *accessToken;
- (instancetype)initWithAccessToken:(NSString *)accessToken;
- (void)saveToUserDefaults;
+ (UNMAuthDataBasic *)getSavedObject;
@end
