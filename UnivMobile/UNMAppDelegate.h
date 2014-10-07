//
//  UNMAppDelegate.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 03/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

@import UIKit;

@interface UNMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow* window;

@property (strong, nonatomic, readonly) UINavigationController* loginNavController;
@property (strong, nonatomic, readonly) UINavigationController* loginShibbolethNavController;
@property (strong, nonatomic, readonly) UINavigationController* loginClassicNavController;
@property (strong, nonatomic, readonly) UINavigationController* profileNavController;
@property (strong, nonatomic, readonly) UINavigationController* regionsNavController;
@property (strong, nonatomic, readonly) UINavigationController* poisNavController;

@end
