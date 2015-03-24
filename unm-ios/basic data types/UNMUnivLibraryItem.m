//
//  UNMUnivLibraryItem.m
//  unm-ios
//
//  Created by UnivMobile on 2/23/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMUnivLibraryItem.h"
#import "UNMConstants.h"
#import "UNMUniversityBasic.h"
#import "UNMUtilities.h"

@implementation UNMUnivLibraryItem

- (instancetype)initWithID:(NSNumber *)ID andPoiID:(NSNumber *)poiID andPoiName:(NSString *)poiName andRuedesfacs:(BOOL)ruedesfacs {
    self = [super init];
    if (self) {
        _ID = ID;
        _poiID = poiID;
        _poiName = poiName;
        _ruedesfacs = ruedesfacs;
    }
    return self;
}

+ (void)fetchLibraryItemsWithSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure {
    NSMutableArray *array = [NSMutableArray new];
    NSNumber *ID = [[UNMUniversityBasic getSavedObject]univId];
    if (ID && [ID class] != [NSNull class]) {
        NSString *path = [NSString stringWithFormat:@"universityLibraries/search/findByUniversity?universityId=%d",[ID intValue]];
        [self fetchLibraryItemsWithPath:path array:array limit:nil success:callback failure:failure];
    } else {
        failure();
    }
}

+ (void)fetchNewestLibraryItemsWithSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure {
    NSMutableArray *array = [NSMutableArray new];
    NSNumber *ID = [[UNMUniversityBasic getSavedObject]univId];
    if (ID && [ID class] != [NSNull class]) {
        NSString *path = [NSString stringWithFormat:@"universityLibraries/search/findByUniversity?universityId=%d",[ID intValue]];
        [self fetchLibraryItemsWithPath:path array:array limit:[NSNumber numberWithInt:4] success:callback failure:failure];
    } else {
        failure();
    }
}

+ (void)fetchLibraryItemsWithPath:(NSString *)path array:(NSMutableArray *)array limit:(NSNumber *)limit success:(void(^)(NSArray *))callback failure:(void(^)())failure {
    [UNMUtilities fetchFromApiWithPath:path success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *embedded = responseObject[@"_embedded"];
        NSDictionary *links = responseObject[@"_links"];
        if (embedded != nil) {
            NSArray *objects = embedded[@"universityLibraries"];
            if (objects != nil) {
                for (NSDictionary *object in objects) {
                    NSNumber *ID = object[@"id"];
                    NSNumber *poiID = object[@"poiId"];
                    NSString *poiName = object[@"poiName"];
                    BOOL ruedesfacs = [object[@"iconRuedesfacs"] boolValue];
                    if (ID && poiID && poiName && [ID class] != [NSNull class] && [poiID class] != [NSNull class] && [poiName class] != [NSNull class]) {
                        UNMUnivLibraryItem *item = [[UNMUnivLibraryItem alloc]initWithID:ID andPoiID:poiID andPoiName:poiName andRuedesfacs:ruedesfacs];
                        if (array != nil) {
                            if (!limit || [array count] < [limit intValue]) {
                                [array addObject:item];
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
                    [self fetchLibraryItemsWithPath:nextUrlPath array:array limit:limit success:callback failure:failure];
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
           [UNMUtilities showErrorWithTitle:@"Impossible d'obtenir les bibliothèques" andMessage:[error localizedDescription] andDelegate:nil];
           failure();
       }
   }];
}
@end
