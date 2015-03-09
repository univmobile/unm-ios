//
//  NSDate+isoDate.h
//  unm-ios
//
//  Created by UnivMobile on 1/30/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (notificationDate)
- (void)saveNotificationDateToUserDefaults;
+ (NSDate *)getSavedNotificationDate;
+ (NSDate *)getDateFromISOString:(NSString *)isoString;
- (NSString *)isoDateString;
- (NSInteger)getMinutesBetweenDate:(NSDate *)date;
- (NSInteger)getHoursBetweenDate:(NSDate *)date;
- (NSInteger)getDaysBetweenDate:(NSDate *)date;
- (NSInteger)getYearsBetweenDate:(NSDate *)date;
- (NSInteger)getMonthsBetweenDate:(NSDate *)date;
- (NSString *)newsCellDateString;
- (NSString *)bonPlanDateString;
- (NSString *)getTimeSinceString;
@end
