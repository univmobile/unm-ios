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

@interface UNMHomeController ()

@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) UIView* homeView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* universityLabel;
@property (nonatomic, strong) UIButton* chooseButton;

@property (nonatomic, strong) UIView* regionsView;
@property (nonatomic, strong) UILabel* regionsLabel;

@property (nonatomic, weak) UIView* navView;
@property (nonatomic, weak) UNMRegionsController* regionsController;

@end

@implementation UNMHomeController

@synthesize selectedRegionId = _selectedRegionId;
@synthesize selectedUniversityId = _selectedUniversityId;

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil {
	
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
	if (self) {
 
	}
	
    return self;
}

- (id) initWithNav:(UIView*) navView regionsController:(UNMRegionsController*)regionsController {
	
	self = [super init];
	
	if (self) {
		
		self.navView = navView;
		self.regionsController = regionsController;
	}
	
	return self;
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	// DIMENSIONS
	
	const CGRect bounds = [UIScreen mainScreen].bounds;
	
	self.screenHeight = bounds.size.height;
	
	// COLORS
	
	self.view.backgroundColor = [UNMConstants RGB_79b8d9];

	// HOME VIEW

	self.homeView = [[UIView alloc] initWithFrame:bounds];

	[self.view addSubview:self.homeView];
	
	// REGIONS VIEW
	
	self.regionsView = [[UIView alloc] initWithFrame:bounds];
	self.regionsView.hidden = YES;
	
	[self.view addSubview:self.regionsView];

	// TITLE LABEL
	
	self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(
						50.0, self.screenHeight / 2 - 200.0, 220.0, 60.0)
					   ];
	self.titleLabel.text = @"UnivMobile";
	self.titleLabel.textColor = [UNMConstants RGB_79b8d9];
	self.titleLabel.font = [UIFont systemFontOfSize:36];
	self.titleLabel.textAlignment = NSTextAlignmentCenter;
	self.titleLabel.backgroundColor = [UIColor whiteColor];
	
	[self.homeView addSubview:self.titleLabel];
	
	// UNIVERSITY NAME LABEL

	self.universityLabel = [[UILabel alloc] initWithFrame:CGRectMake(
							0.0, self.screenHeight / 2 + 20.0, 320.0, 40.0)
							];
	self.universityLabel.text = @"Aucune université sélectionnée";
	self.universityLabel.textColor = [UIColor blackColor];
	self.universityLabel.font = [UIFont italicSystemFontOfSize:18];
	self.universityLabel.textAlignment = NSTextAlignmentCenter;
	self.universityLabel.backgroundColor = [UNMConstants RGB_79b8d9]; // When not set, takes white if under iOS 6.0
	
	[self.homeView addSubview:self.universityLabel];
	
	// REGIONS LABEL
	
	self.regionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(
																50.0, self.screenHeight / 2 - 200.0, 220.0, 60.0)
					   ];
	self.regionsLabel.text = @"Régions";
	self.regionsLabel.textColor = [UNMConstants RGB_79b8d9];
	self.regionsLabel.font = [UIFont systemFontOfSize:36];
	self.regionsLabel.textAlignment = NSTextAlignmentCenter;
	self.regionsLabel.backgroundColor = [UIColor whiteColor];
	
	[self.regionsView addSubview:self.navView];
	
	// CHOOSE BUTTON
	
	self.chooseButton = [[UIButton alloc] initWithFrame:CGRectMake(
						120.0, self.screenHeight / 2 + 100.0, 80.0, 20.0)
						 ];
	
	[self.chooseButton setTitle:@"Choisir…" forState:UIControlStateNormal];

	[self.chooseButton setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
	
	[self.homeView addSubview:self.chooseButton];
	
	self.regionsController.callback = self;

	@weakify(self)
	
	self.chooseButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
		
		@strongify(self)
		
		if (self.selectedRegionId) {
			
			self.regionsController.selectedRegionId = self.selectedRegionId;
			
			if (self.selectedUniversityId) {

				self.regionsController.selectedUniversityId = self.selectedUniversityId;
			}
		}
		
		[UIView transitionFromView:self.homeView
							toView:self.regionsView
						  duration:[UNMConstants TRANSITION_DURATION]
						   options:UIViewAnimationOptionTransitionFlipFromRight + UIViewAnimationOptionShowHideTransitionViews
						completion:^(BOOL done) {
							// nothing here
						}];
		
		return [RACSignal empty];
	}];
	
	// LAYOUT
	
	[self doLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
	
    [super didReceiveMemoryWarning];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
	
	[self doLayoutSubviews];
}

- (void)doLayoutSubviews {
	
    const CGRect bounds = self.view.bounds;
	
	self.screenHeight = bounds.size.height;
	
    self.regionsView.frame = bounds;
	self.navView.frame = CGRectMake(0.0, 0.0, 320.0, self.screenHeight);
}

#pragma mark - Callback

- (void)goBackFromRegions {
	
	if (self.selectedUniversityId) {
		
		self.universityLabel.font = [UIFont systemFontOfSize:18];
		UNMUniversityData* const universityData = [self.regionsController getUniversityDataById:self.selectedUniversityId];
		self.universityLabel.text = universityData.title;
	
	} else {
		
		self.universityLabel.text = @"Aucune université sélectionnée";
		self.universityLabel.font = [UIFont italicSystemFontOfSize:18];
	}
	
	[UIView transitionFromView:self.regionsView
						toView:self.homeView
					  duration:[UNMConstants TRANSITION_DURATION]
					   options:UIViewAnimationOptionTransitionFlipFromLeft + UIViewAnimationOptionShowHideTransitionViews
					completion:^(BOOL done) {
						// nothing here
					}];
}

@end
