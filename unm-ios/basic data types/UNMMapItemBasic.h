//
//  UNMMapItemBasic.h
//  unm-ios
//
//  Created by UnivMobile on 1/19/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "UNMCategoryIconProtocol.h"

@interface UNMMapItemBasic : NSObject<NSCopying,UNMCategoryIconProtocol>
@property (strong, nonatomic) NSNumber *ID;
@property (strong, nonatomic) NSNumber *categoryID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *desc;
@property (nonatomic) CGFloat lat;
@property (nonatomic) CGFloat lon;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) NSString *welcome;
@property (strong, nonatomic) NSString *disciplines;
@property (strong, nonatomic) NSString *openingHours;
@property (strong, nonatomic) NSString *closingHours;
@property (strong, nonatomic) NSString *floor;
@property (strong, nonatomic) NSString *itinerary;
@property (strong, nonatomic) NSString *restoID;
@property (strong, nonatomic) NSString *activeIconName;
@property (strong, nonatomic) NSString *markerIconName;
@property (strong, nonatomic) NSString *cityName;
@property (nonatomic) BOOL ruedesfacs;
- (instancetype)initWithID:(NSNumber *)ID andName:(NSString*)name andDescription:(NSString *)desc andLat:(CGFloat)lat andLon:(CGFloat)lon andAddress:(NSString *)address andPhone:(NSString *)phone andEmail:(NSString *)email andRestorauntID:(NSString *)restoID andRuedesfacs:(BOOL)ruedesfacs andCategoryID:(NSNumber *)catID andWebsite:(NSString *)website andWelcome:(NSString *)welcome andDisciplines:(NSString *)disciplines andOpeningHours:(NSString *)openingHours andClosingHours:(NSString *)closingHours andFloor:(NSString *)floor andItinerary:(NSString *)itinerary andActiveIcon:(NSString *)active andMarkerIcon:(NSString *)marker andCityName:(NSString *)cityName;
+ (void)fetchMarkersWithMap:(GMSMapView *)map categoryIds:(NSArray *)categoryIDs success:(void(^)(NSArray *))callback failure:(void(^)())failure;
+ (void)fetchMarkersWithSuccess:(void(^)())callback failure:(void(^)())failure;
+ (void)fetchMarkersWithCategoryIds:(NSArray *)categoryIDs success:(void(^)(NSArray *))callback failure:(void(^)())failure;
+ (void)fetchMarkersWithMap:(GMSMapView *)map andPath:(NSString *)path success:(void(^)())callback failure:(void(^)())failure;
+ (void)fetchMarkersWithUniversityID:(NSNumber *)univID andCategoryID:(NSNumber *)catID andSearchString:(NSString *)query success:(void(^)(NSArray *))callback failure:(void(^)())failure;
+ (void)fetchMarkersWithMap:(GMSMapView *)map WithRootIDs:(NSArray *)rootIDs success:(void(^)(NSArray *))callback failure:(void(^)())failure;
+ (void)fetchMarkerWithMap:(GMSMapView *)map withID:(NSNumber *)ID success:(void(^)(UNMMapItemBasic *))callback failure:(void(^)())failure;
+ (void)fetchMarkerWithMap:(GMSMapView *)map withUrl:(NSString *)Url success:(void(^)(UNMMapItemBasic *))callback failure:(void(^)())failure;
+ (void)fetch20MarkersWithSuccess:(void(^)(NSArray *))callback failure:(void(^)())failure;
@end
