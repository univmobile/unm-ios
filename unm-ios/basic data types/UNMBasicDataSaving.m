//
//  UNMBasicDataSaving.m
//  unm-ios
//
//  Created by UnivMobile on 1/30/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMBasicDataSaving.h"

@implementation UNMBasicDataSaving

- (void)saveToUserDefaultsWithKey:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
}

+ (id)getSavedObjectForKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    if (encodedObject != nil) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    } else {
        return nil;
    }
}
@end
