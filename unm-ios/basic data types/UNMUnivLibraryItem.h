//
//  UNMUnivLibraryItem.h
//  unm-ios
//
//  Created by UnivMobile on 2/23/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNMUnivLibraryItem : NSObject
@property (strong, nonatomic) NSNumber *ID;
@property (strong, nonatomic) NSNumber *poiID;
@property (strong, nonatomic) NSString *poiName;
@property (nonatomic) BOOL ruedesfacs;
- (instancetype)initWithID:(NSNumber *)ID andPoiID:(NSNumber *)poiID andPoiName:(NSString *)poiName andRuedesfacs:(BOOL)ruedesfacs;
+ (void)fetchLibraryItemsWithSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure;
+ (void)fetchNewestLibraryItemsWithSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure;
@end
