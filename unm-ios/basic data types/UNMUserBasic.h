//
//  UNMUserBasic.h
//  unm-ios
//
//  Created by UnivMobile on 1/30/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UNMBasicDataSaving.h"

@interface UNMUserBasic : UNMBasicDataSaving<NSCoding>
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSNumber *univID;
@property (nonatomic) NSNumber *ID;
- (instancetype)initWithUsername:(NSString *)username andID:(NSNumber *)ID andDisplayName:(NSString *)displayName andUnivID:(NSNumber *)univID;
- (void)saveToUserDefaults;
+ (UNMUserBasic *)getSavedObject;
+ (void)fetchUserWithID:(NSNumber *)ID success:(void(^)(UNMUserBasic *))callback failure:(void(^)())failure;
@end
