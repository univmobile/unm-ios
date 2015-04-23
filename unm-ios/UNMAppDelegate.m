//
//  AppDelegate.m
//  unm-ios
//
//  Created by UnivMobile on 1/12/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMAppDelegate.h"
#import "UNMRegionBasic.h"
#import "UNMUniversityBasic.h"
#import <GoogleMaps/GoogleMaps.h>
#import "UNMUtilities.h"
#import "UNMConstants.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface UNMAppDelegate ()
@end

@implementation UNMAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GMSServices provideAPIKey:kGoogleMapsApiKey];
    [Fabric with:@[CrashlyticsKit]];
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:50 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    id univ = [UNMUniversityBasic getSavedObject];
    id region = [UNMRegionBasic getSavedObject];
    UINavigationController *navController;
    if (univ && region) {
        navController = [[UINavigationController alloc]initWithRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"home"]];
        [univ postAsUsageStat];
    } else {
        navController = [storyboard instantiateViewControllerWithIdentifier:@"startingNavController"];
    }
    UIViewController *sideMenu = [storyboard instantiateViewControllerWithIdentifier:@"sideMenu"];
    self.container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:navController
                                                    leftMenuViewController:sideMenu
                                                    rightMenuViewController:nil];
    self.container.panMode = MFSideMenuPanModeNone;
    self.window.rootViewController = self.container;
    [self.window makeKeyAndVisible];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    return YES;
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSDictionary *dict = [UNMUtilities parseQueryString:[url query]];
    NSString *ID = dict[@"im"];
    NSNumber *selectedID = [NSNumber numberWithInt:[[dict valueForKey:@"poi"] intValue]];
    if (ID != nil && ![ID isEqualToString:@"null"]) {
        [UNMUtilities setCenterControllerToImageMapWithPath:[NSString stringWithFormat:@"imageMaps/%d",[ID intValue]] andSelectedID:selectedID];
    } else {
        [UNMUtilities showErrorWithTitle:@"Impossible d'ouvrir le QR code" andMessage:@"Le QR code n'est pas valide" andDelegate:nil];
    }
    return YES;
}



#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.univmobile.unm_ios" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"unm_ios" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"unm_ios.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}

@end
