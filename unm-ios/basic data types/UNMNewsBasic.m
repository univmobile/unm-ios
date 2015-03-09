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

+ (void)fetchNewsWithSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure {
    NSMutableArray *array = [NSMutableArray new];
    NSNumber *univId = [[UNMUniversityBasic getSavedObject] univId];
    NSString *path = [NSString stringWithFormat:@"%@%d",@"news/search/findNewsForUniversity?universityId=",[univId intValue]];
    [self fetchNewsWithPath:path array:array limit:nil success:callback failure:failure];
}

+ (void)fetchNewestNewsWithSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure {
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
            NSArray *objects = embedded[@"news"];
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
                            if (!limit || [array count] < [limit intValue]) {
                                [array addObject:newsItem];
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
                    [self fetchNewsWithPath:nextUrlPath array:array limit:limit success:callback failure:failure];
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
           [UNMUtilities showErrorWithTitle:@"Impossible d'obtenir les news" andMessage:[error localizedDescription] andDelegate:nil];
           failure();
       }
    }];
}

@end
