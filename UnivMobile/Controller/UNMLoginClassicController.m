//
//  UNMLoginClassicController.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 29/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMLoginClassicController.h"
#import "UNMConstants.h"
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import <EXTScope.h>
#import "UIBarButtonItem+UIAccessibility.h"

@interface UNMLoginClassicController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel* loginLabel;
@property (nonatomic, strong) UITextField* loginText;
@property (nonatomic, strong) UILabel* passwordLabel;
@property (nonatomic, strong) UITextField* passwordText;
@property (nonatomic, strong) UILabel* errorLabel;

@property (nonatomic, strong) UIButton* loginButton;

@end

@implementation UNMLoginClassicController

@synthesize appLayer = _appLayer;

@dynamic view;

static NSString* const API_KEY = @"UnivMobile-iOS-0.0.5";

- (instancetype)initWithAppLayer:(UNMAppLayer*)appLayer {
	
    self = [super init];
    
	if (self) {
		
		_appLayer = appLayer;
		
		[self.appLayer addCallback:self];
    }
    
	return self;
}

// Override: UIViewController
- (void) loadView {
	
	self.view = [[UIControl alloc] initWithFrame:UIScreen.mainScreen.applicationFrame];
}

// Override: UIViewController
- (void)viewDidLoad {

    [super viewDidLoad];
	
	// COLORS
	
	self.view.backgroundColor = [UNMConstants RGB_79b8d9];

	self.title = @"Identification standard";
	
	UIBarButtonItem* const rightBarButton = [[UIBarButtonItem alloc]
											 initWithTitle:@"Annuler"
											 style:UIBarButtonItemStyleBordered
											 target:nil
											 action:nil];
	rightBarButton.accessibilityIdentifier = @"button-cancel";
	
	self.navigationItem.rightBarButtonItem = rightBarButton;
	
	@weakify(self)
	
	rightBarButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
		
		@strongify(self)
		
		[self.appLayer goBackFromLoginClassic];
		
		return [RACSignal empty];
	}];

	// LABELS
	
	self.loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 80.0, 220.0, 60.0)];
	self.loginLabel.accessibilityIdentifier = @"label-loginClassic-login";
	self.loginLabel.text = @"e-mail ou uid";
	self.loginLabel.textColor = [UIColor whiteColor]; // [UNMConstants RGB_79b8d9];
	self.loginLabel.font = [UIFont systemFontOfSize:18];
	self.loginLabel.textAlignment = NSTextAlignmentCenter;
	
	[self.view addSubview:self.loginLabel];
	
	self.passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 170.0, 220.0, 60.0)];
	self.passwordLabel.accessibilityIdentifier = @"label-loginClassic-password";
	self.passwordLabel.text = @"mot de passe";
	self.passwordLabel.textColor = [UIColor whiteColor]; // [UNMConstants RGB_79b8d9];
	self.passwordLabel.font = [UIFont systemFontOfSize:18];
	self.passwordLabel.textAlignment = NSTextAlignmentCenter;
	
	[self.view addSubview:self.passwordLabel];

	self.errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 260.0, 220.0, 60.0)];
	self.errorLabel.accessibilityIdentifier = @"label-loginClassic-error";
	self.errorLabel.text = @"Erreur d’authentification";
	self.errorLabel.textColor = [UIColor redColor]; // [UNMConstants RGB_79b8d9];
	self.errorLabel.font = [UIFont systemFontOfSize:18];
	self.errorLabel.textAlignment = NSTextAlignmentCenter;
	self.errorLabel.hidden = YES;
	
	[self.view addSubview:self.errorLabel];

	// TEXT FIELDS
	
	self.loginText = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 130.0, 280.0, 30.0)];
	self.loginText.accessibilityIdentifier = @"text-loginClassic-login";
	self.loginText.textAlignment = NSTextAlignmentCenter;
	self.loginText.backgroundColor = [UIColor whiteColor];
	self.loginText.returnKeyType = UIReturnKeyDone;
	self.loginText.keyboardType = UIKeyboardTypeNamePhonePad;
	self.loginText.delegate = self;
	
	[self.view addSubview:self.loginText];
	
	self.passwordText = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 220.0, 280.0, 30.0)];
	self.passwordText.accessibilityIdentifier = @"text-loginClassic-password";
	self.passwordText.textAlignment = NSTextAlignmentCenter;
	self.passwordText.backgroundColor = [UIColor whiteColor];
	self.passwordText.returnKeyType = UIReturnKeyDone;
	self.loginText.keyboardType = UIKeyboardTypeNamePhonePad;
	self.passwordText.secureTextEntry = YES;
	self.passwordText.delegate = self;
	
	[self.view addSubview:self.passwordText];
	
	// BUTTON
	
	self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(50.0, 300.0, 220., 60.0)];
	
	self.loginButton.accessibilityIdentifier = @"button-login";
	
	[self.loginButton setTitle:@"Connexion" forState:UIControlStateNormal];
	
	[self.loginButton setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
	
	[self.view addSubview:self.loginButton];
	
	// @weakify(self)
	
	self.loginButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
		
		@strongify(self)
				
		// NSLog(@"click cxn");
		
		const BOOL success = [self.appLayer login:self.loginText.text password:self.passwordText.text apiKey:API_KEY];

		//NSLog(@"success?%d", success);
		
		if (!success) {
			
			self.passwordText.text = @"";
			
			self.errorLabel.hidden = NO;
			
		} else {
			
			// self.passwordText.text = @"";
			
			self.errorLabel.hidden = YES;
			
			[self.appLayer goFromLoginClassicToProfile];
		}

		//[self.appLayer goFromLoginToLoginClassic];
		
		return [RACSignal empty];
	}];

	// CLOSE ALL KEYBOARDS WHEN TAPPING OUTSIDE OF THEM

	[self.view addTarget:self
				  action:@selector(clearKeyboards)
		forControlEvents:UIControlEventTouchDown];
}

// Override
- (void)didReceiveMemoryWarning {
	
    [super didReceiveMemoryWarning];
}

// Override: UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField*) textField {
	
	[textField resignFirstResponder];
}

// Override: UITextFieldDelegate
- (BOOL) textFieldShouldReturn: (UITextField*) textField {
	
	[textField resignFirstResponder];
	
	return YES;
}

- (void)clearKeyboards {
	
	[self.loginText resignFirstResponder];
	[self.passwordText resignFirstResponder];
}

// Override: UNMAppViewCallback
- (void)callbackGoBackFromLoginClassic {
	
	[self clearKeyboards];
}

@end
