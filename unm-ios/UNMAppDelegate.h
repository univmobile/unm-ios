//
//  AppDelegate.h
//  unm-ios
//
//  Created by UnivMobile on 1/12/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MFSideMenu.h"

@interface UNMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) MFSideMenuContainerViewController *container;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

