//
//  UNMRegionData.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 04/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

@import Foundation;
#import <Mantle.h>

//
//	A struct to hold a region data used in initial choosing
//
@interface UNMRegionData : NSObject <MTLJSONSerializing>

@property (copy, nonatomic) NSString* id; // e.g. @"ile_de_france"
@property (copy, nonatomic) NSString* label; // e.g. @"Île de France"

@property (strong, nonatomic) NSArray* universities; // array of UNMUniversityData*

- (instancetype)initWithId:(NSString*)id label:(NSString*)label;
- (void)addUniversityWithId:(NSString*)id title:(NSString*)title;

@end

//
//	A struct to hold an university data used in initial choosing
//
@interface UNMUniversityData : NSObject <MTLJSONSerializing>

@property (copy, nonatomic) NSString* id; // e.g. @"paris1"
@property (copy, nonatomic) NSString* title; // e.g. @"Paris 1 Panthéon-Sorbonne"

- (instancetype)initWithId:(NSString*)id title:(NSString*)title;

@end
