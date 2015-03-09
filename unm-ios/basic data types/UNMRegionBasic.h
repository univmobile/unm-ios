//
//  UNMRegionBasic.h
//  unm-ios
//
//  Created by UnivMobile on 1/15/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UNMBasicDataSaving.h"

@interface UNMRegionBasic : UNMBasicDataSaving<NSCoding>
@property NSNumber *ID;
@property NSString *title;
@property NSString *label;
@property NSString *universitiesURL;
- (instancetype)initWithTitle:(NSString *)title andLabel:(NSString *)label andUniversitiesURL:(NSString *)url andID:(NSNumber *)ID;
- (void)saveToUserDefaults;
+ (UNMRegionBasic *)getSavedObject;
+ (void)fetchRegionWithPath:(NSString *)path success:(void(^)(UNMRegionBasic *))callback failure:(void(^)())failure;
@end
