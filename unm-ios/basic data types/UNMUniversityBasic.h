//
//  UNMUniversityBasic.h
//  unm-ios
//
//  Created by UnivMobile on 1/15/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//
#import "UNMBasicDataSaving.h"
#import <UIKit/UIKit.h>

@interface UNMUniversityBasic : UNMBasicDataSaving<NSCoding>
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *univId;
@property (strong, nonatomic) NSString *logoUrl;
@property (strong, nonatomic) NSString *shibbolethUrl;
@property (strong, nonatomic) NSString *regionUrl;
@property (nonatomic) CGPoint center;
- (instancetype)initWithTitle:(NSString *)title andId:(NSNumber *)Id andLogoUrl:(NSString *)logoUrl andShibbolethUrl:(NSString *)shibboleth andRegionUrl:(NSString *)regionUrl andCenter:(CGPoint)center;
- (void)saveToUserDefaults;
+ (UNMUniversityBasic *)getSavedObject;
+ (void)fetchUniversitiesWithSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure;
+ (void)fetchUniversitiesWithPath:(NSString *)path andSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure;
@end
