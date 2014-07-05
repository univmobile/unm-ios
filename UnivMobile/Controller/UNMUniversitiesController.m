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

@interface UNMUniversitiesController ()

@end

@implementation UNMUniversitiesController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    
	if (self) {

    }
    
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.view.backgroundColor = [UNMConstants RGB_9bc9e1];

    // Preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;

	if (self.regionData) {
		
		self.regionData = self.regionData; // set self.title
	
	} else {
	
		self.title = @"(Unknown)"; // e.g. @"Limousin/Poitou-Charentes";
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Internal data

- (void) setRegionData:(UNMRegionData*)regionData {
		
	self.title = regionData.label;// e.g. @"Limousin/Poitou-Charentes";

	_regionData = regionData;
	
	[self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
	
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {

	if (section == 0 && self.regionData) {

		return [self.regionData.universities count];
	}
	
	return 0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"university"];
	
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"university"];
    }
	
	const NSUInteger row = [indexPath row];
	
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	const UNMUniversityData* const universityData = [self.regionData.universities objectAtIndex:row];
	
	const BOOL isSelected = [universityData.id isEqualToString:self.selectedUniversityId];
	
	if (isSelected) {
		cell.backgroundColor = [UNMConstants RGB_79b8d9];
		cell.textLabel.textColor = [UIColor blackColor];
		cell.detailTextLabel.textColor = [UIColor redColor];
	} else {
		cell.backgroundColor = [UNMConstants RGBA_79b8d9];
		cell.textLabel.textColor = [UIColor blackColor];
		cell.detailTextLabel.textColor = [UIColor blackColor];
	}
    
	cell.textLabel.font = [UIFont systemFontOfSize:18.0];
	
	cell.textLabel.text = universityData.title;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
	
	[cell.backgroundView setNeedsDisplay];
	
	[cell setNeedsDisplay];
	
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	
	const NSUInteger row = [indexPath row];
	
	const UNMUniversityData* const universityData = [self.regionData.universities objectAtIndex:row];

	self.selectedUniversityId = universityData.id;
	
	if (self.callback) {
		
		self.callback.selectedRegionId = self.regionData.id;
		self.callback.selectedUniversityId = universityData.id;

		[self.callback goBackFromRegions];
	}
}

- (void)setSelectedUniversityId:(NSString*)selectedUniversityId {
	
	_selectedUniversityId = selectedUniversityId;
	
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