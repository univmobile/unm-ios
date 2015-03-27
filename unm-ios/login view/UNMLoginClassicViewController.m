//
//  UNMLoginClassicViewController.m
//  unm-ios
//
//  Created by UnivMobile on 2/20/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMLoginClassicViewController.h"
#import "AFNetworking.h"
#import "UNMConstants.h"
#import "UNMAuthDataBasic.h"
#import "UNMUserBasic.h"
#import "UNMUtilities.h"

@interface UNMLoginClassicViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoHeightConst;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollVIew;
@end

@implementation UNMLoginClassicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgSideMenu"]];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat viewHeight = self.view.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height;
    self.logoHeightConst.constant = viewHeight - 224;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat keyboardHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey ] CGRectValue].size.height;
    self.scrollVIew.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.scrollVIew.contentInset = UIEdgeInsetsZero;
}

- (IBAction)login:(id)sender {
    if (self.nameField.text.length > 0 && self.passwordField.text.length > 0) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params = @{ @"login"     : self.nameField.text,
                                  @"password"  : self.passwordField.text,
                                  @"apiKey"    : kLoginClassicApiKey
                                  };
        
        [manager POST:kBaseLoginURLStr parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSString *authToken = responseObject[@"id"];
             if (authToken && [authToken class] != [NSNull class]) {
                 UNMAuthDataBasic *authData = [[UNMAuthDataBasic alloc]initWithAccessToken:authToken];
                 [authData saveToUserDefaults];
             }
             NSString *username = responseObject[@"user"][@"displayName"];
             NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
             f.numberStyle = NSNumberFormatterDecimalStyle;
             NSNumber *ID = [f numberFromString:responseObject[@"user"][@"uid"]];
             if (username && ID && [username class] != [NSNull class] && [ID class] != [NSNull class]) {
                 [UNMUserBasic fetchUserWithID:ID success:^(UNMUserBasic *user) {
                     [user saveToUserDefaults];
                     if ([self.delegate respondsToSelector:@selector(updateNavBarWithUser:)]) {
                         [self.delegate updateNavBarWithUser:user];
                     }
                 } failure:^{
                     
                 }];
             } else {
                 [UNMUtilities showErrorWithTitle:@"L'authentification a échoué" andMessage:@"Mauvais nom d'utilisateur / mot de passe" andDelegate:nil];
             }
             [self.navigationController popViewControllerAnimated:YES];
         }
              failure:
         ^(AFHTTPRequestOperation *operation, NSError *error) {
             [UNMUtilities showErrorWithTitle:@"L'authentification a échoué" andMessage:[error localizedDescription] andDelegate:nil];
             [self.navigationController popViewControllerAnimated:YES];
         }];
    }
    else {
        [UNMUtilities showErrorWithTitle:@"L'authentification a échoué" andMessage:@"Mauvais nom d'utilisateur / mot de passe" andDelegate:nil];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark uitextfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameField) {
        [self.passwordField becomeFirstResponder];
    }
    else if (textField == self.passwordField) {
        [self.passwordField resignFirstResponder];
        [self login:nil];
    }
    return true;
}

@end
