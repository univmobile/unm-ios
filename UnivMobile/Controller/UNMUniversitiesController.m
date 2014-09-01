//
//  UNMUniversitiesController.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 04/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMUniversitiesController.h"
#import "UNMRegionData.h"
#import "UNMConstants.h"
#import <EXTScope.h>

@interface UNMUniversitiesController ()

@end

@implementation UNMUniversitiesController

@synthesize appLayer = _appLayer;

- (instancetype)initWithAppLayer:(UNMAppLayer*)appLayer
						   style:(UITableViewStyle)style {
	
    self = [super initWithStyle:style];
    
	if (self) {

		_appLayer = appLayer;
		
		[self.appLayer addCallback:self];
		
		// self.view.accessibilityIdentifier = @"toto";
		// self.view.accessibilityLabel = @"Popeye";
    }
    
	return self;
}

// Override: UIViewController
- (void)viewDidLoad {

    [super viewDidLoad];
    
	self.tableView.accessibilityIdentifier = @"table-universities";

	self.view.backgroundColor = [UNMConstants RGB_9bc9e1];

    // Preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;

	if (self.regionData) {
		
		self.regionData = self.regionData; // set self.title
	
	} else {
	
		self.title = @"(Unknown)"; // e.g. @"Limousin/Poitou-Charentes";
	}
}

// Override
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void) setRegionData:(UNMRegionData*)regionData {
		
	self.title = regionData.label; // e.g. @"Limousin/Poitou-Charentes";

	_regionData = regionData;
	
	[self.tableView reloadData];
}

#pragma mark - Table view data source

// Override: UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
	
    return 1;
}

// Override: UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {

	if (section == 0 && self.regionData) {

		return [self.regionData.universities count];
	}

	return 0;
}

// Override: UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"university"];
	
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"university"];
    }
	
	const NSUInteger row = indexPath.row;
	
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
	
	const UNMUniversityData* const universityData = [self.regionData.universities objectAtIndex:row];
	
	const BOOL isSelected = [universityData.id isEqualToString:self.selectedUniversityId];
	
	// For details, see:
	// https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/iPhoneAccessibility/Making_Application_Accessible/Making_Application_Accessible.html
	//
	cell.isAccessibilityElement = NO; // Important.
	cell.textLabel.isAccessibilityElement = YES;
	cell.textLabel.accessibilityElementsHidden = NO;
	cell.textLabel.accessibilityIdentifier = [@"table-universities-" stringByAppendingString:universityData.id];

	if (isSelected) {
		cell.backgroundColor = [UNMConstants RGB_79b8d9];
	} else {
		cell.backgroundColor = [UNMConstants RGBA_79b8d9];
	}

	cell.textLabel.textColor = [UIColor blackColor];
	cell.detailTextLabel.textColor = [UIColor blackColor];
	
	cell.textLabel.font = [UIFont systemFontOfSize:18.0];
	
	cell.textLabel.text = universityData.title;
	
    return cell;
}

// Override: UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	
	const NSUInteger row = indexPath.row;
	
	const UNMUniversityData* const universityData = [self.regionData.universities objectAtIndex:row];

	self.selectedUniversityId = universityData.id;
	
	self.appLayer.selectedRegionId = self.regionData.id;
	self.appLayer.selectedUniversityId = universityData.id;
	
	@weakify(self)
	
	dispatch_async(dispatch_get_main_queue(), ^{
		
		@strongify(self)
		
		[self.appLayer goBackFromRegions];
	});
}

- (void)setSelectedUniversityId:(NSString*)selectedUniversityId {
	
	_selectedUniversityId = selectedUniversityId;
	
	[self.tableView reloadData];

	[self.tableView setNeedsDisplay];
}

#pragma mark - AppLayer Callbacks

// Override: UNMAppViewCallback
- (void) callbackSetSelectedUniversityIdInList:(NSString*)universityId {
	
	self.selectedUniversityId = universityId;
}

// Override: UNMAppViewCallback
- (void) callbackRefreshRegionsData {

	[self.tableView reloadData];
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
