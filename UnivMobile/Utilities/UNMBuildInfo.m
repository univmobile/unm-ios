//
//  UNMBuildInfo.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 09/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMBuildInfo.h"

@interface NSBundle (String)

+ (NSString*) stringForKey:(NSString*)key defaultValue:(NSString*)defaultValue;

@end

@implementation UNMBuildInfo

- (instancetype) init {
	
	self = [super init];
	
	if (self) {
		
		// e.g. @"153"
		_BUILD_NUMBER = [NSBundle stringForKey:@"BUILD_NUMBER" defaultValue:@"???"];
		
		// e.g. @"2014-07-08_13_19_00"
		_BUILD_ID = [NSBundle stringForKey:@"BUILD_ID" defaultValue:@"????/??/?? ??:??:??"];
		
		// e.g. @"#153"
		_BUILD_DISPLAY_NAME = [NSBundle stringForKey:@"BUILD_DISPLAY_NAME" defaultValue:@"#???"];
		
		// e.g. @"c159768e3c52b27bb15e4b8c9d865a3debe667e0"
		_GIT_COMMIT = [NSBundle stringForKey:@"GIT_COMMIT"
								defaultValue:@"????????????????????????????????????????"];
	}
	
	return self;
}

@end

@implementation NSBundle (String)

+ (NSString*) stringForKey:(NSString*)key defaultValue:(NSString*)defaultValue {
	
	NSBundle* const mainBundle = [NSBundle mainBundle];
	
	id object = [mainBundle objectForInfoDictionaryKey:key];
	
	if (!object) return defaultValue;
	
	return [NSString stringWithFormat:@"%@", object];
}

@end
