//
//  UNMBuildInfo.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 09/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMBuildInfo.h"
#import "NSBundle+String.h"

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
		
		// e.g. @"https://univmobile-dev.univ-paris1.fr/json/"
		_UNMJsonBaseURL = [NSBundle stringForKey:@"UNMJsonBaseURL"
								defaultValue:@"???"];
	}
	
	return self;
}

@end