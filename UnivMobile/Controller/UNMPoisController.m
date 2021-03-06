//
//  UNMPoisController.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 01/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMPoisController.h"
#import "UNMPoiData.h"
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import <EXTScope.h>
#import "UNMConstants.h"
#import "UIBarButtonItem+UIAccessibility.h"

@interface UNMPoisController ()

@property (weak, nonatomic) UNMDetailsController* detailsController;

@end

@implementation UNMPoisController

@synthesize appLayer = _appLayer;

- (instancetype) initWithAppLayer:(UNMAppLayer*)appLayer
							style:(UITableViewStyle)style
				detailsController:(UNMDetailsController*)detailsController{
	
    self = [super initWithStyle:style];
	
    if (self) {
		
		_appLayer = appLayer;
		
		[self.appLayer addCallback:self];
		
		self.tabBarItem = [[UITabBarItem alloc] //initWithTitle:@"Liste"
						   initWithTitle:NULL
						   image:[UIImage imageNamed:@"text-list.png"] tag:1];
//		[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:1];

		// self.tabBarItem.isAccessibilityElement = YES;
		self.tabBarItem.accessibilityLabel = @"Liste";
		
		
		self.detailsController = detailsController;
	}
	
    return self;
}

// Override: UIViewController
- (void)viewDidLoad {

    [super viewDidLoad];
	
	self.tableView.accessibilityIdentifier = @"table-pois";
	
	self.view.backgroundColor = [UNMConstants RGB_9bc9e1];
	
	self.tabBarController.title = @"POIs";
	//self.title = @"POIs";
//	UITabBarSystemItem
	
	UIBarButtonItem* const rightBarButton = [[UIBarButtonItem alloc]
											 initWithTitle:@"Retour"
											 style:UIBarButtonItemStyleBordered
											 target:nil
											 action:nil];
	rightBarButton.accessibilityIdentifier = @"button-retour";
	
	//self.navigationItem.rightBarButtonItem = rightBarButton;
	self.tabBarController.navigationItem.rightBarButtonItem = rightBarButton;
	
	@weakify(self)
	
	rightBarButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
		
		@strongify(self)
		
		[self.appLayer goBackFromGeocampus];
		
		return [RACSignal empty];
	}];
}

// Override: UIViewController
- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

// Override: UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
	
    return [self.appLayer.poisData sizeOfPoiGroupData];
}

// Override: UITableViewDataSource
- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
	
    return [self.appLayer.poisData poiGroupDataAtIndex:section].groupLabel;
}

// Override: UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	
    return [[self.appLayer.poisData poiGroupDataAtIndex:section] sizeOfPoiData];
}

// Override: UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"poi"];
	
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"poi"];
    }

	cell.backgroundColor = [UNMConstants RGBA_79b8d9];

	const NSUInteger section = indexPath.section;
	const NSUInteger row = indexPath.row;
	
	const UNMPoiData* const poi = [[self.appLayer.poisData poiGroupDataAtIndex:section] poiDataAtIndex:row];
	
	// For details, see:
	// https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/iPhoneAccessibility/Making_Application_Accessible/Making_Application_Accessible.html
	//
	cell.isAccessibilityElement = NO; // Important.
	cell.textLabel.isAccessibilityElement = YES;
	cell.textLabel.accessibilityElementsHidden = NO;
	cell.textLabel.accessibilityIdentifier = [NSString stringWithFormat:@"table-pois-%lu", (unsigned long) poi.id];
	
	cell.textLabel.textColor = [UIColor blackColor];
	cell.detailTextLabel.textColor = [UIColor redColor];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // TODO use a custom PNG image
	
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
	cell.textLabel.font = [UIFont systemFontOfSize:18.0];
	
	cell.textLabel.text = poi.name;
	
    return cell;
}

// Override: UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	
	const NSUInteger section = indexPath.section;
	const NSUInteger row = indexPath.row;
	
	const UNMPoiData* const poi = [[self.appLayer.poisData poiGroupDataAtIndex:section] poiDataAtIndex:row];

	[self showDetailsPage:poi];
}

- (void) showDetailsPage:(const UNMPoiData*)poi {
	
	self.detailsController.poi = poi;
	
	@weakify(self)
	
	dispatch_async(dispatch_get_main_queue(), ^{
		
		@strongify(self)
		
		[self.tabBarController.navigationController pushViewController:self.detailsController.tabBarController animated:YES];
		
		[self.detailsController.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
	});
}

#pragma mark - AppLayer Callbacks

// Override: UNMAppViewCallback
- (void) callbackRefreshPoisData {
	
	[self.tableView reloadData];
}

@end
