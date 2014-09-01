//
//  UNMCommentsController.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 01/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMCommentsController.h"

@interface UNMCommentsController ()

@end

@implementation UNMCommentsController

@synthesize appLayer = _appLayer;

- (instancetype)initWithAppLayer:(UNMAppLayer*)appLayer {
	
    self = [super initWithStyle:UITableViewStylePlain];
    
	if (self) {
		
		_appLayer = appLayer;
		
		// [self.appLayer addCallback:self];
		
		self.tabBarItem = [[UITabBarItem alloc] //initWithTitle:@"Plan"
						   initWithTitle:nil
						   image:[UIImage imageNamed:@"text-left.png"] tag:1];
		
		self.tabBarItem.accessibilityLabel = @"Commentaires";
		
		//self.tabSelected = NO;
		
		//self.selectedPoi = nil;
    }
    
	return self;
}

// Override: UIViewController
- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];//
	//[UNMConstants RGB_9bc9e1];
	
	// self.tableView.userInteractionEnabled = NO;
	
	//self.tableView.separatorColor = [UIColor colorWithWhite:0.0 alpha:0.0];
	
    // Preserve selection between presentations.
	//   self.clearsSelectionOnViewWillAppear = NO;
	/*
	if (self.poi) {
		
		self.poi = self.poi; // set self.title
		
	} else {
		
		self.tabBarController.title = @"(Unknown)"; // e.g. @"Université Paris Diderot"
	}
	*/
	/*
	UIBarButtonItem* const rightBarButton = [[UIBarButtonItem alloc]
											 initWithTitle:@"Retour"
											 style:UIBarButtonItemStyleBordered
											 target:nil
											 action:nil];
	rightBarButton.accessibilityIdentifier = @"button-retour";
	*/
	//self.navigationItem.rightBarButtonItem = rightBarButton;
	
	//self.tabBarController.navigationItem.rightBarButtonItem = rightBarButton;
	
	/*
	@weakify(self)
	
	rightBarButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
		
		@strongify(self)
		
		[self.appLayer goBackFromGeocampus];
		
		return [RACSignal empty];
	}];
	*/
}

// Override
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
}

@end
