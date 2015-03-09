//
//  UNMCategoryBasic.h
//  unm-ios
//
//  Created by UnivMobile on 1/20/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UNMCategoryIconProtocol.h"

@interface UNMCategoryBasic : NSObject<UNMCategoryIconProtocol>
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *activeIconName;
@property (strong, nonatomic) NSString *markerIconName;
@property (strong, nonatomic) NSNumber *categoryID;
@property BOOL active;
- (instancetype)initWithName:(NSString *)name andDescription:(NSString *)description andActive:(BOOL)active andID:(NSNumber *)ID andActiveIcon:(NSString *)activeIcon andMakerIcon:(NSString *)marker;
+ (void)fetchCategoriesWithCategoryID:(NSNumber *)categoryId andSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure;
@end
