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

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	self.view.backgroundColor = [UNMConstants RGB_9bc9e1];
    
    // Preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
	
	self.title = @"Régions";

	UIBarButtonItem* const rightBarButton = [[UIBarButtonItem alloc]
											  initWithTitle:@"Retour"
											  style:UIBarButtonItemStyleBordered
											  target:nil
											  action:nil];
	
	self.navigationItem.rightBarButtonItem = rightBarButton;
	self.universitiesController.navigationItem.rightBarButtonItem = rightBarButton;
	
	@weakify(self)
	
	rightBarButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
		
		@strongify(self)
		
		[self.appLayer goBackFromRegions];
		
		return [RACSignal empty];
	}];
}

- (void)didReceiveMemoryWarning {
	
    [super didReceiveMemoryWarning];
	
    // Dispose of any resources that can be recreated.
}

- (void)setSelectedRegionId:(NSString*)selectedRegionId {
	
	_selectedRegionId = selectedRegionId;
	
	[self.tableView reloadData];
	
	const UNMRegionData* const regionData = [self.appLayer getRegionDataById:selectedRegionId];
	
	self.universitiesController.regionData = regionData;
}

- (void)setSelectedUniversityId:(NSString*)selectedUniversityId {
	
	self.universitiesController.selectedUniversityId = selectedUniversityId;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
	
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	
    return section == 0 ? [self.appLayer sizeOfRegionData] : 0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"region"];
	
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"region"];
    }
	
	const NSUInteger row = [indexPath row];
	
	const UNMRegionData* const regionData = [self.appLayer getRegionDataAtIndex:row];

	const BOOL isSelected = [regionData.id isEqualToString:self.selectedRegionId];

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

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	
	const NSUInteger row = [indexPath row];

	const UNMRegionData* const regionData = [self.appLayer getRegionDataAtIndex:row];

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

- (void) callbackSetSelectedRegionIdInList:(NSString*)regionId {
	
	self.selectedRegionId = regionId;
}


- (void) callbackShowUniversityList {
	
	[self.navigationController popToRootViewControllerAnimated:NO];
	
	[self.navigationController pushViewController:self.universitiesController animated:NO];
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
