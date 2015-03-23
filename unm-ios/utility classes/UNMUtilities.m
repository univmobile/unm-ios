//
//  UNMUtilities.m
//  unm-ios
//
//  Created by UnivMobile on 1/26/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMUtilities.h"
#import "UNMAppDelegate.h"
#import "UNMConstants.h"
#import "UNMMapViewController.h"
#import "UNMAuthDataBasic.h"
#import "UNMGeneralWebViewController.h"

@implementation UNMUtilities
static AFHTTPRequestOperationManager *manager;
static AFHTTPRequestOperationManager *mapManager;
static AFHTTPRequestOperationManager *postManager;

+ (AFHTTPRequestOperationManager *)manager {
    if (manager == nil) {
        manager = [AFHTTPRequestOperationManager manager];
    }
    return manager;
}

+ (AFHTTPRequestOperationManager *)postManager {
    if (postManager == nil) {
        postManager = [AFHTTPRequestOperationManager manager];
    }
    return postManager;
}

+ (void)setManager:(AFHTTPRequestOperationManager *)newManager {
    manager = newManager;
}

+ (AFHTTPRequestOperationManager *)mapManager {
    return mapManager;
}

+ (void)setMapManager:(AFHTTPRequestOperationManager *)newMapManager {
    mapManager = newMapManager;
}


+ (UIStoryboard *)storyboard {
    return [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
}

+ (UNMAppDelegate *)appDelegate {
    return [[UIApplication sharedApplication] delegate];
}

+ (void)setCenterControllerWithNavControllerIdentifier:(NSString *)navIdentifier {
    UIStoryboard *storyboard = [self storyboard];
    UNMAppDelegate *appDelegate = [self appDelegate];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UINavigationController *destNav = [storyboard instantiateViewControllerWithIdentifier:navIdentifier];
        id vc = [[destNav viewControllers] lastObject];
        id currentVc = appDelegate.container.centerViewController;
        if ([currentVc isMemberOfClass:[UINavigationController class]]) {
            id currentRootVC = [[(UINavigationController *)currentVc viewControllers] lastObject];
            if (currentRootVC == nil || [vc isMemberOfClass:[currentRootVC class]]){
                return; //trying to push the same view or nil
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [appDelegate.container setCenterViewController:destNav];
                });
            }
        }
    });
    [appDelegate.container setMenuState:MFSideMenuStateClosed completion:^{}];
}

+ (void)setCenterControllerToImageMapWithPath:(NSString *)Path {
    UIStoryboard *storyboard = [self storyboard];
    UNMAppDelegate *appDelegate = [self appDelegate];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UINavigationController *destNav = [storyboard instantiateViewControllerWithIdentifier:@"mapViewController"];
        UNMMapViewController *vc = [[destNav viewControllers] lastObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (Path != nil) {
                vc.imageMapPath = Path;
            }
            [appDelegate.container setCenterViewController:destNav];
        });
    });
    [appDelegate.container setMenuState:MFSideMenuStateClosed completion:^{}];
}

+ (void)setCenterControllerToMapWithSingleItem:(UNMMapItemBasic *)item andTabSelected:(UNMMapTabs)tab {
    UIStoryboard *storyboard = [self storyboard];
    UNMAppDelegate *appDelegate = [self appDelegate];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UINavigationController *destNav = [storyboard instantiateViewControllerWithIdentifier:@"mapViewController"];
        UNMMapViewController *vc = [[destNav viewControllers] lastObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (item != nil) {
                vc.singleItem = item;
                vc.TabSelected = tab;
            }
            [appDelegate.container setCenterViewController:destNav];
        });
    });
    [appDelegate.container setMenuState:MFSideMenuStateClosed completion:^{}];
}

+ (void)setCenterControllerToMapWithCategoryID:(NSNumber *)catID {
    UIStoryboard *storyboard = [self storyboard];
    UNMAppDelegate *appDelegate = [self appDelegate];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UINavigationController *destNav = [storyboard instantiateViewControllerWithIdentifier:@"mapViewController"];
        UNMMapViewController *vc = [[destNav viewControllers] lastObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (catID) {
                vc.preselectedCategoryID = catID;
            }
            [appDelegate.container setCenterViewController:destNav];
        });
    });
    [appDelegate.container setMenuState:MFSideMenuStateClosed completion:^{}];
}

+ (void)setCenterControllerToMapWithTabSelected:(UNMMapTabs)tab {
    UIStoryboard *storyboard = [self storyboard];
    UNMAppDelegate *appDelegate = [self appDelegate];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UINavigationController *destNav = [storyboard instantiateViewControllerWithIdentifier:@"mapViewController"];
        UNMMapViewController *vc = [[destNav viewControllers] lastObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            vc.TabSelected = tab;
            [appDelegate.container setCenterViewController:destNav];
        });
    });
    [appDelegate.container setMenuState:MFSideMenuStateClosed completion:^{}];
}

+ (void)setCenterControllerToWebViewWithURL:(NSString *)urlStr andContent:(NSString *)content {
    UIStoryboard *storyboard = [self storyboard];
    UNMAppDelegate *appDelegate = [self appDelegate];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UINavigationController *destNav = [storyboard instantiateViewControllerWithIdentifier:@"webviewNav"];
        UNMGeneralWebViewController *vc = [[destNav viewControllers] lastObject];
        NSURL *url = [NSURL URLWithString:urlStr];
        vc.url = url;
        vc.htmlData = content;
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate.container setCenterViewController:destNav];
        });
    });
    [appDelegate.container setMenuState:MFSideMenuStateClosed completion:^{}];
}

+ (void)setCenterControllerToMapIgnoreCurrent {
    [self setCenterControllerToImageMapWithPath:nil];
}

+ (void)setCenterControllerWithNavController:(UINavigationController *)destNav {
    UNMAppDelegate *appDelegate = [self appDelegate];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        id vc = [[destNav viewControllers] lastObject];
        id currentVc = appDelegate.container.centerViewController;
        if ([currentVc isMemberOfClass:[UINavigationController class]]) {
            id currentRootVC = [[(UINavigationController *)currentVc viewControllers] lastObject];
            if (currentRootVC == nil || [vc isMemberOfClass:[currentRootVC class]]){
                return; //trying to push the same view or nil
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [appDelegate.container setCenterViewController:destNav];
                });
            }
        }
    });
    [appDelegate.container setMenuState:MFSideMenuStateClosed completion:^{}];
}

+ (void)setCenterControllerWithViewControllerIdentifier:(NSString *)vcIdentifier {
    UIStoryboard *storyboard = [self storyboard];
    UNMAppDelegate *appDelegate = [self appDelegate];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIViewController *destNav = [storyboard instantiateViewControllerWithIdentifier:vcIdentifier];
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:destNav];
        UINavigationController *currentNavVC = [appDelegate.container centerViewController];
        if (currentNavVC != nil) {
            UIViewController *currentRootVC = [[currentNavVC viewControllers] lastObject];
            if (currentRootVC == nil || [currentRootVC isMemberOfClass:[destNav class]]) {
                return;
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [appDelegate.container setCenterViewController:navController];
                });
            }
        }
        
    });
    [appDelegate.container setMenuState:MFSideMenuStateClosed completion:^{}];
}

+ (void)setCenterControllerWithViewControllerIdentifier:(NSString *)vcIdentifier andCallback:(void (^)())callback {
    UIStoryboard *storyboard = [self storyboard];
    UNMAppDelegate *appDelegate = [self appDelegate];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIViewController *destNav = [storyboard instantiateViewControllerWithIdentifier:vcIdentifier];
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:destNav];
        UINavigationController *currentNavVC = [appDelegate.container centerViewController];
        if (currentNavVC != nil) {
            UIViewController *currentRootVC = [[currentNavVC viewControllers] lastObject];
            if (currentRootVC == nil || [currentRootVC isMemberOfClass:[destNav class]]) {
                return;
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [appDelegate.container setCenterViewController:navController];
                    callback();
                });
            }
        }
        
    });
    [appDelegate.container setMenuState:MFSideMenuStateClosed completion:^{}];
}

+ (void)fetchFromOldApiWithPath:(NSString *)path success:(void(^)(AFHTTPRequestOperation*,id))success failure:(void(^)(AFHTTPRequestOperation*,NSError*))failure {
    [self manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json",@"application/json",nil];
    [manager GET:[kTempURLStr stringByAppendingString:path] parameters:nil success:success failure:failure];
}

+ (void)fetchFromApiWithPath:(NSString *)path success:(void(^)(AFHTTPRequestOperation*,id))success failure:(void(^)(AFHTTPRequestOperation*,NSError*))failure {
    [self manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json",@"application/json",nil];
    NSString *url = [kBaseApiURLStr stringByAppendingString:path];
    UNMAuthDataBasic *auth = [UNMAuthDataBasic getSavedObject];
    if (auth) {
        [manager.requestSerializer setValue:auth.accessToken forHTTPHeaderField:@"Authentication-Token"];
    }
    
    [manager GET:url parameters:nil success:success failure:failure];
}

+ (void)fetchImageFromApiWithPath:(NSString *)path success:(void(^)(AFHTTPRequestOperation*,id))success failure:(void(^)(AFHTTPRequestOperation*,NSError*))failure {
    [self manager];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    NSString *url = [kBaseApiURLStr stringByAppendingString:path];
    UNMAuthDataBasic *auth = [UNMAuthDataBasic getSavedObject];
    if (auth) {
        [manager.requestSerializer setValue:auth.accessToken forHTTPHeaderField:@"Authentication-Token"];
    }
    
    [manager GET:url parameters:nil success:success failure:failure];
}



+ (void)fetchFromBackendWithPath:(NSString *)path success:(void(^)(AFHTTPRequestOperation*,id))success failure:(void(^)(AFHTTPRequestOperation*,NSError*))failure {
    [self manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json",@"application/json",nil];
    NSString *url = [kBaseURLStr stringByAppendingString:path];
    UNMAuthDataBasic *auth = [UNMAuthDataBasic getSavedObject];
    if (auth) {
        [manager.requestSerializer setValue:auth.accessToken forHTTPHeaderField:@"Authentication-Token"];
    }
    
    [manager GET:url parameters:nil success:success failure:failure];
}


+ (void)fetchFromApiForMapWithPath:(NSString *)path success:(void(^)(AFHTTPRequestOperation*,id))success failure:(void(^)(AFHTTPRequestOperation*,NSError*))failure {
    if (mapManager == nil) {
        mapManager = [AFHTTPRequestOperationManager manager];
    }
    mapManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/hal+json",@"application/json",nil];
    NSString *url = [kBaseApiURLStr stringByAppendingString:path];
    UNMAuthDataBasic *auth = [UNMAuthDataBasic getSavedObject];
    if (auth) {
        [mapManager.requestSerializer setValue:auth.accessToken forHTTPHeaderField:@"Authentication-Token"];
    }
    [mapManager GET:url parameters:nil success:success failure:failure];
}

+ (void)postToApiWithPath:(NSString *)path andParams:(NSDictionary *)params success:(void(^)(AFHTTPRequestOperation*,id))success failure:(void(^)(AFHTTPRequestOperation*,NSError*))failure {
    [self postManager];
    UNMAuthDataBasic *auth = [UNMAuthDataBasic getSavedObject];
    if (auth && auth.accessToken && [auth class] != [NSNull class] && [auth.accessToken class] != [NSNull class]) {
        [postManager.requestSerializer setValue:auth.accessToken forHTTPHeaderField:@"Authentication-Token"];
        [self postToApiNoAuthWithPath:path andParams:params success:success failure:failure];
    } else {
        [self showErrorWithTitle:@"Merci de vous connecter" andMessage:@"Merci de cliquer sur le lien \"connectez-vous\" dans le haut de page" andDelegate:nil];
    }
}

+ (void)postToApiNoAuthWithPath:(NSString *)path andParams:(NSDictionary *)params success:(void(^)(AFHTTPRequestOperation*,id))success failure:(void(^)(AFHTTPRequestOperation*,NSError*))failure {
    [self postManager];
    postManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"application/json",nil];
    postManager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *url = [kBaseApiURLStr stringByAppendingString:path];
    [postManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postManager POST:url parameters:params success:success failure:failure];
}

+ (void)deleteToApiWithPath:(NSString *)path andParams:(NSDictionary *)params success:(void(^)(AFHTTPRequestOperation*,id))success failure:(void(^)(AFHTTPRequestOperation*,NSError*))failure {
    [self postManager];
    postManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"application/json",nil];
    postManager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *url = [kBaseApiURLStr stringByAppendingString:path];
    UNMAuthDataBasic *auth = [UNMAuthDataBasic getSavedObject];
    if (auth && auth.accessToken && [auth class] != [NSNull class] && [auth.accessToken class] != [NSNull class]) {
        [postManager.requestSerializer setValue:auth.accessToken forHTTPHeaderField:@"Authentication-Token"];
        [postManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [postManager DELETE:url parameters:params success:success failure:failure];
    } else {
        [self showErrorWithTitle:@"Merci de vous connecter" andMessage:@"Merci de cliquer sur le lien \"connectez-vous\" dans le haut de page" andDelegate:nil];
    }
}

+ (void)showErrorWithTitle:(NSString *)title andMessage:(NSString *)message andDelegate:(id<UIAlertViewDelegate>)delegate {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:delegate
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

+ (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSArray *baseAndParams = [query componentsSeparatedByString:@"?"];
    query = [baseAndParams lastObject];
    for (NSString *param in [query componentsSeparatedByString:@"&"]) {
        NSArray *parts = [param componentsSeparatedByString:@"="];
        if([parts count] < 2) continue;
        [params setObject:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]];
    }
    return params;
}

+ (UIView *)initActivityIndicatorContainerWithParentView:(UIView *)view aboveSubview:(UIView *)subview {
    UIView *activityIndicatorView = [UIView new];
    activityIndicatorView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    activityIndicatorView.layer.cornerRadius = 5.0;
    activityIndicatorView.clipsToBounds = YES;
    activityIndicatorView.frame = CGRectMake(CGRectGetWidth(view.frame)/2-20, CGRectGetHeight(view.frame)/2-20, 40, 40);
    UIActivityIndicatorView *activityIndicator = [UIActivityIndicatorView new];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator setColor:[UIColor whiteColor]];
    activityIndicator.frame = CGRectMake(2.5, 2.5, 35, 35);
    [activityIndicatorView addSubview:activityIndicator];
    if (subview) {
        [view insertSubview:activityIndicatorView aboveSubview:subview];
    } else {
        [view addSubview:activityIndicatorView];
    }
    [activityIndicator startAnimating];
    return activityIndicatorView;
}
@end
