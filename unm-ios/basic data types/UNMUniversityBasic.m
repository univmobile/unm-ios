//
//  UNMUniversityBasic.m
//  unm-ios
//
//  Created by UnivMobile on 1/15/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMUniversityBasic.h"
#import "UNMUtilities.h"
#import "UNMConstants.h"

@implementation UNMUniversityBasic
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _title = [coder decodeObjectForKey:@"title"];
        _univId = [coder decodeObjectForKey:@"univId"];
        _logoUrl = [coder decodeObjectForKey:@"logoUrl"];
        _shibbolethUrl = [coder decodeObjectForKey:@"shibbolethUrl"];
        _regionUrl = [coder decodeObjectForKey:@"regionUrl"];
        _center = [coder decodeCGPointForKey:@"center"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_univId forKey:@"univId"];
    [aCoder encodeObject:_logoUrl forKey:@"logoUrl"];
    [aCoder encodeObject:_shibbolethUrl forKey:@"shibbolethUrl"];
    [aCoder encodeObject:_regionUrl forKey:@"regionUrl"];
    [aCoder encodeCGPoint:_center forKey:@"center"];
}

- (instancetype)initWithTitle:(NSString *)title andId:(NSNumber *)Id andLogoUrl:(NSString *)logoUrl andShibbolethUrl:(NSString *)shibboleth andRegionUrl:(NSString *)regionUrl andCenter:(CGPoint)center
{
    self = [super init];
    if (self) {
        _title = title;
        _univId = Id;
        _logoUrl = logoUrl;
        _shibbolethUrl = shibboleth;
        _regionUrl = regionUrl;
        _center = center;
    }
    return self;
}
- (void)saveToUserDefaults {
    [super saveToUserDefaultsWithKey:@"university"];
}
+ (UNMUniversityBasic *)getSavedObject {
    return [super getSavedObjectForKey:@"university"];
}
+ (void)fetchUniversitiesWithSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure {
    NSMutableArray *array = [NSMutableArray new];
    NSString *path = @"universities";
    [self fetchUniversityItemsWithPath:path array:array success:callback failure:failure];
}

+ (void)fetchUniversitiesWithPath:(NSString *)path andSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure {
    NSMutableArray *array = [NSMutableArray new];
    path = [path stringByReplacingOccurrencesOfString:kBaseApiURLStr withString:@""];
    [self fetchUniversityItemsWithPath:path array:array success:callback failure:failure];
}

+ (void)fetchUniversityItemsWithPath:(NSString *)path array:(NSMutableArray *)array success:(void(^)(NSArray *))callback failure:(void(^)())failure {
    [UNMUtilities fetchFromApiWithPath:path success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *embedded = responseObject[@"_embedded"];
        NSDictionary *links = responseObject[@"_links"];
        if (embedded != nil) {
            NSArray *objects = embedded[@"universities"];
            if (objects != nil) {
                for (NSDictionary *object in objects) {
                    NSString *title = object[@"title"];
                    NSNumber *ID = object[@"id"];
                    NSString *logoUrlStr = object[@"logoUrl"];
                    NSString *shibbolethUrlStr = object[@"mobileShibbolethUrl"];
                    NSString *regionUrlStr = object[@"_links"][@"region"][@"href"];
                    NSNumber *lat = object[@"centralLat"];
                    NSNumber *lon = object[@"centralLng"];
                    BOOL crous = [[object objectForKey:@"crous"] boolValue];
                    CGPoint center;
                    if ([lat class] != [NSNull class] && [lon class] != [NSNull class]) {
                        center = CGPointMake([lat floatValue], [lon floatValue]);
                    }
                    else {
                        center = CGPointMake(kParisLat, kParisLon);
                    }
                    if (!crous && ID && title && logoUrlStr && shibbolethUrlStr && regionUrlStr && [title class] != [NSNull class] && [ID class] != [NSNull class] && [regionUrlStr class] != [NSNull class]) {
                        UNMUniversityBasic *item = [[UNMUniversityBasic alloc] initWithTitle:title andId:ID andLogoUrl:logoUrlStr andShibbolethUrl:shibbolethUrlStr andRegionUrl:regionUrlStr andCenter:center];
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
                    [self fetchUniversityItemsWithPath:nextUrlPath array:array success:callback failure:failure];
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
           [UNMUtilities showErrorWithTitle:@"Impossible d'accéder aux informations" andMessage:@"Merci de vérifier que vous êtes connecté à internet" andDelegate:nil];
           failure();
       }
    }];
}

- (BOOL)isEqual:(id)object {
    if (![object isMemberOfClass:[self class]]) {
        return NO;
    } else {
        UNMUniversityBasic *other = object;
        if ([self.title isEqual:other.title]) {
            if ([self.univId isEqualToNumber:other.univId]) {
                if ([self.logoUrl isEqual: other.logoUrl]) {
                    if ([self.shibbolethUrl isEqual:other.shibbolethUrl]) {
                        if([self.regionUrl isEqual:other.regionUrl]) {
                            return YES;
                        }
                    }
                }
            }
        }
    }
    return NO;
}

- (void)postAsUsageStat {
    NSDictionary *params = @{ @"source":@"I", @"university":[NSString stringWithFormat:@"%@universities/%d",kBaseApiURLStr,[[self univId] intValue]]};
      [UNMUtilities postToApiNoAuthWithPath:@"usageStats" andParams:params success:^(AFHTTPRequestOperation *operation, id result) {} failure:^(AFHTTPRequestOperation *operation, NSError *error) {}];
}
@end
