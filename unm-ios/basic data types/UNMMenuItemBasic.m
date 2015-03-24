//
//  UNMMenuItemBasic.m
//  unm-ios
//
//  Created by UnivMobile on 2/20/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMMenuItemBasic.h"
#import "UNMUtilities.h"
#import "UNMConstants.h"
#import "UNMUniversityBasic.h"

@implementation UNMMenuItemBasic
- (instancetype)initWithID:(NSNumber *)ID andName:(NSString *)name andGrouping:(NSString *)grouping andUrl:(NSString *)urlStr andData:(NSString *)dataStr andOrdinal:(NSNumber *)ordinal {
    self = [super init];
    if (self) {
        _ID = ID;
        _name = name;
        _grouping = grouping;
        _urlStr = urlStr;
        _dataStr = dataStr;
        _ordinal = ordinal;
    }
    return self;
}

+ (void)fetchMenuItemsWithSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure {
    NSMutableArray *array = [NSMutableArray new];
    NSNumber *ID = [[UNMUniversityBasic getSavedObject]univId];
    if (ID && [ID class] != [NSNull class]) {
        NSString *path = [NSString stringWithFormat:@"menues/search/findAllForUniversity\?universityId=%d",[ID intValue]];
        [self fetchMenuItemsWithPath:path array:array success:callback failure:failure];
    } else {
        failure();
    }
}

+ (void)fetchMenuItemsWithPath:(NSString *)path array:(NSMutableArray *)array success:(void(^)(NSArray *))callback failure:(void(^)())failure {
    [UNMUtilities fetchFromApiWithPath:path success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *embedded = responseObject[@"_embedded"];
        NSDictionary *links = responseObject[@"_links"];
        if (embedded != nil) {
            NSArray *objects = embedded[@"menu"];
            if (objects != nil) {
                for (NSDictionary *object in objects) {
                    NSNumber *ID = object[@"id"];
                    NSString *name = object[@"name"];
                    NSString *url = object[@"url"];
                    NSString *content = object[@"content"];
                    NSString *grouping = object[@"grouping"];
                    NSNumber *ordinal = object[@"ordinal"];
                    BOOL active = [[object objectForKey:@"active"] boolValue];
                    if (active && ID && name && url && content && grouping && ordinal && [ID class] != [NSNull class] && [name class] != [NSNull class] && [url class] != [NSNull class] && [content class] != [NSNull class] && [grouping class] != [NSNull class] && [ordinal class] != [NSNull class]) {
                        UNMMenuItemBasic *item = [[UNMMenuItemBasic alloc]initWithID:ID andName:name andGrouping:grouping andUrl:url andData:content andOrdinal:ordinal];
                        if (array != nil) {
                            [array addObject:item];
                        }
                    }
                }
            }
            if (links != nil) {
                NSString *nextUrlPath = links[@"next"][@"href"];
                if (nextUrlPath != nil) {
                    nextUrlPath = [nextUrlPath stringByReplacingOccurrencesOfString:kBaseApiURLStr withString:@""];
                    nextUrlPath = [nextUrlPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    [self fetchMenuItemsWithPath:nextUrlPath array:array success:callback failure:failure];
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
           [UNMUtilities showErrorWithTitle:@"Impossible d'obtenir les éléments de menu" andMessage:[error localizedDescription] andDelegate:nil];
           failure();
       }
    }];
}
@end
