//
//  UNMNotificationBasic.m
//  unm-ios
//
//  Created by UnivMobile on 2/19/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMNotificationBasic.h"
#import "UNMUtilities.h"
#import "UNMUniversityBasic.h"
#import "NSDate+notificationDate.h"
#import "UNMConstants.h"
#import "NSString+URLEncoding.h"

@implementation UNMNotificationBasic
-(instancetype)initWithID:(NSNumber *)ID andContent:(NSString *)content andDate:(NSDate *)date {
    self = [super init];
    if (self) {
        _ID = ID;
        _content = content;
        _date = date;
    }
    return self;
}

- (void)postAsRead {
    UNMUserBasic *user = [UNMUserBasic getSavedObject];
    if (user) {
        NSString *path = [NSString stringWithFormat:@"notifications/lastRead?userId=%d&notificationId=%d",[user.ID intValue],[self.ID intValue]];
        [UNMUtilities fetchFromApiWithPath:path success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.date saveNotificationDateToUserDefaults];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [UNMUtilities showErrorWithTitle:@"Impossible de notifier le serveur de la dernière notification lue" andMessage:[error localizedDescription] andDelegate:nil];
        }];
    } else {
        [self.date saveNotificationDateToUserDefaults];
    }
}

+ (void)fetchNotificationsWithSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure {
    NSMutableArray *array = [NSMutableArray new];
    NSNumber *univId = [[UNMUniversityBasic getSavedObject] univId];
    NSDate *lastLoadDate = [NSDate getSavedNotificationDate];
    
    NSString *iso8601String = [lastLoadDate isoDateString];
    
    NSString *path;
    if (univId && [univId class] != [NSNull class]) {
        if (lastLoadDate == nil) {
            path = [NSString stringWithFormat:@"notifications/search/findNotificationsForUniversity\?universityId=%d",[univId intValue]];
            [self fetchNotificationsWithPath:path andDateString:nil array:array success:callback failure:failure];
        } else {
            path = [NSString stringWithFormat:@"notifications/search/findNotificationsForUniversitySince\?universityId=%d&since=%@",[univId intValue],[iso8601String urlEncodeUsingEncoding:NSUTF8StringEncoding]];
            [self fetchNotificationsWithPath:path andDateString:[iso8601String urlEncodeUsingEncoding:NSUTF8StringEncoding] array:array success:callback failure:failure];
        }
        
    }
}

+ (void)fetchMonthOldNotificationsWithSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure {
    NSMutableArray *array = [NSMutableArray new];
    NSNumber *univId = [[UNMUniversityBasic getSavedObject] univId];
    NSDate *today = [NSDate date];

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:-1];
    NSDate *oneMonthBack = [gregorian dateByAddingComponents:offsetComponents toDate:today options:0];
    
    NSString *iso8601String = [oneMonthBack isoDateString];
    
    NSString *path;
    if (univId && [univId class] != [NSNull class]) {
        if (oneMonthBack == nil) {
            path = [NSString stringWithFormat:@"notifications/search/findNotificationsForUniversity\?universityId=%d",[univId intValue]];
            [self fetchNotificationsWithPath:path andDateString:nil array:array success:callback failure:failure];
        } else {
            path = [NSString stringWithFormat:@"notifications/search/findNotificationsForUniversitySince\?universityId=%d&since=%@",[univId intValue],[iso8601String urlEncodeUsingEncoding:NSUTF8StringEncoding]];
            [self fetchNotificationsWithPath:path andDateString:[iso8601String urlEncodeUsingEncoding:NSUTF8StringEncoding] array:array success:callback failure:failure];
        }
        
    }
}

+ (void)fetchNotificationsWithPath:(NSString *)path andDateString:(NSString *)dateStr array:(NSMutableArray *)array success:(void(^)(NSArray *))callback failure:(void(^)())failure {
    [UNMUtilities fetchFromApiWithPath:path success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *embedded = responseObject[@"_embedded"];
        NSDictionary *links = responseObject[@"_links"];
        if (embedded != nil) {
            NSArray *objects = embedded[@"notifications"];
            if (objects != nil) {
                for (NSDictionary *object in objects) {
                    NSNumber *ID = object[@"id"];
                    NSString *content = object[@"content"];
                    NSDate *date = [NSDate getDateFromISOString:object[@"notificationTime"]];
                    if (ID != nil && content != nil && date != nil && [ID class] != [NSNull class] && [content class] != [NSNull class] && [date class] != [NSNull class]) {
                        UNMNotificationBasic *notif = [[UNMNotificationBasic alloc]initWithID:ID andContent:content andDate:date];
                        if (array != nil) {
                            [array addObject:notif];
                        }
                    }
                }
            }
            if (links != nil) {
                NSString *nextUrlPath = links[@"next"][@"href"];
                if (nextUrlPath && dateStr) {
                    nextUrlPath = [nextUrlPath stringByReplacingOccurrencesOfString:kBaseApiURLStr withString:@""];
                    nextUrlPath = [nextUrlPath stringByReplacingOccurrencesOfString:dateStr withString:@"placeholder"];
                    nextUrlPath = [nextUrlPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    nextUrlPath = [nextUrlPath stringByReplacingOccurrencesOfString:@"placeholder" withString:dateStr];
                    [self fetchNotificationsWithPath:nextUrlPath andDateString:dateStr array:array success:callback failure:failure];
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
           [UNMUtilities showErrorWithTitle:@"Impossible d'accéder aux informations" andMessage:@"Merci de vérifier que vous êtes connecté à internet" andDelegate:nil];
           failure();
       }
   }];
}
@end
