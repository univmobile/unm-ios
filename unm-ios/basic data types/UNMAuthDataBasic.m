//
//  UNMAuthDataBasic.m
//  unm-ios
//
//  Created by UnivMobile on 1/30/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMAuthDataBasic.h"

@implementation UNMAuthDataBasic
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.accessToken = [coder decodeObjectForKey:@"accesstoken"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.accessToken forKey:@"accesstoken"];
}
- (instancetype)initWithAccessToken:(NSString *)accessToken
{
    self = [super init];
    if (self) {
        _accessToken = accessToken;
    }
    return self;
}
- (void)saveToUserDefaults {
    [super saveToUserDefaultsWithKey:@"authData"];
}

+ (UNMAuthDataBasic *)getSavedObject {
    return [super getSavedObjectForKey:@"authData"];
}
@end
