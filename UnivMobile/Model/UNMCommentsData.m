//
//  UNMCommentsData.m
//  UnivMobile
//
//  Created by David on 02/09/2014.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "UNMCommentsData.h"

@implementation UNMCommentsData

- (NSUInteger) sizeOfCommentData {
	
	return [self.comments count];
}

- (UNMCommentData*) commentDataAtIndex:(NSUInteger)row {
	
	return [self.comments objectAtIndex:row];
}

// Override: MTLJSONSerializing
+ (NSDictionary*) JSONKeyPathsByPropertyKey {
	
	NSMutableDictionary* const map = [NSMutableDictionary new];
	
	// add: [super JSONKeyPathsByPropertyKey];
	
	[map addEntriesFromDictionary:@{
									@"comments": @"comments"
									}];
	
	return map;
}

// Override: MTLJSONSerializing
+ (NSValueTransformer*)commentsJSONTransformer {
	
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[UNMCommentData class]];
}

@end