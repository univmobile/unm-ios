//
//  UNMRestoMenuItem.m
//  unm-ios
//
//  Created by UnivMobile on 2/20/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMRestoMenuItem.h"
#import "UNMUtilities.h"
#import "NSDate+notificationDate.h"
#import "UNMConstants.h"

@implementation UNMRestoMenuItem
- (instancetype)initWithID:(NSNumber *)ID andDesc:(NSString *)desc andEffectiveDate:(NSDate *)date {
    self = [super init];
    if (self) {
        _ID = ID;
        _desc = desc;
        _effectiveDate = date;
    }
    return self;
}

+ (void)fetchRestoMenuItemsWithPOIID:(NSNumber *)ID andSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure {
    NSMutableArray *array = [NSMutableArray new];
    
    if (ID && [ID class] != [NSNull class]) {
            NSString *path = [NSString stringWithFormat:@"restoMenus/search/findRestoMenuForPoi\?poiId=%d",[ID intValue]];
        [self fetchRestoMenuItemsWithPath:path array:array success:callback failure:failure];
    }
}

+ (void)fetchRestoMenuItemsWithPath:(NSString *)path array:(NSMutableArray *)array success:(void(^)(NSArray *))callback failure:(void(^)())failure {
    [UNMUtilities fetchFromApiWithPath:path success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *embedded = responseObject[@"_embedded"];
        NSDictionary *links = responseObject[@"_links"];
        if (embedded != nil) {
            NSArray *objects = embedded[@"restoMenus"];
            if (objects != nil) {
                for (NSDictionary *object in objects) {
                    NSNumber *ID = object[@"id"];
                    NSString *desc = object[@"description"];
                    NSDate *date = [NSDate getDateFromISOString:object[@"effectiveDate"]];
                    if (ID != nil && desc != nil && date != nil && [ID class] != [NSNull class] && [desc class] != [NSNull class] && [date class] != [NSNull class]) {
                        UNMRestoMenuItem *item = [[UNMRestoMenuItem alloc]initWithID:ID andDesc:desc andEffectiveDate:date];
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
                    [self fetchRestoMenuItemsWithPath:nextUrlPath array:array success:callback failure:failure];
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
           [UNMUtilities showErrorWithTitle:@"Impossible d'obtenir le menu du restaurant" andMessage:[error localizedDescription] andDelegate:nil];
           failure();
       }
    }];
}
@end
