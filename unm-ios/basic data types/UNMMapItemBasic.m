//
//  UNMMapItemBasic.m
//  unm-ios
//
//  Created by UnivMobile on 1/19/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMMapItemBasic.h"
#import "UNMUtilities.h"
#import "UNMUniversityBasic.h"
#import "UNMConstants.h"
#import "UNMCategoryIcons.h"

@implementation UNMMapItemBasic

- (instancetype)initWithID:(NSNumber *)ID andName:(NSString*)name andDescription:(NSString *)desc andLat:(CGFloat)lat andLon:(CGFloat)lon andAddress:(NSString *)address andPhone:(NSString *)phone andEmail:(NSString *)email andRestorauntID:(NSString *)restoID andRuedesfacs:(BOOL)ruedesfacs andCategoryID:(NSNumber *)catID andWebsite:(NSString *)website andWelcome:(NSString *)welcome andDisciplines:(NSString *)disciplines andOpeningHours:(NSString *)openingHours andClosingHours:(NSString *)closingHours andFloor:(NSString *)floor andItinerary:(NSString *)itinerary andActiveIcon:(NSString *)active andMarkerIcon:(NSString *)marker andCityName:(NSString *)cityName
{
    self = [super init];
    if (self) {
        _ID = ID;
        _name = name;
        _desc = desc;
        _lat = lat;
        _lon = lon;
        _address = address;
        _phone = phone;
        _email = email;
        _restoID = restoID;
        _ruedesfacs = ruedesfacs;
        _categoryID = catID;
        _website = website;
        _welcome = welcome;
        _disciplines = disciplines;
        _openingHours = openingHours;
        _closingHours = closingHours;
        _floor = floor;
        _itinerary = itinerary;
        _activeIconName = active;
        _markerIconName = marker;
        _cityName = cityName;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    UNMMapItemBasic *newItem = [[[self class]allocWithZone:zone]init];
    newItem->_ID = [_ID copyWithZone:zone];
    newItem->_name = [_name copyWithZone:zone];
    newItem->_desc = [_desc copyWithZone:zone];
    newItem->_lat = _lat;
    newItem->_lon = _lon;
    newItem->_ruedesfacs = _ruedesfacs;
    newItem->_address = [_address copyWithZone:zone];
    newItem->_phone = [_phone copyWithZone:zone];
    newItem->_email = [_email copyWithZone:zone];
    newItem->_restoID = [_restoID copyWithZone:zone];
    newItem->_categoryID = [_categoryID copyWithZone:zone];
    newItem->_welcome = [_welcome copyWithZone:zone];
    newItem->_website = [_website copyWithZone:zone];
    newItem->_disciplines = [_disciplines copyWithZone:zone];
    newItem->_openingHours = [_openingHours copyWithZone:zone];
    newItem->_closingHours = [_closingHours copyWithZone:zone];
    newItem->_floor = [_floor copyWithZone:zone];
    newItem->_itinerary = [_itinerary copyWithZone:zone];
    newItem->_activeIconName = [_activeIconName copyWithZone:zone];
    newItem->_markerIconName = [_markerIconName copyWithZone:zone];
    newItem->_cityName = [_cityName copyWithZone:zone];
    return newItem;
}

- (BOOL)isEqual:(id)object {
    if (![object isMemberOfClass:[self class]]) {
        return NO;
    } else {
        UNMMapItemBasic *other = object;
        if ([self name] != [other name] && ![(id)[self name] isEqual:[other name]]) {
            return NO;
        } else if ([self ID] != [other ID] && ![(id)[self ID] isEqual:[other ID]]) {
            return NO;
        } else if ([self desc] != [other desc] && ![(id)[self desc] isEqual:[other desc]]) {
            return NO;
        } else if ([self lat] != [other lat]) {
            return NO;
        } else if ([self lon] != [other lon]) {
            return NO;
        } else if ([self ruedesfacs] != [other ruedesfacs]) {
            return NO;
        } else if ([self restoID] != [other restoID] && ![(id)[self restoID] isEqual:[other restoID]]) {
            return NO;
        } else if ([self categoryID] != [other categoryID] && ![(id)[self categoryID] isEqual:[other categoryID]]) {
            return NO;
        } else if ([self phone] != [other phone] && ![(id)[self phone] isEqual:[other phone]]) {
            return NO;
        } else if ([self address] != [other address] && ![(id)[self address] isEqual:[other address]]) {
            return NO;
        } else if ([self cityName] != [other cityName] && ![(id)[self cityName] isEqual:[other cityName]]) {
            return NO;
        } else if ([self email] != [other email] && ![(id)[self email] isEqual:[other email]]) {
            return NO;
        } else if ([self welcome] != [other welcome] && ![(id)[self welcome] isEqual:[other welcome]]) {
            return NO;
        } else if ([self website] != [other website] && ![(id)[self website] isEqual:[other website]]) {
            return NO;
        } else if ([self disciplines] != [other disciplines] && ![(id)[self disciplines] isEqual:[other disciplines]]) {
            return NO;
        } else if ([self openingHours] != [other openingHours] && ![(id)[self openingHours] isEqual:[other openingHours]]) {
            return NO;
        } else if ([self closingHours] != [other closingHours] && ![(id)[self closingHours] isEqual:[other closingHours]]) {
            return NO;
        } else if ([self floor] != [other floor] && ![(id)[self floor] isEqual:[other floor]]) {
            return NO;
        } else if ([self itinerary] != [other itinerary] && ![(id)[self itinerary] isEqual:[other itinerary]]) {
            return NO;
        } else if ([self activeIconName] != [other activeIconName] && ![(id)[self activeIconName] isEqual:[other activeIconName]]) {
            return NO;
        } else if ([self markerIconName] != [other markerIconName] && ![(id)[self markerIconName] isEqual:[other markerIconName]]) {
            return NO;
        } else {
            return YES;
        }
    }
}

- (NSUInteger)objectsHash:(NSObject *)object {
    if (object == nil) {
        return 0;
    } else {
        return [object hash];
    }
}

- (NSUInteger)hash {
    NSUInteger prime = 31;
    NSUInteger result = 1;
    result = prime * result + self.lat;
    result = prime * result + self.lon;
    result = prime * result + [self objectsHash:[self ID]];
    result = prime * result + [self objectsHash:[self name]];
    result = prime * result + [self objectsHash:[self desc]];
    result = prime * result + [self objectsHash:[self address]];
    result = prime * result + [self objectsHash:[self cityName]];
    result = prime * result + [self objectsHash:[self phone]];
    result = prime * result + [self objectsHash:[self email]];
    result = prime * result + [self objectsHash:[self restoID]];
    result = prime * result + [self objectsHash:[self categoryID]];
    result = prime * result + [self objectsHash:[self website]];
    result = prime * result + [self objectsHash:[self welcome]];
    result = prime * result + [self objectsHash:[self openingHours]];
    result = prime * result + [self objectsHash:[self closingHours]];
    result = prime * result + [self objectsHash:[self floor]];
    result = prime * result + [self objectsHash:[self itinerary]];
    result = prime * result + [self objectsHash:[self disciplines]];
    result = prime * result + [self objectsHash:[self activeIconName]];
    result = prime * result + [self objectsHash:[self markerIconName]];
    result = prime * result + ((self.ruedesfacs)?1231:1237);
    return result;
}

+ (void)fetchMarkersWithUniversityID:(NSNumber *)univID andCategoryID:(NSNumber *)catID andSearchString:(NSString *)query success:(void(^)(NSArray *))callback failure:(void(^)())failure {
    NSMutableArray *array = [NSMutableArray new];
    NSString *searchStr;
    if (univID && catID && [univID class] != [NSNull class] && [catID class] != [NSNull class]) {
        searchStr = [NSString stringWithFormat:@"searchValueInUniversityAndCategoryRoot?val=%@&categoryId=%d&universityId=%d&size=200",[query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[catID intValue],[univID intValue]];
    } else if (catID && [catID class] != [NSNull class]) {
        searchStr = [NSString stringWithFormat:@"searchValueInCategoryRoot?val=%@&categoryId=%d&size=200",[query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[catID intValue]];
    }
    if (searchStr) {
        NSString *path = [NSString stringWithFormat:@"pois/search/%@",searchStr];
        [self fetchMarkersWithMap:nil path:path array:array limit:nil success:callback failure:failure];
    }

}

+ (void)fetchMarkersWithSuccess:(void(^)())callback failure:(void(^)())failure {
    [self fetchMarkersWithMap:nil categoryIds:nil success:callback failure:failure];
}

+ (void)fetchMarkersWithCategoryIds:(NSArray *)categoryIDs success:(void(^)(NSArray *))callback failure:(void(^)())failure {
    [self fetchMarkersWithMap:nil categoryIds:categoryIDs success:callback failure:failure];
}

+ (void)fetchMarkersWithMap:(GMSMapView *)map andPath:(NSString *)path success:(void(^)())callback failure:(void(^)())failure {
    [self fetchMarkersWithMap:map path:path array:nil limit:nil success:callback failure:failure];
}

+ (void)fetchMarkersWithMap:(GMSMapView *)map categoryIds:(NSArray *)categoryIDs success:(void(^)(NSArray *))callback failure:(void(^)())failure {
    NSString *path;
    UNMUniversityBasic *university = [UNMUniversityBasic getSavedObject];
    if (university.univId) {
        NSMutableArray *array = [NSMutableArray new];
        if (categoryIDs && [categoryIDs count] > 0) {
            NSString *categoryString = @"";
            for (NSNumber *catID in categoryIDs) {
                if (![catID isEqualToNumber:[categoryIDs lastObject]]) {
                    categoryString = [categoryString stringByAppendingString:[NSString stringWithFormat:@"%d,",[catID intValue]]];
                } else {
                    categoryString = [categoryString stringByAppendingString:[catID stringValue]];
                }
            }
            NSString *searchStr = [NSString stringWithFormat:@"findByUniversityAndCategoryIn?universityId=%d&categories=%@&size=200",[[university univId] intValue],categoryString];
            path = [NSString stringWithFormat:@"pois/search/%@",searchStr];
            [self fetchMarkersWithMap:map path:path array:array limit:nil success:callback failure:failure];
        } else {
            NSString *searchStr = [NSString stringWithFormat:@"findByUniversityAndCategoryRoot?universityId=%d&categoryId=1&size=200",[[university univId] intValue]];
            path = [NSString stringWithFormat:@"pois/search/%@",searchStr];
            [self fetchMarkersWithMap:map path:path array:array limit:nil success:callback failure:failure];
        }
    }
}

+ (void)fetch20MarkersWithSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure {
    NSMutableArray *array = [NSMutableArray new];
    [self fetchMarkersWithMap:nil path:@"pois" array:array limit:[NSNumber numberWithInt:20] success:callback failure:failure];
}

+ (void)fetchMarkersWithMap:(GMSMapView *)map WithRootIDs:(NSArray *)rootIDs success:(void(^)(NSArray *))callback failure:(void(^)())failure {
    NSMutableArray *array = [NSMutableArray new];
    if ([rootIDs count] == 1) {
        NSNumber *ID = [rootIDs firstObject];
        NSString *path = [NSString stringWithFormat:@"pois/search/findByCategoryRoot?categoryId=%d&size=200",[ID intValue]];
        [self fetchMarkersWithMap:map path:path array:array limit:nil success:callback failure:failure];
        return;
    } else {
        NSString *categoryString = @"";
        for (NSNumber *rootCatID in rootIDs) {
            if (![rootCatID isEqualToNumber:[rootIDs lastObject]]) {
                categoryString = [categoryString stringByAppendingString:[NSString stringWithFormat:@"%d,",[rootCatID intValue]]];
            } else {
                categoryString = [categoryString stringByAppendingString:[rootCatID stringValue]];
            }
        }
        NSString *path = [NSString stringWithFormat:@"pois/search/findByCategoryIn?categories=%@&size=200",categoryString];
        [self fetchMarkersWithMap:map path:path array:array limit:nil success:callback failure:failure];
    }
}

+ (void)fetchMarkerWithMap:(GMSMapView *)map withID:(NSNumber *)ID success:(void(^)(UNMMapItemBasic *))callback failure:(void(^)())failure {
    NSString *path = [NSString stringWithFormat:@"pois/%d",[ID intValue]];
    [self fetchMarkerWithMap:map path:path success:callback failure:failure];
}

+ (void)fetchMarkerWithMap:(GMSMapView *)map withUrl:(NSString *)Url success:(void(^)(UNMMapItemBasic *))callback failure:(void(^)())failure {
    NSString *path = [Url stringByReplacingOccurrencesOfString:kBaseApiURLStr withString:@""];
    [self fetchMarkerWithMap:map path:path success:callback failure:failure];
}

+ (void)fetchMarkersWithMap:(GMSMapView *)map path:(NSString *)path array:(NSMutableArray *)array limit:(NSNumber *)limit success:(void(^)(NSArray *))callback failure:(void(^)())failure {
    [UNMUtilities fetchFromApiForMapWithPath:path success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *embedded = responseObject[@"_embedded"];
            NSDictionary *links = responseObject[@"_links"];
            if (embedded != nil) {
                NSArray *objects = embedded[@"pois"];
                if (objects != nil) {
                    for (NSDictionary *object in objects) {
                        NSNumber *ID = object[@"id"];
                        NSString *name = object[@"name"];
                        NSString *desc = object[@"description"];
                        NSString *lat = object[@"lat"];
                        NSString *lon = object[@"lng"];
                        NSString *address = object[@"address"];
                        NSString *email = object[@"email"];
                        NSString *phones = object[@"phones"];
                        NSString *restoID = object[@"restoId"];
                        NSString *website = object[@"url"];
                        NSString *welcome = object[@"publicWelcome"];
                        NSString *disciplines = object[@"disciplines"];
                        NSString *openingHours = object[@"openingHours"];
                        NSString *closingHours = object[@"closingHours"];
                        NSString *floor = object[@"floor"];
                        NSString *itinerary = object[@"itinerary"];
                        NSNumber *categoryID = object[@"categoryId"];
                        NSString *markerIconName = object[@"categoryMarkerIcon"];
                        NSString *activeIconName = object[@"categoryActiveIcon"];
                        NSString *cityName = object[@"city"];
                        BOOL ruedesfacs = [[object objectForKey:@"iconRuedesfacs"] boolValue];
                        BOOL active = [[object objectForKey:@"active"] boolValue];
                        if (active && ID != nil && name != nil && desc != nil && lat != nil && lon != nil && restoID != nil && categoryID != nil && [ID class] != [NSNull class] && [lat class] != [NSNull class] && [lon class] != [NSNull class] && [categoryID class] != [NSNull class]) {
                            
                            UNMMapItemBasic *markerData = [[UNMMapItemBasic alloc]initWithID:ID andName:name andDescription:desc andLat:[lat floatValue] andLon:[lon floatValue] andAddress:address andPhone:phones andEmail:email andRestorauntID:restoID andRuedesfacs:ruedesfacs andCategoryID:categoryID andWebsite:website andWelcome:welcome andDisciplines:disciplines andOpeningHours:openingHours andClosingHours:closingHours andFloor:floor andItinerary:itinerary andActiveIcon:activeIconName andMarkerIcon:markerIconName andCityName:cityName];
                            if (array != nil) {
                                if (!limit || [array count] < [limit intValue]) {
                                    [array addObject:markerData];
                                }
                                if ([array count] == [limit intValue]) {
                                    callback(array);
                                    return;
                                }
                            }
                            
                        }
                    }
                }
                if (links != nil) {
                    NSString *nextUrlPath = links[@"next"][@"href"];
                    if (nextUrlPath != nil) {
                        nextUrlPath = [nextUrlPath stringByReplacingOccurrencesOfString:kBaseApiURLStr withString:@""];
                        nextUrlPath = [nextUrlPath stringByReplacingOccurrencesOfString:@"{&sort}" withString:@""];
                        nextUrlPath = [nextUrlPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        [self fetchMarkersWithMap:map path:nextUrlPath array:array limit:limit success:callback failure:failure];
                    } else {
                        callback(array);
                    }
                } else {
                    callback(array);
                }
            } else {
                callback(array);
            }
        });
    }
   failure:^(AFHTTPRequestOperation *operation, NSError *error){
       if (!operation.isCancelled) {
           [UNMUtilities showErrorWithTitle:@"Impossible d'accéder aux informations" andMessage:@"Merci de vérifier que vous êtes connecté à internet" andDelegate:nil];
           failure();
       }
   }];
}

+ (void)fetchMarkerWithMap:(GMSMapView *)map path:(NSString *)path success:(void(^)(UNMMapItemBasic *))callback failure:(void(^)())failure {
    [UNMUtilities fetchFromApiWithPath:path success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDictionary *object = responseObject;
            if (object != nil) {
                NSNumber *ID = object[@"id"];
                NSString *name = object[@"name"];
                NSString *desc = object[@"description"];
                NSString *lat = object[@"lat"];
                NSString *lon = object[@"lng"];
                NSString *address = object[@"address"];
                NSString *email = object[@"email"];
                NSString *phones = object[@"phones"];
                NSString *restoID = object[@"restoId"];
                NSString *website = object[@"url"];
                NSString *welcome = object[@"publicWelcome"];
                NSString *disciplines = object[@"disciplines"];
                NSString *openingHours = object[@"openingHours"];
                NSString *closingHours = object[@"closingHours"];
                NSString *floor = object[@"floor"];
                NSString *itinerary = object[@"itinerary"];
                NSString *markerIconName = object[@"categoryMarkerIcon"];
                NSString *activeIconName = object[@"categoryActiveIcon"];
                NSNumber *categoryID = object[@"categoryId"];
                NSString *cityName = object[@"city"];
                BOOL ruedesfacs = [[object objectForKey:@"iconRuedesfacs"] boolValue];
                BOOL active = [[object objectForKey:@"active"] boolValue];
                if (active && ID != nil && name != nil && desc != nil && lat != nil && lon != nil && restoID != nil && categoryID != nil && [ID class] != [NSNull class] && [lat class] != [NSNull class] && [lon class] != [NSNull class] && [categoryID class] != [NSNull class]) {
                    UNMMapItemBasic *markerData = [[UNMMapItemBasic alloc]initWithID:ID andName:name andDescription:desc andLat:[lat floatValue] andLon:[lon floatValue] andAddress:address andPhone:phones andEmail:email andRestorauntID:restoID andRuedesfacs:ruedesfacs andCategoryID:categoryID andWebsite:website andWelcome:welcome andDisciplines:disciplines andOpeningHours:openingHours andClosingHours:closingHours andFloor:floor andItinerary:itinerary andActiveIcon:activeIconName andMarkerIcon:markerIconName andCityName:cityName];
                    callback(markerData);
                } else {
                    failure();
                }
            } else {
                failure();
            }
        });
    }
     failure:^(AFHTTPRequestOperation *operation, NSError *error){
         if (!operation.isCancelled) {
             [UNMUtilities showErrorWithTitle:@"Impossible d'accéder aux informations" andMessage:@"Merci de vérifier que vous êtes connecté à internet" andDelegate:nil];
             failure();
         }
     }];
}

@end
