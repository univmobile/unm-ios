//
//  UNMBookmarkBasic.h
//  unm-ios
//
//  Created by UnivMobile on 23/02/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UNMMapViewController.h"

@interface UNMBookmarkBasic : NSObject
@property (strong, nonatomic) NSNumber *ID;
@property (strong, nonatomic) NSNumber *poiId;
@property (strong, nonatomic) NSString *poiUrlStr;
@property (strong, nonatomic) NSString *poiName;
@property (nonatomic) UNMMapTabs tab;
- (instancetype)initWithID:(NSNumber *)ID andPoiUrl:(NSString *)poiUrl andPoiID:(NSNumber *)poiID andPoiName:(NSString *)poiName andTab:(UNMMapTabs)tab;
+ (void)fetchBookmarksWithSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure;
+ (void)fetchNewestBookmarksWithSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure;
@end
