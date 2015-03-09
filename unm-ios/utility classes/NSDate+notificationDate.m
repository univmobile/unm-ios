//
//  NSDate+isoDate.m
//  unm-ios
//
//  Created by UnivMobile on 1/30/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "NSDate+notificationDate.h"

@implementation NSDate (notificationDate)
- (void)saveNotificationDateToUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self forKey:@"notificationLoadDate"];
    [defaults synchronize];
}

+ (NSDate *)getSavedNotificationDate {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"notificationLoadDate"];
}

+ (NSDate *)getDateFromISOString:(NSString *)isoString {
    if (!isoString || [isoString class] == [NSNull class]) {
        return nil;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
        
    return [dateFormatter dateFromString:isoString];
}

- (NSString *)isoDateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    
    return [dateFormatter stringFromDate:self];
}

- (NSString *)newsCellDateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"/dd/MM/yyyy"];
    
    return [dateFormatter stringFromDate:self];
}

- (NSString *)bonPlanDateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    return [dateFormatter stringFromDate:self];
}


typedef NS_ENUM(NSInteger, UNMDifferenceIn) {
    years   = 0,
    months  = 1,
    days    = 2,
    hours   = 3,
    minutes = 4
};

- (NSInteger)getDifferenceBetween:(UNMDifferenceIn)type toDate:(NSDate *)date  {
    if (!date) {
        return 0;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:self toDate:date options:0];
    switch (type) {
        case years:
            return [components year];
        case months:
            return [components month];
        case days:
            return [components day];
        case hours:
            return [components hour];
        case minutes:
            return [components minute];
        default:
            return 0;
    }
}

- (NSInteger)getMinutesBetweenDate:(NSDate *)date {
    return [self getDifferenceBetween:minutes toDate:date];
}

- (NSInteger)getHoursBetweenDate:(NSDate *)date {
    return [self getDifferenceBetween:hours toDate:date];
}

- (NSInteger)getDaysBetweenDate:(NSDate *)date {
    return [self getDifferenceBetween:days toDate:date];
}

- (NSInteger)getYearsBetweenDate:(NSDate *)date {
    return [self getDifferenceBetween:years toDate:date];
}

- (NSInteger)getMonthsBetweenDate:(NSDate *)date {
    return [self getDifferenceBetween:months toDate:date];
}

- (NSString *)getTimeSinceString {
    NSInteger minutes = [self getMinutesBetweenDate:[NSDate date]];
    NSInteger days = [self getDaysBetweenDate:[NSDate date]];
    NSInteger hours = [self getHoursBetweenDate:[NSDate date]];
    
    if (days > 0) {
        return [NSString stringWithFormat:@"il y a %d jours",(int)days];
    } else if (hours > 0) {
        return [NSString stringWithFormat:@"il y a %d heures",(int)hours];
    } else if (minutes > 0) {
        return [NSString stringWithFormat:@"il y a %d minutes",(int)minutes];
    } else {
        return @"juste maintenant";
    }
    return nil;
}


@end
