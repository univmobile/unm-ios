//
//  UNMNotificationBasic.h
//  unm-ios
//
//  Created by UnivMobile on 2/19/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNMNotificationBasic : NSObject
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSNumber *ID;
@property (strong, nonatomic) NSDate *date;
+ (void)fetchNotificationsWithSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure;
- (void)postAsRead;
+ (void)fetchMonthOldNotificationsWithSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure;
@end
