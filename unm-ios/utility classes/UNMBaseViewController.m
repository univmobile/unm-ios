//
//  UNMBaseViewController.m
//  unm-ios
//
//  Created by UnivMobile on 1/19/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMBaseViewController.h"
#import "MFSideMenu.h"
#import "UNMAppDelegate.h"
#import "UIBarButtonItem+Badge.h"
#import "UNMUserBasic.h"
#import "UNMUtilities.h"
#import <AFNetworking.h>
#import "NSString+URLEncoding.h"
#import "UNMUniversityBasic.h"
#import "NSDate+notificationDate.h"
#import "UNMConstants.h"
#import "UIColor+Extension.h"
#import "UNMLoginClassicViewController.h"
#import "UNMLoginViewController.h"

@interface UNMBaseViewController ()
@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UIButton *universityButton;
@property (strong, nonatomic) UIBarButtonItem *notificationsBadge;
@end

@implementation UNMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Retour"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:nil
                                                                action:nil];
    
    [self.navigationItem setBackBarButtonItem:backItem];
    [self createNavBarButtons];
    [self createNavBarButtonItems];
    [self setTintColor];
    [self updateNotifBadge];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)setTintColor {
    UINavigationBar *bar = [self.navigationController navigationBar];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [bar setBarTintColor:[UIColor navBarPurple]];
        [bar setTintColor:[UIColor whiteColor]];
    }
}

- (void)updateNotifBadge {
    [self getNotificationCountWithCallBack:^(NSInteger count){
        self.notificationsBadge.badgeValue = [NSString stringWithFormat: @"%ld", (long)count];
    }];
    [self performSelector:@selector(updateNotifBadge) withObject:nil afterDelay:5*60];
}

- (void)getNotificationCountWithCallBack:(void(^)(NSInteger))callback {
    NSNumber *univId = [[UNMUniversityBasic getSavedObject] univId];
    NSDate *lastLoadDate = [NSDate getSavedNotificationDate];
    
    NSString *iso8601String = [lastLoadDate isoDateString];
    
    NSString *path;
    if (lastLoadDate == nil) {
        path = [NSString stringWithFormat:@"notifications/search/findNotificationsForUniversity\?universityId=%d",[univId intValue]];
    } else {
        path = [NSString stringWithFormat:@"notifications/search/findNotificationsForUniversitySince\?universityId=%d&since=%@",[univId intValue],[iso8601String urlEncodeUsingEncoding:NSUTF8StringEncoding]];
    }

    [self fetchNotificationsWithCount:0 andCallback:callback andPath:path];
}

- (void)fetchNotificationsWithCount:(NSInteger)count andCallback:(void(^)(NSInteger))callback andPath:(NSString *)path {
    __block NSInteger notifCount = count;
    [UNMUtilities fetchFromApiWithPath:path success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *embedded = responseObject[@"_embedded"];
        NSDictionary *links = responseObject[@"_links"];
        if (embedded != nil) {
            NSArray *notifArray = embedded[@"notifications"];
            notifCount += [notifArray count];
            if (links != nil) {
                NSString *nextUrlPath = links[@"next"][@"href"];
                if (nextUrlPath != nil) {
                    nextUrlPath = [nextUrlPath stringByReplacingOccurrencesOfString:kBaseApiURLStr withString:@""];
                    [self fetchNotificationsWithCount:notifCount andCallback:callback andPath:[nextUrlPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                } else {
                    callback(notifCount);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        //do nothing
    }];
}

- (void)setLoginButtonTitleWithName:(NSString *)name {
    if (name) {
        [self.loginButton setTitle:[NSString stringWithFormat:@"Bonjour %@",name] forState:UIControlStateNormal];
        [self.loginButton removeTarget:self action:@selector(didSelectLogin) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setUniversityTitleWithName:(NSString *)name {
    if (name) {
        [self.universityButton setTitle:name forState:UIControlStateNormal];
    }
}

- (void) createNavBarButtonItems {
    UIBarButtonItem *menu = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menuIconNavBar"] style:UIBarButtonItemStylePlain target:self action:@selector(menuSelected)];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        menu.tintColor = [UIColor whiteColor];
    }
    
    UIImage *image = [UIImage imageNamed:@"bellIcon"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,0,image.size.width, image.size.height);
    [button addTarget:self action:@selector(notificationsSelected) forControlEvents:UIControlEventTouchDown];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    self.notificationsBadge = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.notificationsBadge.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = menu;
    self.navigationItem.rightBarButtonItem = self.notificationsBadge;
}

- (void) menuSelected {
    [self.menuContainerViewController setMenuState:MFSideMenuStateLeftMenuOpen completion:^{}];
}

- (void)notificationsSelected {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UITableViewController *destNav = [self.storyboard instantiateViewControllerWithIdentifier:@"notifController"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:destNav animated:YES];
            self.notificationsBadge.badgeValue = nil;
        });
    });

}

- (void)didSelectLogin {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UNMUniversityBasic *univ = [UNMUniversityBasic getSavedObject];
        UIViewController *destNav;
        if (univ.shibbolethUrl && [univ.shibbolethUrl class] != [NSNull class]) {
            destNav = [self.storyboard instantiateViewControllerWithIdentifier:@"loginController"];
            ((UNMLoginViewController *)destNav).delegate = self;
        } else {
            destNav = [self.storyboard instantiateViewControllerWithIdentifier:@"loginClassicController"];
            ((UNMLoginClassicViewController *)destNav).delegate = self;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:destNav animated:YES];
        });
    });
    
}

- (void)didSelectUniversity {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UNMAppDelegate *appDelegate = (UNMAppDelegate *)[[UIApplication sharedApplication] delegate];
        UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"startingNavController"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView transitionWithView:self.view.window
                              duration:0.5
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^{ [appDelegate.container setCenterViewController:navController]; }
                            completion:nil];
            
        });
    });
}

- (UIButton *)createNavBarButtonButtonWithTitle:(NSString *)title font:(UIFont *)font andSelector:(SEL)selector {
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navButton setTitle:title forState:UIControlStateNormal];
    [navButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [navButton setTintColor:[UIColor whiteColor]];
    }
    if (selector != nil) {
        [navButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        [navButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    } else { //no selector == not a button == shouldn't hightlight when pressed
        [navButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted];
    }
    navButton.titleLabel.font = font;
    [navButton.titleLabel setMinimumScaleFactor:0.5f];
    navButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    navButton.titleLabel.numberOfLines = 0;
    navButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    navButton.translatesAutoresizingMaskIntoConstraints = NO;
    navButton.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    navButton.titleLabel.textColor = [UIColor blackColor];
    [navButton.titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [navButton.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    NSDictionary *viewsDictionary = @{@"label":navButton.titleLabel};
    
    NSArray *constraint_Vert = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:viewsDictionary];
    
    NSArray *constraint_Horz = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:viewsDictionary];
    
    [navButton addConstraints:constraint_Vert];
    [navButton addConstraints:constraint_Horz];
    
    [navButton updateConstraints];
    
    return navButton;
}

- (UIView *)createContainerWithButton:(UIButton *)button {
    UIView *buttonContainer = [UIView new];
    buttonContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [buttonContainer addSubview:button];
    
    // Center Vertically
    NSLayoutConstraint *centerYConstraintLogin =
    [NSLayoutConstraint constraintWithItem:button
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:buttonContainer
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0
                                  constant:0.0];
    [buttonContainer addConstraint:centerYConstraintLogin];
    
    // Center Horizontally
    NSLayoutConstraint *centerXConstraintLogin =
    [NSLayoutConstraint constraintWithItem:button
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:buttonContainer
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0.0];
    [buttonContainer addConstraint:centerXConstraintLogin];
    
    NSDictionary *viewsDictionary = @{@"button":button};
    
    NSArray *constraint_Vert = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:viewsDictionary];
    
    NSArray *constraint_Horz = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:viewsDictionary];
    
    [buttonContainer addConstraints:constraint_Vert];
    [buttonContainer addConstraints:constraint_Horz];
    
    [buttonContainer updateConstraints];
    
    return buttonContainer;
}

- (void)createNavBarButtons {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    [titleView setContentMode:UIViewContentModeScaleAspectFit];
    
    UNMUserBasic *user = [UNMUserBasic getSavedObject];
    NSString *name;
    if (user != nil) {
        name = user.username;
    }
    if (name == nil) {
        self.loginButton = [self createNavBarButtonButtonWithTitle:@"Connectez-vous" font:[UIFont fontWithName:@"Exo-Medium" size:12.0] andSelector:@selector(didSelectLogin)];
    } else {
        self.loginButton = [self createNavBarButtonButtonWithTitle:[NSString stringWithFormat:@"Bonjour %@",name] font:[UIFont fontWithName:@"Exo-Medium" size:12.0] andSelector:nil];
    }
    
    SEL selector = @selector(didSelectUniversity);
    NSString *university = [UNMUniversityBasic getSavedObject].title;
    if (university == nil) {
        self.universityButton = [self createNavBarButtonButtonWithTitle:@"Sélectionner université" font:[UIFont fontWithName:@"Exo-Thin" size:12.0] andSelector:selector];
    } else {
        self.universityButton = [self createNavBarButtonButtonWithTitle:university font:[UIFont fontWithName:@"Exo-Medium" size:12.0] andSelector:selector];
    }
    
    UIView *loginButtonContainer = [self createContainerWithButton: self.loginButton];
    UIView *universityButtonContainer = [self createContainerWithButton: self.universityButton];
    [titleView addSubview:loginButtonContainer];
    [titleView addSubview:universityButtonContainer];
    UIView *separator = [UIView new];
    separator.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    separator.translatesAutoresizingMaskIntoConstraints = NO;
    [titleView addSubview:separator];
    
    NSDictionary *viewsDictionary = @{@"loginButton":loginButtonContainer,@"univButton":universityButtonContainer,@"separator":separator};
    
    NSArray *constraint_Hor = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[loginButton(==univButton)][separator(1)][univButton]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsDictionary];
    
    NSArray *constraint_VertName = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[loginButton]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:viewsDictionary];
    NSArray *constraint_VertSep = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[separator]-5-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:viewsDictionary];
    
    NSArray *constraint_VertUniv = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[univButton]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:viewsDictionary];
    
    [titleView addConstraints:constraint_Hor];
    [titleView addConstraints:constraint_VertName];
    [titleView addConstraints:constraint_VertSep];
    [titleView addConstraints:constraint_VertUniv];
    
    [titleView updateConstraints];
    self.navigationItem.titleView = titleView;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    if (self.navigationController.navigationBarHidden) {
        return UIStatusBarStyleBlackTranslucent;
    }
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateNavBarWithUser:(UNMUserBasic *)user {
    [self setLoginButtonTitleWithName:user.username];
}

@end
