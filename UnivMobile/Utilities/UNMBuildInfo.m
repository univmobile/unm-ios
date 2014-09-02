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

- (instancetype) initWithBundle:(NSBundle*)bundle {
	
	self = [super init];
	
	if (self) {
		
		// e.g. @"153"
		_BUILD_NUMBER = [bundle stringForKey:@"BUILD_NUMBER" defaultValue:@"???"];
		
		// e.g. @"2014-07-08_13_19_00"
		_BUILD_ID = [bundle stringForKey:@"BUILD_ID" defaultValue:@"????/??/?? ??:??:??"];
		
		// e.g. @"#153"
		_BUILD_DISPLAY_NAME = [bundle stringForKey:@"BUILD_DISPLAY_NAME" defaultValue:@"#???"];
		
		// e.g. @"c159768e3c52b27bb15e4b8c9d865a3debe667e0"
		_GIT_COMMIT = [bundle stringForKey:@"GIT_COMMIT"
								defaultValue:@"????????????????????????????????????????"];
		
		// e.g. @"https://univmobile-dev.univ-paris1.fr/json/"
		_UNMJsonBaseURL = [bundle stringForKey:@"UNMJsonBaseURL"
								defaultValue:@"???"];
	}
	
	return self;
}

@end