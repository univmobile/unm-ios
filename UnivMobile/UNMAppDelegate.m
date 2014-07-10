//
//  UNMAppDelegate.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 03/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMAppDelegate.h"
#import "UNMHomeController.h"
#import <TSMessage.h>
#import "UNMConstants.h"
#import "UNMRegionsController.h"
#import "UNMUniversitiesController.h"
#import "UNMDebug.h"
#import "UNMJsonFetcher.h"
#import "UNMJsonFetcherFileSystem.h"

@interface UNMAppDelegate ()

@property (strong, nonatomic, readonly) UNMAppLayer* appLayer;

@end

@implementation UNMAppDelegate

// Override: UIApplicationDelegate<NSObject>
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
	
//#if DEBUG
	
	// If tests are currently running, exit the method and do not create a rootViewController
//	if ([[[NSProcessInfo processInfo] processName] isEqualToString:@"xctest"] || getenv("RUNNING_TESTS")) {
		
//		return YES;
//	}
	
//#endif
	
	// APPLICATION LAYER
	
	NSObject <UNMJsonFetcher>* const jsonFetcher = [UNMJsonFetcherFileSystem new];
	
	_appLayer = [[UNMAppLayer alloc] initWithJsonFetcher:jsonFetcher];
	
	// NAVIGATION CONTROLLER
	
	UNMUniversitiesController* const universitiesController = [[UNMUniversitiesController alloc]
															   initWithAppLayer:_appLayer
															   style:UITableViewStylePlain];
	
	UNMRegionsController* const regionsController = [[UNMRegionsController alloc]
													 initWithAppLayer:_appLayer
													 style:UITableViewStylePlain
													 universitiesController:universitiesController];
	
	_navController = [[UINavigationController alloc]
						  initWithRootViewController:regionsController];
	
	// WINDOW
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
    self.window.rootViewController = [[UNMHomeController alloc] initWithAppLayer:_appLayer
																		 navView:self.navController.view
									  ];
	
	self.window.backgroundColor = [UNMConstants RGB_79b8d9]; // This background will show during animations
	
    [self.window makeKeyAndVisible];
	
	// TSMESSAGE
	
	[TSMessage setDefaultViewController:self.window.rootViewController];
    
	// END
	
	[UNMDebug debug_recursiveNSLogWithLabel:@"UNMAppDelegate" associationsForObject:self];
	
    return YES;
}

// Override
- (void)applicationWillResignActive:(UIApplication*) application {
	
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

// Override:
- (void)applicationDidEnterBackground:(UIApplication*)application {
	
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

// Override:
- (void)applicationWillEnterForeground:(UIApplication*)application {
	
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

// Override:
- (void)applicationDidBecomeActive:(UIApplication*)application {
	
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

// Override:
- (void)applicationWillTerminate:(UIApplication*)application {
	
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
