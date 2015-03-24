//
//  UNMRegionBasic.m
//  unm-ios
//
//  Created by UnivMobile on 1/15/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMRegionBasic.h"
#import "UNMUtilities.h"
#import "UNMConstants.h"

@implementation UNMRegionBasic

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _title = [coder decodeObjectForKey:@"title"];
        _label = [coder decodeObjectForKey:@"label"];
        _universitiesURL = [coder decodeObjectForKey:@"universityUrl"];
        _ID = [coder decodeObjectForKey:@"ID"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_label forKey:@"label"];
    [aCoder encodeObject:_universitiesURL forKey:@"universityUrl"];
    [aCoder encodeObject:_ID forKey:@"ID"];
}

- (instancetype)initWithTitle:(NSString *)title andLabel:(NSString *)label andUniversitiesURL:(NSString *)url andID:(NSNumber *)ID
{
    self = [super init];
    if (self) {
        _title = title;
        _label = label;
        _universitiesURL = url;
        _ID = ID;
    }
    return self;
}

- (void)saveToUserDefaults {
    [super saveToUserDefaultsWithKey:@"region"];
}

+ (UNMRegionBasic *)getSavedObject {
    return [super getSavedObjectForKey:@"region"];
}

+ (void)fetchRegionWithPath:(NSString *)path success:(void(^)(UNMRegionBasic *))callback failure:(void(^)())failure {
    path = [path stringByReplacingOccurrencesOfString:kBaseApiURLStr withString:@""];
    [UNMUtilities fetchFromApiWithPath:path success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *title = responseObject[@"name"];
        NSString *label = responseObject[@"label"];
        NSDictionary *links = responseObject[@"_links"];
        NSString *universitiesURL = links[@"universities"][@"href"];
        NSNumber *ID = responseObject[@"id"];
        if (ID != nil && title != nil && label != nil && [title class] != [NSNull class] && [label class] != [NSNull class] && [ID class] != [NSNull class]) {
            UNMRegionBasic *region = [[UNMRegionBasic alloc]initWithTitle:title andLabel:label andUniversitiesURL:universitiesURL andID:ID];
            callback(region);
            return;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [UNMUtilities showErrorWithTitle:@"Impossible d'accéder aux informations" andMessage:@"Merci de vérifier que vous êtes connecté à internet" andDelegate:nil];
    }];
}
@end
