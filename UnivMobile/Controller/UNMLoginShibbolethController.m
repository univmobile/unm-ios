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
#import "UNMUtils.h"

@interface UNMLoginShibbolethController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView* webView;

@property (nonatomic, strong) UNMLoginConversation* conversation;

@end

@implementation UNMLoginShibbolethController

@synthesize appLayer = _appLayer;

static NSString* const API_KEY = @"UnivMobile-iOS-0.0.5";

static NSString* const SHIBBOLETH_CALLBACK = @"https://univmobile-dev.univ-paris1.fr/testSP/success";

- (instancetype)initWithAppLayer:(UNMAppLayer*)appLayer {
	
    self = [super init];
    
	if (self) {
		
		_appLayer = appLayer;
		
		[self.appLayer addCallback:self];
    }
    
	return self;
}

// Override: UIViewController
//- (void) loadView {
//
//	self.view = [[UIControl alloc] initWithFrame:UIScreen.mainScreen.applicationFrame];
//}

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
	
	self.webView.delegate = self;
}

// Override: UNMAppViewCallback
- (void)callbackGoFromLoginToLoginShibboleth {
	
	self.conversation = [self.appLayer prepareSession:API_KEY];
	
	UNMUniversityData* const universityData =
	[self.appLayer.regionsData universityDataById:self.appLayer.selectedUniversityId];
	
	NSString* const shibbolethIdentityProvider = universityData.shibbolethIdentityProvider;
	
	NSLog(@"shibbolethIdentityProvider: %@", shibbolethIdentityProvider);
	
	NSString* const callbackURL = SHIBBOLETH_CALLBACK;;
	
	NSString* const target = [NSString stringWithFormat:
							  @"https://univmobile-dev.univ-paris1.fr/testSP/?loginToken=%@&callback=%@",
							  self.conversation.loginToken,
							  [UNMUtils urlEncode:callbackURL]];

	NSString* const ssoURL =
	[NSString stringWithFormat:@"https://univmobile-dev.univ-paris1.fr/Shibboleth.sso/Login?target=%@&entityID=%@",
	 [UNMUtils urlEncode:target],
	 [UNMUtils urlEncode:shibbolethIdentityProvider]];
	
	NSLog(@"ssoURL: %@", ssoURL);
	
	NSURL* const url = [NSURL URLWithString:ssoURL];
	
	NSURLRequest* const request=[NSURLRequest requestWithURL:url
												 cachePolicy:NSURLRequestUseProtocolCachePolicy
											 timeoutInterval:10.0];
	
	[self.webView loadRequest:request];
}

// Override: UNMAppViewCallback
- (void) callbackLogout {
	
	// In case of logout, we delete all webView’s cookies.
	
	NSHTTPCookieStorage* const storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	
	for (NSHTTPCookie* const cookie in [storage cookies]) {
		
		[storage deleteCookie:cookie];
	}
	
	[[NSUserDefaults standardUserDefaults] synchronize]; // Flush to disk the updated data
}

// Override: UNMAppViewCallback
- (void)callbackGoBackFromLoginShibboleth {
	
	[self.webView endEditing:YES];
}

// Override: UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView*)webView {
	
	NSURL* const url = webView.request.URL;
	
	NSLog(@"webViewDidFinishLoad: %@", url);
	
	if ([[url absoluteString] hasPrefix:SHIBBOLETH_CALLBACK]) {
		
		const BOOL success = [self.appLayer retrieveSession:API_KEY
														  loginToken:self.conversation.loginToken
																 key:self.conversation.key];

							  NSLog(@"retrieve.success: %d", success);
							 
		if (success) {
			
			[self.appLayer goFromLoginShibbolethToProfile];
		
		} else {
			
			[self.appLayer goBackFromLoginShibboleth];
		}
	}
}

@end