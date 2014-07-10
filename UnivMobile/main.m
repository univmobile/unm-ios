//
//  main.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 03/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UNMAppDelegate.h"
#import "TestAppDelegate.h"

int main(int argc, char* argv[]) {
	
	@autoreleasepool {
		
        const BOOL RUNNING_TESTS = (NSClassFromString(@"XCTest") != nil);
		
        if (RUNNING_TESTS) {
			
            return UIApplicationMain(argc, argv, nil, @"TestsAppDelegate");
			
        } else {
			
			return UIApplicationMain(argc, argv, nil, NSStringFromClass([UNMAppDelegate class]));
        }
    }
}
