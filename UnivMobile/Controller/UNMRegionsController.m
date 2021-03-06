//
//  UNMRegionsController.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 03/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMRegionsController.h"
#import "UNMRegionData.h"
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import <EXTScope.h>
#import "UNMConstants.h"
#import "UIBarButtonItem+UIAccessibility.h"

@interface UNMRegionsController ()

@end

@implementation UNMRegionsController

@synthesize appLayer = _appLayer;

- (instancetype) initWithAppLayer:(UNMAppLayer*)appLayer
							style:(UITableViewStyle)style
		   universitiesController:(UNMUniversitiesController*)universitiesController {

    self = [super initWithStyle:style];
	
    if (self) {
		
		_appLayer = appLayer;
		
		[self.appLayer addCallback:self];
		
		_universitiesController = universitiesController;
    }
	
    return self;
}

// Override: UIViewController
- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	self.tableView.accessibilityIdentifier = @"table-regions";
	
	self.view.backgroundColor = [UNMConstants RGB_9bc9e1];
    
    // Preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
	
	self.title = @"Régions";

	UIBarButtonItem* const rightBarButton = [[UIBarButtonItem alloc]
											  initWithTitle:@"Retour"
											  style:UIBarButtonItemStyleBordered
											  target:nil
											  action:nil];
	rightBarButton.accessibilityIdentifier = @"button-retour";
	
	self.navigationItem.rightBarButtonItem = rightBarButton;
	self.universitiesController.navigationItem.rightBarButtonItem = rightBarButton;
	
	@weakify(self)
	
	rightBarButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
		
		@strongify(self)
		
		[self.appLayer goBackFromRegions];
		
		return [RACSignal empty];
	}];
}

// Override
- (void)didReceiveMemoryWarning {
	
    [super didReceiveMemoryWarning];
	
    // Dispose of any resources that can be recreated.
}

- (void)setSelectedRegionId:(NSString*)selectedRegionId {
	
	_selectedRegionId = selectedRegionId;
	
	[self.tableView reloadData];
	
	const UNMRegionData* const regionData = [self.appLayer.regionsData regionDataById:selectedRegionId];
	
	self.universitiesController.regionData = regionData;
}

- (void)setSelectedUniversityId:(NSString*)selectedUniversityId {
	
	self.universitiesController.selectedUniversityId = selectedUniversityId;
}

#pragma mark - Table view data source

// Override: UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
	
    return 1;
}

// Override: UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	
    return section == 0 ? [self.appLayer.regionsData sizeOfRegionData] : 0;
}

// Override: UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"region"];
	
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"region"];
    }
	
	const NSUInteger row = indexPath.row;
	
	const UNMRegionData* const regionData = [self.appLayer.regionsData regionDataAtIndex:row];

	const BOOL isSelected = [regionData.id isEqualToString:self.selectedRegionId];
	
	// For details, see:
	// https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/iPhoneAccessibility/Making_Application_Accessible/Making_Application_Accessible.html
	//
	cell.isAccessibilityElement = NO; // Important.
	cell.textLabel.isAccessibilityElement = YES;
	cell.textLabel.accessibilityElementsHidden = NO;
	cell.textLabel.accessibilityIdentifier = [@"table-regions-" stringByAppendingString:regionData.id];

	if (isSelected) {
		cell.backgroundColor = [UNMConstants RGB_79b8d9];
	} else {
		cell.backgroundColor = [UNMConstants RGBA_79b8d9];
	}
	
	cell.textLabel.textColor = [UIColor blackColor];
	cell.detailTextLabel.textColor = [UIColor redColor];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // TODO use a custom PNG image

    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
	cell.textLabel.font = [UIFont systemFontOfSize:18.0];
	
	cell.textLabel.text = regionData.label;

    return cell;
}

// Override: UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	
	const NSUInteger row = indexPath.row;

	const UNMRegionData* const regionData = [self.appLayer.regionsData regionDataAtIndex:row];

	NSString* const oldSelectedRegionId = self.selectedRegionId;
	
	self.selectedRegionId = regionData.id;
	
	if (![regionData.id isEqualToString:oldSelectedRegionId]) {
		
		if ([regionData.id isEqualToString:self.appLayer.selectedRegionId]) {

			self.universitiesController.selectedUniversityId = self.appLayer.selectedUniversityId;

		} else {
		
			self.universitiesController.selectedUniversityId = nil;
		}
	}
	
	self.universitiesController.regionData = regionData;
	
	@weakify(self)
	
	dispatch_async(dispatch_get_main_queue(), ^{
		
		@strongify(self)
		
		[self.navigationController pushViewController:self.universitiesController animated:YES];
	});
}

#pragma mark - AppLayer Callbacks

// Override: UNMAppViewCallback
- (void) callbackSetSelectedRegionIdInList:(NSString*)regionId {
	
	self.selectedRegionId = regionId;
}


// Override: UNMAppViewCallback
- (void) callbackShowUniversityList {
	
	[self.navigationController popToRootViewControllerAnimated:NO];
	
	[self.navigationController pushViewController:self.universitiesController animated:NO];
}

// Override: UNMAppViewCallback
- (void) callbackRefreshRegionsData {

	[self.tableView reloadData];
	
	// We must reload in memory the current regionData, the old one has been flushed
	
	self.universitiesController.regionData = [self.appLayer.regionsData regionDataById:self.selectedRegionId];
	
	[self.universitiesController.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
