//
//  UNMCommentData.h
//  UnivMobile
//
//  Created by David on 02/09/2014.
//  Copyright (c) 2014 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

@interface UNMCommentData : MTLModel <MTLJSONSerializing>

@property (assign, nonatomic) NSUInteger id; // e.g. 123
@property (copy, nonatomic) NSString* authorDisplayName; // e.g. @"David Andrianavalontsalama"
@property (copy, nonatomic) NSString* authorUsername; // e.g. @"dandriana"
@property (copy, nonatomic) NSString* text; // The message

//- (instancetype)initWithId:(NSUInteger)id username:(NSString*)authorUsername;

@end
