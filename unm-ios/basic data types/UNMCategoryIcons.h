//
//  UNMCategoryIcons.h
//  unm-ios
//
//  Created by UnivMobile on 24/02/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNMMapItemBasic.h"

@interface UNMCategoryIcons : NSObject
@property (strong, nonatomic) UIImage *activeImage;
@property (strong, nonatomic) UIImage *markerImage;
@property (strong, nonatomic) NSURLRequest *activeReq;
@property (strong, nonatomic) NSURLRequest *inactiveReq;
@property (strong, nonatomic) NSURLRequest *markerReq;
- (instancetype)initWithActiveImage:(UIImage *)image andMarkerImage:(UIImage *)markImage;
- (instancetype)initWithActiveReq:(NSURLRequest *)image andMarkerReq:(NSURLRequest *)markImage;
+ (void) getCategoryImageWithID:(NSNumber *)ID success:(void(^)(UNMCategoryIcons *))success;
+ (void) getCategoryImageWithID:(NSNumber *)ID success:(void(^)(UNMCategoryIcons *))success failure:(void(^)())failure;
+ (void) getCategoryImageWithCategoryProtocolItem:(id<UNMCategoryIconProtocol>)item success:(void(^)(UNMCategoryIcons *))success;
+ (void) getCategoryImageWithCategoryProtocolItem:(id<UNMCategoryIconProtocol>)item success:(void(^)(UNMCategoryIcons *))success failure:(void(^)())failure;
@end
