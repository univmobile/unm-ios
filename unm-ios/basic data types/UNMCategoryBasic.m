//
//  UNMCategoryBasic.m
//  unm-ios
//
//  Created by UnivMobile on 1/20/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMCategoryBasic.h"
#import "UNMUtilities.h"
#import "UNMConstants.h"
#import "UNMUniversityBasic.h"

@implementation UNMCategoryBasic
- (instancetype)initWithName:(NSString *)name andDescription:(NSString *)description andActive:(BOOL)active andID:(NSNumber *)ID andActiveIcon:(NSString *)activeIcon andMakerIcon:(NSString *)marker
{
    self = [super init];
    if (self) {
        _name = name;
        _desc = description;
        _active = active;
        _categoryID = ID;
        _activeIconName = activeIcon;
        _markerIconName = marker;
    }
    return self;
}

+ (void)fetchCategoriesWithCategoryID:(NSNumber *)categoryId andSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure {
    NSMutableArray *array = [NSMutableArray new];
    NSNumber *ID = [[UNMUniversityBasic getSavedObject]univId];
    if (ID && [ID class] != [NSNull class]) {
        NSString *path = [@"categories" stringByAppendingString:[NSString stringWithFormat:@"/%d/children",[categoryId intValue]]];
        [self fetchCategoriesWithPath:path array:array limit:nil success:callback failure:failure];
    } else {
        failure();
    }
}

+ (void)fetchCategoriesWithPath:(NSString *)path array:(NSMutableArray *)array limit:(NSNumber *)limit success:(void(^)(NSArray *))callback failure:(void(^)())failure {
    [UNMUtilities fetchFromApiWithPath:path success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *embedded = responseObject[@"_embedded"];
        NSDictionary *links = responseObject[@"_links"];
        if (embedded != nil) {
            NSArray *objects = embedded[@"categories"];
            if (objects != nil) {
                for (NSDictionary *object in objects) {
                    NSString *name = object[@"name"];
                    NSString *description = object[@"description"];
                    NSString *activeIconImage = object[@"activeIconUrl"];
                    NSString *markerIconImage = object[@"markerIconUrl"];
                    BOOL active = [[object objectForKey:@"active"] boolValue];
                    NSNumber *ID = object[@"id"];
                    if (active && [name class] != [NSNull class] && [description class] != [NSNull class]) {
                        UNMCategoryBasic *item = [[UNMCategoryBasic alloc]initWithName:name andDescription:description andActive:active andID:ID andActiveIcon:activeIconImage andMakerIcon:markerIconImage];
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
                    [self fetchCategoriesWithPath:nextUrlPath array:array limit:limit success:callback failure:failure];
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
           [UNMUtilities showErrorWithTitle:@"Impossible d'obtenir les catégories" andMessage:[error localizedDescription] andDelegate:nil];
           failure();
       }
   }];
}
@end
