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
@property (strong, nonatomic) NSString *feedName;
+ (void)fetchNewsWithPath:(NSString *)path andSuccess:(void(^)(NSArray *newsItems,NSString *nextPath))callback failure:(void(^)())failure;
+ (void)fetch4NewsWithSuccess:(void(^)(NSArray *newsItems))callback failure:(void(^)())failure;
@end
