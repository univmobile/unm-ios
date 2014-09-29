//
//  UNMAppToken.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 29/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMAppToken.h"

@implementation UNMAppToken

// Override: MTLJSONSerializing
+ (NSDictionary*) JSONKeyPathsByPropertyKey {
	
	NSMutableDictionary* const map = [NSMutableDictionary new];
	
	// add: [super JSONKeyPathsByPropertyKey];
	
	[map addEntriesFromDictionary:@{
									@"id": @"id",
									@"user": @"user"
									}];
	
	return map;
}

// Override: MTLJSONSerializing
+ (NSValueTransformer*)userJSONTransformer {
	
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[UNMAppUser class]];
}

@end


@implementation UNMAppUser

// Override: MTLJSONSerializing
+ (NSDictionary*) JSONKeyPathsByPropertyKey {
	
	NSMutableDictionary* const map = [NSMutableDictionary new];
	
	// add: [super JSONKeyPathsByPropertyKey];
	
	[map addEntriesFromDictionary:@{
									@"uid": @"uid",
									@"email": @"mail",
									@"displayName": @"displayName"
									}];
	
	return map;
}

@end
