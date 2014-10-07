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

- (NSUInteger) sizeOfTwitterFollowers {
	
	return [self.twitterFollowers count];
}

- (UNMTwitterFollower*) twitterFollowerAtIndex:(NSUInteger)row {
	
	return [self.twitterFollowers objectAtIndex:row];
}

// Override: MTLJSONSerializing
+ (NSDictionary*) JSONKeyPathsByPropertyKey {
	
	NSMutableDictionary* const map = [NSMutableDictionary new];
	
	// add: [super JSONKeyPathsByPropertyKey];
	
	[map addEntriesFromDictionary:@{
									@"uid": @"uid",
									@"email": @"mail",
									@"displayName": @"displayName",
									@"twitterFollowers": @"twitterFollowers"
									}];
	
	return map;
}

// Override: MTLJSONSerializing
+ (NSValueTransformer*)twitterFollowersJSONTransformer {
	
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[UNMTwitterFollower class]];
}

@end


@implementation UNMTwitterFollower

// Override: MTLJSONSerializing
+ (NSDictionary*) JSONKeyPathsByPropertyKey {
	
	NSMutableDictionary* const map = [NSMutableDictionary new];
	
	// add: [super JSONKeyPathsByPropertyKey];
	
	[map addEntriesFromDictionary:@{
									@"screenName": @"screenName",
									@"name": @"name"
									}];
	
	return map;
}

@end


@implementation UNMLoginConversation

// Override: MTLJSONSerializing
+ (NSDictionary*) JSONKeyPathsByPropertyKey {
	
	NSMutableDictionary* const map = [NSMutableDictionary new];
	
	// add: [super JSONKeyPathsByPropertyKey];
	
	[map addEntriesFromDictionary:@{
									@"loginToken": @"loginToken",
									@"key": @"key"
									}];
	
	return map;
}

@end
