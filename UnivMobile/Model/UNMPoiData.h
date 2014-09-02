//
//  UNMPoiData.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 01/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

@import Foundation;
#import <Mantle.h>

@interface UNMPoiData : MTLModel <MTLJSONSerializing>

@property (assign, nonatomic) NSUInteger id; // e.g. 123
@property (copy, nonatomic) NSString* name; // e.g. @"Université de Cergy Pontoise"
@property (copy, nonatomic) NSString* address; // e.g. @"33, boulevard du Port"
@property (copy, nonatomic) NSString* openingHours;
@property (copy, nonatomic) NSString* floor;
@property (copy, nonatomic) NSString* itinerary;
@property (copy, nonatomic) NSString* email;
@property (copy, nonatomic) NSString* phone;
@property (copy, nonatomic) NSString* url;
@property (copy, nonatomic) NSString* coordinates;
@property (assign, nonatomic) CGFloat lat;
@property (assign, nonatomic) CGFloat lng;
@property (copy, nonatomic) NSString* commentsUrl; // e.g. @"http://univmobile.vswip.com/u/comments/poi123"

- (instancetype)initWithId:(NSUInteger)id name:(NSString*)name;


@end

