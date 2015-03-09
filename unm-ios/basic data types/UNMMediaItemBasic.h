//
//  UNMMediaItemBasic.h
//  unm-ios
//
//  Created by UnivMobile on 2/23/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNMMediaItemBasic : NSObject
@property (strong, nonatomic) NSNumber *ID;
@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) NSString *urlStr;
+ (void)fetchMediaItemsWithSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure;
+ (void)fetchNewestMediaItemsWithSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure;
@end
