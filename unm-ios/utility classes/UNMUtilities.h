//
//  UNMUtilities.h
//  unm-ios
//
//  Created by UnivMobile on 1/26/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "UNMMapItemBasic.h"
#import "UNMMapViewController.h"

@interface UNMUtilities : NSObject
+ (AFHTTPRequestOperationManager *)manager;
+ (void)setManager:(AFHTTPRequestOperationManager *)newManager;
+ (AFHTTPRequestOperationManager *)mapManager;
+ (void)setMapManager:(AFHTTPRequestOperationManager *)newMapManager;
+ (void)setCenterControllerWithViewControllerIdentifier:(NSString *)vcIdentifier;
+ (void)setCenterControllerWithNavControllerIdentifier:(NSString *)navIdentifier;
+ (void)setCenterControllerWithViewControllerIdentifier:(NSString *)vcIdentifier andCallback:(void (^)())callback;
+ (void)setCenterControllerToImageMapWithPath:(NSString *)Path;
+ (void)setCenterControllerToMapIgnoreCurrent;
+ (void)setCenterControllerToMapWithSingleItem:(UNMMapItemBasic *)item andTabSelected:(UNMMapTabs)tab;
+ (void)setCenterControllerToMapWithTabSelected:(UNMMapTabs)tab;
+ (void)setCenterControllerToMapWithCategoryID:(NSNumber *)catID;
+ (void)fetchFromApiWithPath:(NSString *)path success:(void(^)(AFHTTPRequestOperation*,id))success failure:(void(^)(AFHTTPRequestOperation*,NSError*))failure;
+ (void)fetchFromApiAuthenticatedWithPath:(NSString *)path success:(void(^)(AFHTTPRequestOperation*,id))success failure:(void(^)(AFHTTPRequestOperation*,NSError*))failure;
+ (void)fetchFromApiForMapWithPath:(NSString *)path success:(void(^)(AFHTTPRequestOperation*,id))success failure:(void(^)(AFHTTPRequestOperation*,NSError*))failure;
+ (void)postToApiWithPath:(NSString *)path andParams:(NSDictionary *)params success:(void(^)(AFHTTPRequestOperation*,id))success failure:(void(^)(AFHTTPRequestOperation*,NSError*))failure;
+ (void)fetchFromOldApiWithPath:(NSString *)path success:(void(^)(AFHTTPRequestOperation*,id))success failure:(void(^)(AFHTTPRequestOperation*,NSError*))failure;
+ (void)setCenterControllerWithNavController:(UINavigationController *)destNav;
+ (void)showErrorWithTitle:(NSString *)title andMessage:(NSString *)message andDelegate:(id<UIAlertViewDelegate>)delegate;
+ (NSDictionary *)parseQueryString:(NSString *)query;
+ (UIView *)initActivityIndicatorContainerWithParentView:(UIView *)view aboveSubview:(UIView *)subview;
+ (void)setCenterControllerToWebViewWithURL:(NSString *)urlStr andContent:(NSString *)content;
+ (void)fetchFromBackendWithPath:(NSString *)path success:(void(^)(AFHTTPRequestOperation*,id))success failure:(void(^)(AFHTTPRequestOperation*,NSError*))failure;
+ (void)deleteToApiWithPath:(NSString *)path andParams:(NSDictionary *)params success:(void(^)(AFHTTPRequestOperation*,id))success failure:(void(^)(AFHTTPRequestOperation*,NSError*))failure;
+ (void)postToApiNoAuthWithPath:(NSString *)path andParams:(NSDictionary *)params success:(void(^)(AFHTTPRequestOperation*,id))success failure:(void(^)(AFHTTPRequestOperation*,NSError*))failure;
@end
