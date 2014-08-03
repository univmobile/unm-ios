//
//  NSBundle+String.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 04/08/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "NSBundle+String.h"

@implementation NSBundle (String)

+ (NSString*) stringForKey:(NSString*)key defaultValue:(NSString*)defaultValue {
	
	NSBundle* const mainBundle = [NSBundle mainBundle];
	
	id object = [mainBundle objectForInfoDictionaryKey:key];
	
	if (!object) return defaultValue;
	
	return [NSString stringWithFormat:@"%@", object];
}

@end
