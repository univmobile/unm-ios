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

@property (copy, nonatomic) NSString* screenName; // e.g. "dandriana"

@property (copy, nonatomic) NSString* name; // e.g. "David Andriana"

@end


@interface UNMAppUser : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic) NSString* uid; // e.g. "crezvani"

@property (copy, nonatomic) NSString* email;

@property (copy, nonatomic) NSString* displayName; // e.g. "Cyrus Rezvani"

@property (strong, nonatomic) NSArray* twitterFollowers; // array of UNMTwitterFollower*

- (NSUInteger) sizeOfTwitterFollowers;

- (UNMTwitterFollower*) twitterFollowerAtIndex:(NSUInteger)row;

//- (UNMPoiData*) poiDataById:(NSUInteger*) poiId;

@end


@interface UNMAppToken : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic) NSString* id;

@property (strong, nonatomic) UNMAppUser* user;

@end


@interface UNMLoginConversation : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic) NSString* loginToken;

@property (copy, nonatomic) NSString* key;

@end
