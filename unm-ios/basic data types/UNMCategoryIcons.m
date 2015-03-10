//
//  UNMCategoryIcons.m
//  unm-ios
//
//  Created by UnivMobile on 24/02/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMCategoryIcons.h"
#import "UNMUtilities.h"
#import "UNMConstants.h"
#import <AFNetworking/UIImageView+AFNetworking.h>


@implementation UNMCategoryIcons
static NSCache *requests;

- (instancetype)initWithActiveImage:(UIImage *)image andMarkerImage:(UIImage *)markImage {
    self = [super init];
    if (self) {
        _activeImage = image;
        _markerImage = markImage;
        if (!requests) {
            requests = [NSCache new];
        }
    }
    return self;
}

- (instancetype)initWithActiveReq:(NSURLRequest *)image andMarkerReq:(NSURLRequest *)markImage {
    self = [super init];
    if (self) {
        _activeReq = image;
        _markerReq = markImage;
        if (!requests) {
            requests = [NSCache new];
        }
    }
    return self;
}

+ (void) getCategoryImageWithID:(NSNumber *)ID success:(void(^)(UNMCategoryIcons *))success {
    [self getCategoryImageWithID:ID success:success failure:nil];
}

+ (void) getCategoryImageWithCategoryProtocolItem:(id<UNMCategoryIconProtocol>)item success:(void(^)(UNMCategoryIcons *))success {
    [self getCategoryImageWithCategoryProtocolItem:item success:success failure:nil];
}

+ (void) getCategoryImageWithCategoryProtocolItem:(id<UNMCategoryIconProtocol>)item success:(void(^)(UNMCategoryIcons *))success failure:(void(^)())failure {
    UNMCategoryIcons *icons = [requests objectForKey:[item categoryID]];
    if (!icons) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *activeName = [item activeIconName];
            NSString *markerName = [item markerIconName];
            [self fetchImagesWithActiveName:activeName andMarkerName:markerName categoryID:[item categoryID] success:success failure:failure];
        });
    } else {
        [self getCachedIconsWithCategoryIcon:icons success:success failure:^{
            [requests removeObjectForKey:[item categoryID]];
            [self getCategoryImageWithCategoryProtocolItem:item success:success failure:failure];
        }];
    }
}

+ (void) getCachedIconsWithCategoryIcon:(UNMCategoryIcons *)icon success:(void(^)(UNMCategoryIcons *))success failure:(void(^)())failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *activeImage = [[UIImageView sharedImageCache] cachedImageForRequest:icon.activeReq];
        UIImage *markerImage = [[UIImageView sharedImageCache] cachedImageForRequest:icon.markerReq];
        if (activeImage && markerImage) {
            UNMCategoryIcons *icon = [[UNMCategoryIcons alloc]initWithActiveImage:activeImage andMarkerImage:markerImage];
            dispatch_async(dispatch_get_main_queue(), ^{
                success(icon);
            });
        } else {
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure();
                });
            }
        }
    });
}

+ (void) getCategoryImageWithID:(NSNumber *)ID success:(void(^)(UNMCategoryIcons *))success failure:(void(^)())failure {
    UNMCategoryIcons *icons = [requests objectForKey:ID];
    if (!icons) {
        [UNMUtilities fetchFromApiWithPath:[NSString stringWithFormat:@"categories/%d",[ID intValue]] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *activeName = responseObject[@"activeIconUrl"];
                NSString *markerName = responseObject[@"markerIconUrl"];
                [self fetchImagesWithActiveName:activeName andMarkerName:markerName categoryID:ID success:success failure:failure];
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure();
                });
            }
        }];
    } else {
        [self getCachedIconsWithCategoryIcon:icons success:success failure:^{
            [requests removeObjectForKey:ID];
            [self getCategoryImageWithID:ID success:success failure:failure];
        }];
    }
}

+ (void)fetchImagesWithActiveName:(NSString *)activeName andMarkerName:(NSString *)markerName categoryID:(NSNumber *)ID success:(void(^)(UNMCategoryIcons *))success failure:(void(^)())failure {
    if ([activeName class] != [NSNull class] && [markerName class] != [NSNull class] && activeName.length > 0 && markerName.length > 0) {
        NSURLRequest *activeReq = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@files/categoriesicons/%@",kBaseApiURLStr,[activeName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0f];
        NSURLRequest *markerReq = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@files/categoriesicons/%@",kBaseApiURLStr,[markerName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0f];
        UNMCategoryIcons *iconReq = [[UNMCategoryIcons alloc]initWithActiveReq:activeReq andMarkerReq:markerReq];
        [requests setObject:iconReq forKey:ID];
        
        __block UIImage *activeImage = [[UIImageView sharedImageCache] cachedImageForRequest:activeReq];
        __block UIImage *markerImage = [[UIImageView sharedImageCache] cachedImageForRequest:markerReq];
        
        if (activeImage && markerImage) {
            UNMCategoryIcons *icon = [[UNMCategoryIcons alloc]initWithActiveImage:activeImage andMarkerImage:markerImage];
            dispatch_async(dispatch_get_main_queue(), ^{
                success(icon);
            });
        } else {
            
            NSMutableArray *operations = [NSMutableArray array];
            
            AFHTTPRequestOperation *operation1 = [[AFHTTPRequestOperation alloc] initWithRequest:activeReq];
            operation1.responseSerializer = [AFImageResponseSerializer new];
            [operations addObject:operation1];
            AFHTTPRequestOperation *operation2 = [[AFHTTPRequestOperation alloc] initWithRequest:markerReq];
            operation2.responseSerializer = [AFImageResponseSerializer new];
            [operations addObject:operation2];
            NSArray *batchOperations = [AFURLConnectionOperation batchOfRequestOperations:operations
                                                                            progressBlock:NULL
                                                                          completionBlock:^(NSArray *operations) {
                                                                              dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                                  NSError *error;
                                                                                  for (AFHTTPRequestOperation *op in operations) {
                                                                                      if (op.isCancelled){
                                                                                          return ;
                                                                                      }
                                                                                      if (op.responseObject){
                                                                                          if (op == operation1) {
                                                                                              activeImage = op.responseObject;
                                                                                              [[UIImageView sharedImageCache] cacheImage:activeImage forRequest:activeReq];
                                                                                          } else if (op == operation2) {
                                                                                              markerImage = op.responseObject;
                                                                                              [[UIImageView sharedImageCache] cacheImage:markerImage forRequest:markerReq];
                                                                                          }
                                                                                      }
                                                                                      if (op.error){
                                                                                          error = op.error;
                                                                                          NSLog(@"image fetching error %@",[error localizedDescription]);
                                                                                      }
                                                                                  }
                                                                                  if (activeImage && markerImage) {
                                                                                      UNMCategoryIcons *icon = [[UNMCategoryIcons alloc]initWithActiveImage:activeImage andMarkerImage:markerImage];
                                                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                                                          success(icon);
                                                                                      });
                                                                                  } else {
                                                                                      if (failure) {
                                                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                                                              failure();
                                                                                          });
                                                                                      }
                                                                                  }
                                                                              });}];
            [[NSOperationQueue mainQueue] addOperations:batchOperations waitUntilFinished:NO];
        }
    } else {
        if (failure) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure();
            });
        }
    }
}


@end
