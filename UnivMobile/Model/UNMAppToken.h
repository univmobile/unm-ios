//
//  UNMAppToken.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 29/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>


@interface UNMAppUser : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString* uid; // e.g. "crezvani"

@property (strong, nonatomic) NSString* email;

@property (strong, nonatomic) NSString* displayName; // e.g. "Cyrus Rezvani"

@end


@interface UNMAppToken : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString* id;

@property (strong, nonatomic) UNMAppUser* user;

@end
