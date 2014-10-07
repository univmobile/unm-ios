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
#import "UNMLayout.h"

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
	
	self.loginLabel = [UNMLayout addLayout:@"loginLabel" toViewController:self];
	self.passwordLabel = [UNMLayout addLayout:@"passwordLabel" toViewController:self];
	self.errorLabel = [UNMLayout addLayout:@"errorLabel" toViewController:self];

	// TEXT FIELDS
	
	self.loginText = [UNMLayout addLayout:@"loginText" toViewController:self];
	self.loginText.delegate = self;

	self.passwordText = [UNMLayout addLayout:@"passwordText" toViewController:self];
	self.passwordText.delegate = self;
	
	// BUTTON
	
	self.loginButton = [UNMLayout addLayout:@"loginButton" toViewController:self];
	
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
