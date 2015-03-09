//
//  UNMNewsBasic.h
//  unm-ios
//
//  Created by UnivMobile on 2/18/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNMNewsBasic : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *thumbURLStr;
@property (strong, nonatomic) NSString *articeURLStr;
@property (strong, nonatomic) NSNumber *ID;
+ (void)fetchNewsWithSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure;
+ (void)fetchNewestNewsWithSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure;
@end
