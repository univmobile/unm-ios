//
//  UNMLoginViewController.m
//  unm-ios
//
//  Created by UnivMobile on 1/13/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMLoginViewController.h"
#import "SSKeychain.h"
#import "AFNetworking.h"
#import "NSString+URLEncoding.h"
#import "UNMAuthDataBasic.h"
#import "UNMConstants.h"
#import "UNMUtilities.h"
#import "UNMUniversityBasic.h"

@interface UNMLoginViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *loginToken;
@property (strong, nonatomic) NSString *key;
@property (nonatomic) BOOL loginSuccess;
@end

@implementation UNMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.loginSuccess = NO;
    
    [[UNMUtilities manager].operationQueue cancelAllOperations];
    [[UNMUtilities mapManager].operationQueue cancelAllOperations];
    
    [self fetchLoginTokenWithBlock:^void(NSString *loginToken,NSString *key) {
        self.loginToken = loginToken;
        self.key = key;
        UNMUniversityBasic *univ = [UNMUniversityBasic getSavedObject];
        NSString* const target = [NSString stringWithFormat:
                                  @"%@?loginToken=%@&callback=%@.sso",
                                  kBaseURLStr,
                                  loginToken,
                                  [kSHIBBOLETH_CALLBACK urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        NSString* const ssoURL =
        [NSString stringWithFormat:@"%@Shibboleth.sso/Login?target=%@&entityID=%@",
                                     kBaseDomainUrlStr,
                                     [target urlEncodeUsingEncoding:NSUTF8StringEncoding],
                                     [[univ shibbolethUrl] urlEncodeUsingEncoding:NSUTF8StringEncoding]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:ssoURL]];
        [self.webView loadRequest:request];
    }];
}

- (void)fetchLoginTokenWithBlock:(void (^)(NSString*,NSString*))callback; {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @ {@"prepare":@"", @"apiKey":kAPI_KEY };
    
    [manager POST:kBaseLoginURLStr parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSString *loginToken = responseObject[@"loginToken"];
        NSString *key = responseObject[@"key"];
        if (loginToken.class != [NSNull class]) {
            callback(loginToken,key);
        }

    }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Echec de l'authentification"
                                                             message:@"Merci de réssayer plus tard"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
         [alertView show];
     }];
}

- (void)fetchAccessTokenWithBlock:(void (^)(NSString*))callback; {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @ {@"loginToken":self.loginToken,@"key":self.key, @"apiKey":kAPI_KEY };
    
    [manager POST:kBaseLoginURLStr parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *embeded = responseObject;
         if (embeded != nil) {
             NSString *accessToken = embeded[@"id"];
             if (accessToken != nil) {
                 UNMAuthDataBasic *auth = [[UNMAuthDataBasic alloc]initWithAccessToken:accessToken];
                 [auth saveToUserDefaults];
             }
             NSString *username = embeded[@"user"][@"displayName"];
             NSNumber *ID = embeded[@"user"][@"uid"];
             if (ID && username && [username class] != [NSNull class] && [ID class] != [NSNull class] ) {
                 [UNMUserBasic fetchUserWithID:ID success:^(UNMUserBasic *user) {
                     [user saveToUserDefaults];
                     if ([self.delegate respondsToSelector:@selector(updateNavBarWithUser:)]) {
                         [self.delegate updateNavBarWithUser:user];
                     }
                 } failure:^{
                 }];
             }
             [self.navigationController popViewControllerAnimated:YES];
         }
     }
          failure:
     ^(AFHTTPRequestOperation *operation, NSError *error) {
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Echec de l'authentification"
                                                             message:@"Merci de réssayer plus tard"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
         [alertView show];
     }];
}

- (void)loadCookie {
    NSString *cookieString = [SSKeychain passwordForService:kLoginService account:kAccountName];
    if (cookieString != nil) {
        NSData *cookieData = [cookieString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary *cookieProperties = [NSJSONSerialization JSONObjectWithData:cookieData options:NSJSONReadingMutableContainers error:&error];
        NSHTTPCookie* cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
        NSArray* cookieArray = [NSArray arrayWithObject:cookie];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookieArray forURL:[NSURL URLWithString:kBaseURLStr] mainDocumentURL:nil];
        NSLog(@"loaded cookie");
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (!self.loginSuccess) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Impossible d'afficher la page"
                                                            message:@"Merci de ressayer"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlString= [request.URL absoluteString];
    if([urlString hasPrefix:kSHIBBOLETH_CALLBACK]) {
        [self fetchAccessTokenWithBlock:^void(NSString *name){}];
        self.loginSuccess = YES;
        return NO;
    }
    return YES;
}

- (void)saveShibbolethCookie {
    NSArray* allCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in allCookies) {
        NSRange range = [cookie.name rangeOfString:@"_shibsession_"];
        if (range.length > 0) {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cookie.properties
                                                               options:0
                                                                 error:&error];
            if (jsonData != nil) {
                NSString *cookieString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
                [SSKeychain setPassword:cookieString forService:kLoginService account:kAccountName];
                NSLog(@"saved cookie");
            }
            
        }
    }
}



-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
