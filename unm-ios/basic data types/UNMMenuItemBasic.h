//
//  UNMMenuItemBasic.h
//  unm-ios
//
//  Created by UnivMobile on 2/20/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNMMenuItemBasic : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *ID;
@property (strong, nonatomic) NSString *grouping;
@property (strong, nonatomic) NSString *urlStr;
@property (strong, nonatomic) NSString *dataStr;
@property (strong, nonatomic) NSNumber *ordinal;
+ (void)fetchMenuItemsWithSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure;
@end
