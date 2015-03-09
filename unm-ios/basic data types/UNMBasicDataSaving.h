//
//  UNMBasicDataSaving.h
//  unm-ios
//
//  Created by UnivMobile on 1/30/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNMBasicDataSaving : NSObject
- (void)saveToUserDefaultsWithKey:(NSString *)key;
+ (id)getSavedObjectForKey:(NSString *)key;
@end
