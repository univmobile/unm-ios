//
//  UNMUserBasic.m
//  unm-ios
//
//  Created by UnivMobile on 1/30/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMUserBasic.h"
#import "UNMConstants.h"
#import "UNMUtilities.h"

@implementation UNMUserBasic
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _username = [coder decodeObjectForKey:@"username"];
        _ID = (NSNumber *)[coder decodeObjectForKey:@"id"];
        _displayName = [coder decodeObjectForKey:@"displayName"];
        _univID = [coder decodeObjectForKey:@"univID"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_username forKey:@"username"];
    [aCoder encodeObject:_ID forKey:@"id"];
    [aCoder encodeObject:_displayName forKey:@"displayName"];
    [aCoder encodeObject:_univID forKey:@"univID"];
}
- (instancetype)initWithUsername:(NSString *)username andID:(NSNumber *)ID andDisplayName:(NSString *)displayName andUnivID:(NSNumber *)univID
{
    self = [super init];
    if (self) {
        _username = username;
        _ID = ID;
        _displayName = displayName;
        _univID = univID;
    }
    return self;
}
- (void)saveToUserDefaults {
    [super saveToUserDefaultsWithKey:@"user"];
}

+ (UNMUserBasic *)getSavedObject {
    return [super getSavedObjectForKey:@"user"];
}

+ (void)fetchUserWithID:(NSNumber *)ID success:(void(^)(UNMUserBasic *))callback failure:(void(^)())failure {
    NSString *path = [NSString stringWithFormat:@"users/%d",[ID intValue]];
    [UNMUtilities fetchFromApiWithPath:path success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *username = responseObject[@"username"];
        NSString *displayName = responseObject[@"displayName"];
        NSNumber *ID = responseObject[@"id"];
        NSString *universityLink = responseObject[@"_links"][@"university"][@"href"];
        if (ID != nil && username != nil && displayName != nil && universityLink && [username class] != [NSNull class] && [displayName class] != [NSNull class] && [ID class] != [NSNull class] && [universityLink class] != [NSNull class]) {
            [UNMUtilities fetchFromApiWithPath:[universityLink stringByReplacingOccurrencesOfString:kBaseApiURLStr withString:@""] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSNumber *univID = responseObject[@"id"];
                UNMUserBasic *user = [[UNMUserBasic alloc]initWithUsername:username andID:ID andDisplayName:displayName andUnivID:univID];
                callback(user);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [UNMUtilities showErrorWithTitle:@"Impossible de charger les informations utilisateur" andMessage:[error localizedDescription] andDelegate:nil];
            }];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [UNMUtilities showErrorWithTitle:@"Impossible de charger les informations utilisateur" andMessage:[error localizedDescription] andDelegate:nil];
    }];
}
@end
