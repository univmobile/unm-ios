//
//  UNMAppToken.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 29/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>


@interface UNMTwitterFollower : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString* screenName; // e.g. "dandriana"

@property (strong, nonatomic) NSString* name; // e.g. "David Andriana"

@end


@interface UNMAppUser : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString* uid; // e.g. "crezvani"

@property (strong, nonatomic) NSString* email;

@property (strong, nonatomic) NSString* displayName; // e.g. "Cyrus Rezvani"

@property (strong, nonatomic) NSArray* twitterFollowers; // array of UNMTwitterFollower*

- (NSUInteger) sizeOfTwitterFollowers;

- (UNMTwitterFollower*) twitterFollowerAtIndex:(NSUInteger)row;

//- (UNMPoiData*) poiDataById:(NSUInteger*) poiId;

@end


@interface UNMAppToken : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString* id;

@property (strong, nonatomic) UNMAppUser* user;

@end
