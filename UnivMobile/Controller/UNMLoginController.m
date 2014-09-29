//
//  UNMLoginController.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 29/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMLoginController.h"
#import "UNMConstants.h"
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import <EXTScope.h>
#import "UIBarButtonItem+UIAccessibility.h"

@interface UNMLoginController ()

//@property (nonatomic, strong) UILabel* loginClassicLabel;

@property (nonatomic, strong) UIButton* loginClassicButton;

@end

@implementation UNMLoginController


@synthesize appLayer = _appLayer;

- (instancetype)initWithAppLayer:(UNMAppLayer*)appLayer
//		  loginClassicController:(UNMLoginClassicController*) loginClassicController
{
	
    self = [super init];
    
	if (self) {
		
		_appLayer = appLayer;
		
		//_loginClassicController = loginClassicController;
		
		//[self.appLayer addCallback:self];
		
		// self.view.accessibilityIdentifier = @"toto";
		// self.view.accessibilityLabel = @"Popeye";
    }
    
	return self;
}

// Override: UIViewController
- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	// COLORS
	
	self.view.backgroundColor = [UNMConstants RGB_79b8d9];
	
	self.title = @"Connexion";
	
	UIBarButtonItem* const rightBarButton = [[UIBarButtonItem alloc]
											 initWithTitle:@"Annuler"
											 style:UIBarButtonItemStyleBordered
											 target:nil
											 action:nil];
	rightBarButton.accessibilityIdentifier = @"button-cancel";
	
	self.navigationItem.rightBarButtonItem = rightBarButton;
	//self.loginClassicController.navigationItem.rightBarButtonItem = rightBarButton;
	
	@weakify(self)
	
	rightBarButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
		
		@strongify(self)
		
		NSLog(@"toto");
		
		[self.appLayer goBackFromLogin];
		
		return [RACSignal empty];
	}];

	// LABELS
	
	/*
	self.loginClassicLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 300.0, 220.0, 60.0)];
	self.loginClassicLabel.accessibilityIdentifier = @"label-loginClassic";
	self.loginClassicLabel.text = @"Identification standard";
	self.loginClassicLabel.textColor = [UNMConstants RGB_79b8d9];
	self.loginClassicLabel.font = [UIFont systemFontOfSize:18];
	self.loginClassicLabel.textAlignment = NSTextAlignmentCenter;
	self.loginClassicLabel.backgroundColor = [UIColor whiteColor];
	// self.titleLabel.accessibilityLabel = @"myLabel";
	// self.titleLabel.accessibilityHint = @"myHint";
	
	[self.view addSubview:self.loginClassicLabel];
	*/
	self.loginClassicButton = [[UIButton alloc] initWithFrame:CGRectMake(50.0, 300.0, 220., 60.0)];
	
	self.loginClassicButton.accessibilityIdentifier = @"button-loginClassic";
	
	[self.loginClassicButton setTitle:@"Identification standard…" forState:UIControlStateNormal];
	
	[self.loginClassicButton setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
	
	[self.view addSubview:self.loginClassicButton];
	
	// @weakify(self)
	
	self.loginClassicButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
		
		@strongify(self)
		
		[self.appLayer goFromLoginToLoginClassic];
		
		return [RACSignal empty];
	}];
	
	// LOAD AND ADD MAIN VIEWS
	
	//self.loginTextView = [[UITextView alloc] initWithFrame:bounds];
	//self.passwordTextView = [[UITextView alloc] initWithFrame:bounds];
	
	//[self.view addSubview:self.homeView];
	//[self.homeView addSubview:self.homeAboutView];
	//[self.homeView addSubview:self.homeTitleView];
}

// Override
- (void)didReceiveMemoryWarning {
	
    [super didReceiveMemoryWarning];
}

@end
