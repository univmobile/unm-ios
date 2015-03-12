//
//  UNMNewsBasic.m
//  unm-ios
//
//  Created by UnivMobile on 2/18/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMNewsBasic.h"
#import "UNMUtilities.h"
#import "UNMConstants.h"
#import "UNMUniversityBasic.h"
#import "NSDate+notificationDate.h"

@implementation UNMNewsBasic
- (instancetype)initWithID:(NSNumber *)ID andName:(NSString *)name andDescription:(NSString *)desc andDate:(NSDate *)date andThumbUrl:(NSString *)thumbUrl andArticleUrl:(NSString *)articleUrl {
    self = [super init];
    if (self) {
        _ID = ID;
        _name = name;
        _desc = desc;
        _date = date;
        _thumbURLStr = thumbUrl;
        _articeURLStr = articleUrl;
    }
    return self;
}

+ (void)fetchNewsWithPath:(NSString *)path andSuccess:(void(^)(NSArray *newsItems,NSString *nextPath))callback failure:(void(^)())failure {
    NSMutableArray *array = [NSMutableArray new];
    if (!path) {
        NSNumber *univId = [[UNMUniversityBasic getSavedObject] univId];
        path = [NSString stringWithFormat:@"%@%d",@"news/search/findNewsForUniversity?universityId=",[univId intValue]];
    }
    [self fetchNewsWithPath:path array:array success:callback failure:failure];
}

+ (void)fetch4NewsWithSuccess:(void(^)(NSArray *newsItems))callback failure:(void(^)())failure {
    NSMutableArray *array = [NSMutableArray new];
    NSNumber *univId = [[UNMUniversityBasic getSavedObject] univId];
    NSString *path = [NSString stringWithFormat:@"%@%d",@"news/search/findNewsForUniversity?universityId=",[univId intValue]];
    [self fetchNewsWithPath:path array:array limit:[NSNumber numberWithInt:4] success:callback failure:failure];
}

+ (void)fetchNewsWithPath:(NSString *)path array:(NSMutableArray *)array limit:(NSNumber *)limit success:(void(^)(NSArray *))callback failure:(void(^)())failure {
    [UNMUtilities fetchFromApiWithPath:path success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *embedded = responseObject[@"_embedded"];
        NSDictionary *links = responseObject[@"_links"];
        if (embedded != nil) {
            [self parseDataFromDictionary:embedded toMutableArray:array];
            NSString *nextPath = [self parseNextPathWithDictionary:links];
            if (nextPath) {
                [self fetchNewsWithPath:nextPath array:array limit:limit success:callback failure:failure];
            } else {
                callback(array);
            }
        } else {
            callback(array);
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error){
       if (!operation.isCancelled) {
           [UNMUtilities showErrorWithTitle:@"Impossible d'obtenir les news" andMessage:[error localizedDescription] andDelegate:nil];
           failure();
       }
    }];
}

+ (void)fetchNewsWithPath:(NSString *)path array:(NSMutableArray *)array success:(void(^)(NSArray *newsItems,NSString *nextPath))callback failure:(void(^)())failure {
    [UNMUtilities fetchFromApiWithPath:path success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *embedded = responseObject[@"_embedded"];
        NSDictionary *links = responseObject[@"_links"];
        if (embedded != nil) {
            [self parseDataFromDictionary:embedded toMutableArray:array];
            NSString *nextPath = [self parseNextPathWithDictionary:links];
            callback(array,nextPath);
        } else {
            callback(array, nil);
        }
    }
   failure:^(AFHTTPRequestOperation *operation, NSError *error){
       if (!operation.isCancelled) {
           [UNMUtilities showErrorWithTitle:@"Impossible d'obtenir les news" andMessage:[error localizedDescription] andDelegate:nil];
           failure();
       }
   }];
}

+ (void)parseDataFromDictionary:(NSDictionary *)dictionary toMutableArray:(NSMutableArray *)array {
    NSArray *objects = dictionary[@"news"];
    if (objects != nil) {
        for (NSDictionary *object in objects) {
            NSNumber *ID = object[@"id"];
            NSString *name = object[@"title"];
            NSString *desc = object[@"description"];
            NSDate *date = [NSDate getDateFromISOString:object[@"publishedDate"]];
            NSString *imageUrl = object[@"imageUrl"];
            NSString *articleUrl = object[@"link"];
            if (ID != nil && name != nil && desc != nil && date != nil && imageUrl != nil && articleUrl != nil && [ID class] != [NSNull class] && [name class] != [NSNull class] && [desc class] != [NSNull class] && [date class] != [NSNull class] && [articleUrl class] != [NSNull class]) {
                UNMNewsBasic *newsItem = [[UNMNewsBasic alloc]initWithID:ID andName:name andDescription:desc andDate:date andThumbUrl:imageUrl andArticleUrl:articleUrl];
                if (array != nil) {
                    [array addObject:newsItem];
                }
            }
        }
    }
}

+ (NSString *)parseNextPathWithDictionary:(NSDictionary *)links {
    if (links != nil) {
        NSString *nextUrlPath = links[@"next"][@"href"];
        if (nextUrlPath != nil) {
            nextUrlPath = [nextUrlPath stringByReplacingOccurrencesOfString:kBaseApiURLStr withString:@""];
            nextUrlPath = [nextUrlPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            return nextUrlPath;
        }
    }
    return nil;
}
@end
