//
//  UNMCategoryBasic.h
//  unm-ios
//
//  Created by UnivMobile on 1/20/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNMCategoryBasic : NSObject
@property NSString *name;
@property NSString *desc;
@property NSNumber *ID;
@property BOOL active;
- (instancetype)initWithName:(NSString *)name andDescription:(NSString *)description andActive:(BOOL)active andID:(NSNumber *)ID;
+ (void)fetchCategoriesWithCategoryID:(NSNumber *)categoryId andSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure;
@end
