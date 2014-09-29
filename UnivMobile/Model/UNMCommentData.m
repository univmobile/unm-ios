//
//  UNMCommentData.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 02/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMCommentData.h"

@implementation UNMCommentData

// Override: MTLJSONSerializing
+ (NSDictionary*) JSONKeyPathsByPropertyKey {
	
	NSMutableDictionary* const map = [NSMutableDictionary new];
	
	// add: [super JSONKeyPathsByPropertyKey];
	
	[map addEntriesFromDictionary:@{
									@"id": @"id",
									@"authorUsername": @"author.username",
									@"authorDisplayName": @"author.displayName",
									@"text":@"text"
									}];
	
	return map;
}

@end
