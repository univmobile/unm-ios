//
//  UNMHomeController.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 03/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMHomeController.h"
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import <EXTScope.h>
#import "UNMConstants.h"
#import "UNMViewFx.h"
#import "UNMRegionsData.h"

@interface UNMHomeController ()

@property (nonatomic, assign) CGFloat screenMiddle;

@property (nonatomic, strong) UIView* homeView;
@property (nonatomic, strong) UIView* homeTitleView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (weak) UNMViewFxVerticalSliderFromTo* aboutPageTransition;
@property (nonatomic, strong) UIView* homeAboutView;
@property (nonatomic, strong) UITextView* aboutTextView;
@property (nonatomic, strong) UILabel* aboutLastDataRefreshLabel;
@property (nonatomic, strong) UIButton* aboutDataRefreshButton;
@property (nonatomic, strong) UIButton* aboutCloseButton;
@property (nonatomic, strong) UILabel* universityLabel;
@property (nonatomic, strong) UIButton* chooseButton;

@property (nonatomic, strong) UIView* regionsView;
@property (nonatomic, strong) UILabel* regionsLabel;

@property (nonatomic, weak) UIView* navView;

@end

@implementation UNMHomeController

@synthesize appLayer = _appLayer;

/*
 - (instancetype)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil {
 
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 
 if (self) {
 
 }
 
 return self;
 }
 */

- (instancetype) initWithAppLayer:(UNMAppLayer*)appLayer
						  navView:(UIView*)navView {
	
	self = [super init];
	
	if (self) {
		
		_appLayer = appLayer;
		
		[self.appLayer addCallback:self];
		
		self.navView = navView;
	}
	
	return self;
}

// Override: UIViewController
- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	// DIMENSIONS
	
	const CGRect bounds = [UIScreen mainScreen].bounds;
	
	[self calcScreenHeight];
	
	// COLORS
	
	self.view.backgroundColor = [UNMConstants RGB_79b8d9];
	
	// LOAD AND ADD MAIN VIEWS
	
	self.homeView = [[UIView alloc] initWithFrame:bounds];
	self.homeAboutView = [[UIView alloc] initWithFrame:bounds];
	self.homeTitleView = [[UIView alloc] initWithFrame:bounds];
	
	[self.view addSubview:self.homeView];
	[self.homeView addSubview:self.homeAboutView];
	[self.homeView addSubview:self.homeTitleView];

	// HOME VIEW
		
	self.homeAboutView.backgroundColor = [UNMConstants RGB_9bc9e1];
		
	self.homeTitleView.backgroundColor = [UNMConstants RGB_79b8d9];
		
	self.aboutPageTransition = [UNMViewFx autorelease_viewFx:UNMPageTransitionTypeSliding
													fromView:self.homeTitleView
													  toView:self.homeAboutView
														edge:UNMPageTransitionEdgeTop];
	
	// REGIONS VIEW
	
	self.regionsView = [[UIView alloc] initWithFrame:bounds];
	self.regionsView.hidden = YES;
	
	[self.view addSubview:self.regionsView];
	
	// TITLE LABEL
	
	self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, self.screenMiddle - 200.0, 220.0, 60.0)
					   ];
	self.titleLabel.accessibilityIdentifier = @"label-homePageTitle";
	self.titleLabel.text = @"UnivMobile";
	self.titleLabel.textColor = [UNMConstants RGB_79b8d9];
	self.titleLabel.font = [UIFont systemFontOfSize:36];
	self.titleLabel.textAlignment = NSTextAlignmentCenter;
	self.titleLabel.backgroundColor = [UIColor whiteColor];
	// self.titleLabel.accessibilityLabel = @"myLabel";
	// self.titleLabel.accessibilityHint = @"myHint";
	
	[self.homeTitleView addSubview:self.titleLabel];
	
	// ABOUT: TEXT VIEW
	
	self.aboutTextView = [[UITextView alloc]initWithFrame:CGRectMake(15.0, self.screenMiddle - 200.0, 290.0, 190.0)];
	self.aboutTextView.accessibilityIdentifier = @"textView-buildInfo";

	self.aboutTextView.editable = NO;
	
	const UNMBuildInfo* const buildInfo = self.appLayer.buildInfo;
	
	self.aboutTextView.text = [NSString stringWithFormat:
							   @"\nUnivMobile\n\n©2014 UNPIdF\n\nBuild %@ — %@\n\nJSON: %@\n\nGitHub: https://github.com/univmobile/unm-ios\n\n%@",
							   buildInfo.BUILD_DISPLAY_NAME,
							   [[[[[buildInfo.BUILD_ID
									stringByReplacingCharactersInRange:NSMakeRange(4, 1) withString:@"/"]
								  stringByReplacingCharactersInRange:NSMakeRange(7, 1) withString:@"/"]
								 stringByReplacingCharactersInRange:NSMakeRange(10, 1) withString:@" "]
								 stringByReplacingCharactersInRange:NSMakeRange(13, 1) withString:@":"]
								stringByReplacingCharactersInRange:NSMakeRange(16, 3) withString:@""],
							   buildInfo.UNMJsonBaseURL,
							   buildInfo.GIT_COMMIT
							   ];
	self.aboutTextView.textColor = [UIColor blackColor];//[UNMConstants RGB_79b8d9];
	self.aboutTextView.font = [UIFont systemFontOfSize:12];
	self.aboutTextView.textAlignment = NSTextAlignmentLeft;
	self.aboutTextView.backgroundColor = [UIColor whiteColor];
	self.aboutTextView.alpha = 0.8f;
	//	self.aboutTitleLabel.contentInset = UIEdgeInsetsMake(10.0, 40.0, 40.0, 40.0);

	[self.homeAboutView addSubview:self.aboutTextView];

	// ABOUT: DATA REFRESH
	
	self.aboutLastDataRefreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, self.screenMiddle + 5.0, 290.0, 30.0)];

	UNMRegionsData* const regionsData = [self.appLayer loadInitialRegionsData];
	
	self.aboutLastDataRefreshLabel.text = [NSString stringWithFormat:@"Données récupérées le %@ à %@",
										   regionsData.lastDataRefreshDayAsString,
										   regionsData.lastDataRefreshTimeAsString];
	
	self.aboutLastDataRefreshLabel.font = [UIFont systemFontOfSize:12];
	self.aboutLastDataRefreshLabel.textAlignment = NSTextAlignmentCenter;
	
	self.aboutLastDataRefreshLabel.backgroundColor = [UNMConstants RGB_9bc9e1];

	self.aboutDataRefreshButton = [[UIButton alloc] initWithFrame:CGRectMake(
																	   15.0, self.screenMiddle + 40.0, 290.0, 20.0)];
	self.aboutDataRefreshButton.accessibilityIdentifier = @"button-dataRefresh";
	
	// self.aboutDataRefreshButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	
	// self.aboutDataRefreshButton.backgroundColor = [UIColor redColor];
	
	[self.aboutDataRefreshButton setTitle:@"Récupérer les données" forState:UIControlStateNormal];
	
	[self.aboutDataRefreshButton setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];

	[self.homeAboutView addSubview:self.aboutLastDataRefreshLabel];
	[self.homeAboutView addSubview:self.aboutDataRefreshButton];
	
	
	@weakify(self)
	
	self.aboutDataRefreshButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
		
		@strongify(self)
		
		[self.appLayer refreshRegionsData];
		
		self.aboutLastDataRefreshLabel.text = [NSString stringWithFormat:@"Données récupérées le %@ à %@",
											   self.appLayer.regionsData.lastDataRefreshDayAsString,
											   self.appLayer.regionsData.lastDataRefreshTimeAsString];
		
		return [RACSignal empty];
	}];

	// CLOSE ABOUT BUTTON
	
	self.aboutCloseButton = [[UIButton alloc] initWithFrame:CGRectMake(
																	   120.0, self.screenMiddle + 126.0, 80.0, 20.0)
							 ];
	
	[self.aboutCloseButton setTitle:@"OK" forState:UIControlStateNormal];
	
	[self.aboutCloseButton setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
	
	[self.homeAboutView addSubview:self.aboutCloseButton];
	
	// @weakify(self)
	
	self.aboutCloseButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
		
		@strongify(self)
		
		[self.aboutPageTransition scrollBackFrontView];
		
		return [RACSignal empty];
	}];
	
	// UNIVERSITY NAME LABEL
	
	self.universityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.screenMiddle + 20.0, 320.0, 40.0)];
	self.universityLabel.text = @"Aucune université sélectionnée";
	self.universityLabel.textColor = [UIColor blackColor];
	self.universityLabel.font = [UIFont italicSystemFontOfSize:18];
	self.universityLabel.textAlignment = NSTextAlignmentCenter;
	self.universityLabel.backgroundColor = [UNMConstants RGB_79b8d9]; // When not set, takes white if under iOS 6.0
	
	[self.homeTitleView addSubview:self.universityLabel];
	
	// REGIONS LABEL
	
	self.regionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, self.screenMiddle - 200.0, 220.0, 60.0)];
	self.regionsLabel.text = @"Régions";
	self.regionsLabel.textColor = [UNMConstants RGB_79b8d9];
	self.regionsLabel.font = [UIFont systemFontOfSize:36];
	self.regionsLabel.textAlignment = NSTextAlignmentCenter;
	self.regionsLabel.backgroundColor = [UIColor whiteColor];
	
	[self.regionsView addSubview:self.navView];
	
	// CHOOSE BUTTON
	
	self.chooseButton = [[UIButton alloc] initWithFrame:CGRectMake(120.0, self.screenMiddle + 100.0, 80.0, 20.0)];
	self.chooseButton.accessibilityIdentifier = @"button-choisirUniversité";
	
	[self.chooseButton setTitle:@"Choisir…" forState:UIControlStateNormal];
	
	[self.chooseButton setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
	
	[self.homeTitleView addSubview:self.chooseButton];
	
	self.chooseButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
		
		@strongify(self)
		
		if (self.appLayer.selectedRegionId) {
			
			[self.appLayer setSelectedRegionIdInList:self.appLayer.selectedRegionId];
			
			if (self.appLayer.selectedUniversityId) {
				
				[self.appLayer setSelectedUniversityIdInList:self.appLayer.selectedUniversityId];
				
				[self.appLayer showUniversityList];
			}
		}
		
		[UIView transitionFromView:self.homeView
							toView:self.regionsView
						  duration:[UNMConstants TRANSITION_DURATION]
						   options:UIViewAnimationOptionTransitionFlipFromRight //
										+ UIViewAnimationOptionShowHideTransitionViews
						completion:^(BOOL done) {
							// nothing here
						}];
		
		return [RACSignal empty];
	}];
	
	// LAYOUT
	
	[self doLayoutSubviews];
}

// Override
- (void)didReceiveMemoryWarning {
	
    [super didReceiveMemoryWarning];
}

// Override
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
	
	[self doLayoutSubviews];
}

- (void)calcScreenHeight {
	
	const CGFloat viewHeight = self.view.bounds.size.height;
	
	const BOOL IS_IOS6 = (viewHeight == 548.0f || viewHeight == 460.0f);
	
	if (IS_IOS6) {
		
		// self.screenHeight = viewHeight + 20.0f;
		
		self.screenMiddle = viewHeight / 2 - 10.0f;
		
	} else {
		
		// self.screenHeight = viewHeight;
		
		self.screenMiddle = viewHeight / 2;
	}
}

- (void)doLayoutSubviews {
	
	[self calcScreenHeight];
	
	const CGRect bounds = self.view.bounds;
	
    self.regionsView.frame = bounds;
	
	self.navView.frame = bounds;
}

#pragma mark - AppLayer Callbacks

// Override: UNMAppViewCallback
- (void)callbackGoBackFromRegions {
	
	if (self.appLayer.selectedUniversityId) {
		
		self.universityLabel.font = [UIFont systemFontOfSize:18];
		
		UNMUniversityData* const universityData =
		[self.appLayer.regionsData universityDataById:self.appLayer.selectedUniversityId];
		
		self.universityLabel.text = universityData.title;
		
	} else {
		
		self.universityLabel.text = @"Aucune université sélectionnée";
		self.universityLabel.font = [UIFont italicSystemFontOfSize:18];
	}
	
	[UIView transitionFromView:self.regionsView
						toView:self.homeView
					  duration:[UNMConstants TRANSITION_DURATION]
					   options:UIViewAnimationOptionTransitionFlipFromLeft //
									+ UIViewAnimationOptionShowHideTransitionViews
					completion:^(BOOL done) {
						// nothing here
					}];
}

@end


