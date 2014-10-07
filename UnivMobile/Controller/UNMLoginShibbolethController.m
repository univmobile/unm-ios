//
//  UNMLoginShibbolethController.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 07/10/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMLoginShibbolethController.h"
#import "UNMConstants.h"
#import "UIBarButtonItem+UIAccessibility.h"
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import <EXTScope.h>
#import "UNMLayout.h"

@interface UNMLoginShibbolethController ()

@property (nonatomic, strong) UIWebView* webView;

@end

@implementation UNMLoginShibbolethController

@synthesize appLayer = _appLayer;

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
- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	// COLORS
	
	self.view.backgroundColor = [UNMConstants RGB_79b8d9];
	
	self.title = @"Sécurité Shibboleth";
	
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
		
		[self.appLayer goBackFromLoginShibboleth];
		
		return [RACSignal empty];
	}];
	
	// WEB VIEW
	
	self.webView = [UNMLayout addLayout:@"webView" toViewController:self];

//	NSURL* const url = [NSURL URLWithString://@"http://apple.com/"];
//						@"https://univmobile-dev.univ-paris1.fr/testSP/"];

//	NSURLRequest* const request=[NSURLRequest requestWithURL:url
//												 cachePolicy:NSURLRequestUseProtocolCachePolicy
//											 timeoutInterval:10.0];

//	NSLog(@"sup:%@", self.webView.superview);
//	[self.webView loadRequest:request];
	
	// LABELS
	
	//self.loginLabel = [UNMLayout addLayout:@"loginLabel" toViewController:self];
	//self.passwordLabel = [UNMLayout addLayout:@"passwordLabel" toViewController:self];
	//self.errorLabel = [UNMLayout addLayout:@"errorLabel" toViewController:self];
	
	// TEXT FIELDS
	
	//self.loginText = [UNMLayout addLayout:@"loginText" toViewController:self];
	//self.loginText.delegate = self;
	
	//self.passwordText = [UNMLayout addLayout:@"passwordText" toViewController:self];
	//self.passwordText.delegate = self;
	
	// BUTTON
	
	//self.loginButton = [UNMLayout addLayout:@"loginButton" toViewController:self];
	
	// @weakify(self)
	
	// CLOSE ALL KEYBOARDS WHEN TAPPING OUTSIDE OF THEM
	
//	[self.view addTarget:self
//				  action:@selector(clearKeyboards)
//		forControlEvents:UIControlEventTouchDown];
}

// Override: UNMAppViewCallback
- (void)callbackGoFromLoginToLoginShibboleth {
	
	if (self.appLayer.selectedUniversityId) {
		
		UNMUniversityData* const universityData =
			[self.appLayer.regionsData universityDataById:self.appLayer.selectedUniversityId];
		
		if (universityData && universityData.shibbolethIdentityProvider) {

			NSString* const shibbolethIdentityProvider = universityData.shibbolethIdentityProvider;
			
			NSLog(@"shibbolethIdentityProvider: %@", shibbolethIdentityProvider);
		}
	}
}

@end