//
//  UNMMediaItemBasic.m
//  unm-ios
//
//  Created by UnivMobile on 2/23/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMMediaItemBasic.h"
#import "UNMUtilities.h"
#import "UNMUniversityBasic.h"
#import "UNMConstants.h"

@implementation UNMMediaItemBasic
- (instancetype)initWithID:(NSNumber *)ID andLabel:(NSString *)label andUrl:(NSString *)url {
    self = [super init];
    if (self) {
        _ID = ID;
        _label = label;
        _urlStr = url;
    }
    return self;
}

+ (void)fetchMediaItemsWithSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure {
    NSMutableArray *array = [NSMutableArray new];
    NSNumber *ID = [[UNMUniversityBasic getSavedObject]univId];
    if (ID && [ID class] != [NSNull class]) {
        NSString *path = [NSString stringWithFormat:@"links/search/findByUniversity?universityId=%d",[ID intValue]];
        [self fetchMediaItemsWithPath:path array:array limit:nil success:callback failure:failure];
    } else {
        failure();
    }
}

+ (void)fetchNewestMediaItemsWithSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure {
    NSMutableArray *array = [NSMutableArray new];
    NSNumber *ID = [[UNMUniversityBasic getSavedObject]univId];
    if (ID && [ID class] != [NSNull class]) {
        NSString *path = [NSString stringWithFormat:@"links/search/findByUniversity?universityId=%d",[ID intValue]];
        [self fetchMediaItemsWithPath:path array:array limit:[NSNumber numberWithInt:4] success:callback failure:failure];
    } else {
        failure();
    }
}

+ (void)fetchMediaItemsWithPath:(NSString *)path array:(NSMutableArray *)array limit:(NSNumber *)limit success:(void(^)(NSArray *))callback failure:(void(^)())failure {
    [UNMUtilities fetchFromApiWithPath:path success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *embedded = responseObject[@"_embedded"];
        NSDictionary *links = responseObject[@"_links"];
        if (embedded != nil) {
            NSArray *objects = embedded[@"links"];
            if (objects != nil) {
                for (NSDictionary *object in objects) {
                    NSNumber *ID = object[@"id"];
                    NSString *label = object[@"label"];
                    NSString *url = object[@"url"];
                    if (ID && label && url && [ID class] != [NSNull class] && [label class] != [NSNull class] && [url class] != [NSNull class]) {
                        UNMMediaItemBasic *item = [[UNMMediaItemBasic alloc]initWithID:ID andLabel:label andUrl:url];
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
                    [self fetchMediaItemsWithPath:nextUrlPath array:array limit:limit success:callback failure:failure];
                } else {
                    callback(array);
                }
            } else {
                callback(array);
            }
        } else {
            callback(array);
        }
    }
   failure:^(AFHTTPRequestOperation *operation, NSError *error){
       if (!operation.isCancelled) {
           [UNMUtilities showErrorWithTitle:@"Impossible d'obtenir les éléments de menu" andMessage:[error localizedDescription] andDelegate:nil];
           failure();
       }
   }];
}
@end
