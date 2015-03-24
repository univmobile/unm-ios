//
//  UNMBookmarkBasic.m
//  unm-ios
//
//  Created by UnivMobile on 23/02/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMBookmarkBasic.h"
#import "UNMUserBasic.h"
#import "UNMUtilities.h"
#import "UNMConstants.h"

@implementation UNMBookmarkBasic
- (instancetype)initWithID:(NSNumber *)ID andPoiUrl:(NSString *)poiUrl andPoiID:(NSNumber *)poiID andPoiName:(NSString *)poiName andTab:(UNMMapTabs)tab {
    self = [super init];
    if (self) {
        _ID = ID;
        _poiUrlStr = poiUrl;
        _poiId = poiID;
        _poiName = poiName;
        _tab = tab;
    }
    return self;
}

+ (void)fetchBookmarksWithSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure {
    NSMutableArray *array = [NSMutableArray new];
    NSNumber *ID = [[UNMUserBasic getSavedObject]ID];
    if (ID && [ID class] != [NSNull class]) {
        NSString *path = [NSString stringWithFormat:@"users/%d/bookmarks",[ID intValue]];
        [self fetchBookmarksWithPath:path array:array limit:nil success:callback failure:failure];
    } else {
        failure();
    }
}

+ (void)fetchNewestBookmarksWithSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure {
    NSMutableArray *array = [NSMutableArray new];
    NSNumber *ID = [[UNMUserBasic getSavedObject]ID];
    if (ID && [ID class] != [NSNull class]) {
        NSString *path = [NSString stringWithFormat:@"users/%d/bookmarks",[ID intValue]];
        [self fetchBookmarksWithPath:path array:array limit:[NSNumber numberWithInt:4] success:callback failure:failure];
    } else {
        failure();
    }
}

+ (void)fetchBookmarksWithPath:(NSString *)path array:(NSMutableArray *)array limit:(NSNumber *)limit success:(void(^)(NSArray *))callback failure:(void(^)())failure {
    [UNMUtilities fetchFromApiWithPath:path success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *embedded = responseObject[@"_embedded"];
        NSDictionary *links = responseObject[@"_links"];
        if (embedded != nil) {
            NSArray *objects = embedded[@"bookmarks"];
            if (objects != nil) {
                for (NSDictionary *object in objects) {
                    NSNumber *ID = object[@"id"];
                    NSString *poiUrl = object[@"_links"][@"poi"][@"href"];
                    NSNumber *poiID = object[@"poiId"];
                    NSString *poiName = object[@"poiName"];
                    NSNumber *poiTabCategory = object[@"rootCategoryId"];
                    UNMMapTabs tab;
                    switch ([poiTabCategory intValue]) {
                        case 1:
                            tab = MapTabLeft;
                            break;
                        case 2:
                            tab = MapTabRight;
                            break;
                        case 5:
                            tab = MapTabMiddle;
                            break;
                        default:
                            tab = MapTabNone;
                            break;
                    }
                    if (ID && poiUrl && poiID && poiName && [ID class] != [NSNull class] && [poiUrl class] != [NSNull class] && [poiID class] != [NSNull class] && [poiName class] != [NSNull class]) {
                        UNMBookmarkBasic *bookmark = [[UNMBookmarkBasic alloc] initWithID:ID andPoiUrl:poiUrl andPoiID:poiID andPoiName:poiName andTab:tab];
                        if (array != nil) {
                            if (!limit || [array count] < [limit intValue]) {
                                [array addObject:bookmark];
                            }
                            if ([array count] == [limit intValue]) {
                                callback(array);
                                return;
                            }
                        }
                    }
                }
            }
            if (links != nil) {
                NSString *nextUrlPath = links[@"next"][@"href"];
                if (nextUrlPath != nil) {
                    nextUrlPath = [nextUrlPath stringByReplacingOccurrencesOfString:kBaseApiURLStr withString:@""];
                    nextUrlPath = [nextUrlPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    [self fetchBookmarksWithPath:nextUrlPath array:array limit:limit  success:callback failure:failure];
                } else {
                    callback(array);
                    return;
                }
            } else {
                callback(array);
                return;
            }
        } else {
            callback(array);
            return;
        }
    }
   failure:^(AFHTTPRequestOperation *operation, NSError *error){
       if (!operation.isCancelled) {
           [UNMUtilities showErrorWithTitle:@"Impossible d'obtenir les bookmarks" andMessage:[error localizedDescription] andDelegate:nil];
           failure();
       }
   }];
}
@end
