//
//  NSBundle+String.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 04/08/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "NSBundle+String.h"

@implementation NSBundle (String)

- (NSString*) stringForKey:(NSString*)key defaultValue:(NSString*)defaultValue {
	
//	NSBundle* const mainBundle = [NSBundle mainBundle]; // Will not work in XCTests
//	[NSBundle bundleForClass:[self class]]; // Will not work un main project
	
	id object = [self objectForInfoDictionaryKey:key];
	
	if (!object) return defaultValue;
	
	return [NSString stringWithFormat:@"%@", object];
}

@end
