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

@property (strong, nonatomic, readonly) NSArray* regionsData; // array of UNMRegionData*

@end

@implementation UNMRegionsController

- (id) initWithStyle:(UITableViewStyle)style universitiesController:(UNMUniversitiesController*)universitiesController {

    self = [super initWithStyle:style];
	
    if (self) {
		
		self.universitiesController = universitiesController;
    }
	
    return self;
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	self.view.backgroundColor = [UNMConstants RGB_9bc9e1];
    
    // Preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
	
	self.title = @"Régions";
	
	NSMutableArray* const array = [[NSMutableArray alloc] init];
	
	// TODO hardcoded values
	
	[array addObject:[[UNMRegionData alloc] initWithId:@"bretagne" label:@"Bretagne"]];
	[array addObject:[[UNMRegionData alloc] initWithId:@"unrpcl" label:@"Limousin/Poitou-Charentes"]];
	[array addObject:[[UNMRegionData alloc] initWithId:@"ile_de_france" label:@"Île de France"]];
	
	_regionsData = array;

	[self addUniversityId:@"ubo" title:@"Université de Bretagne Occidentale" toRegionId:@"bretagne"];
	[self addUniversityId:@"rennes1" title:@"Université de Rennes 1" toRegionId:@"bretagne"];
	[self addUniversityId:@"rennes2" title:@"Université Rennes 2" toRegionId:@"bretagne"];
	[self addUniversityId:@"enscr" title:@"École Nationale Supérieure de Chimie de Rennes" toRegionId:@"bretagne"];
	
	[self addUniversityId:@"ulr" title:@"Université de La Rochelle" toRegionId:@"unrpcl"];
	[self addUniversityId:@"ul" title:@"Université de Limoges" toRegionId:@"unrpcl"];
	[self addUniversityId:@"up" title:@"Université de Poitiers" toRegionId:@"unrpcl"];
	[self addUniversityId:@"ensma" title:@"ISAE-ENSMA" toRegionId:@"unrpcl"];
	[self addUniversityId:@"crousp" title:@"CROUS PCL" toRegionId:@"unrpcl"];
	
	[self addUniversityId:@"paris1" title:@"Paris 1 Panthéon-Sorbonne" toRegionId:@"ile_de_france"];
	[self addUniversityId:@"paris3" title:@"Paris 3 Sorbonne Nouvelle" toRegionId:@"ile_de_france"];
	[self addUniversityId:@"paris13" title:@"Paris Nord" toRegionId:@"ile_de_france"];
	[self addUniversityId:@"uvsq" title:@"UVSQ" toRegionId:@"ile_de_france"];
	[self addUniversityId:@"museum" title:@"Muséum national d'Histoire naturelle" toRegionId:@"ile_de_france"];
	[self addUniversityId:@"evry" title:@"Evry-Val d'Essonne" toRegionId:@"ile_de_france"];
	[self addUniversityId:@"paris6" title:@"UPMC" toRegionId:@"ile_de_france"];
	[self addUniversityId:@"paris7" title:@"Paris Diderot" toRegionId:@"ile_de_france"];
	[self addUniversityId:@"paris8" title:@"Paris 8" toRegionId:@"ile_de_france"];
	[self addUniversityId:@"paris10" title:@"Paris Ouest Nanterre la Défense" toRegionId:@"ile_de_france"];
	[self addUniversityId:@"paris11" title:@"Paris-Sud" toRegionId:@"ile_de_france"];
	[self addUniversityId:@"upec" title:@"UPEC" toRegionId:@"ile_de_france"];
	[self addUniversityId:@"crousVersailles" title:@"Cergy-Pontoise" toRegionId:@"ile_de_france"];
	[self addUniversityId:@"paris1" title:@"CROUS Versailles" toRegionId:@"ile_de_france"];
	[self addUniversityId:@"enscachan" title:@"ENS Cachan" toRegionId:@"ile_de_france"];
	[self addUniversityId:@"ensiie" title:@"ENSIIE" toRegionId:@"ile_de_france"];
	[self addUniversityId:@"unpidf" title:@"UNPIdF" toRegionId:@"ile_de_france"];
	[self addUniversityId:@"enc" title:@"École nationale des chartes" toRegionId:@"ile_de_france"];

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
		
		if (self.callback) {
			
			[self.callback goBackFromRegions];
		}
		
		return [RACSignal empty];
	}];
}

- (void)didReceiveMemoryWarning {
	
    [super didReceiveMemoryWarning];
	
    // Dispose of any resources that can be recreated.
}

#pragma mark - Callback

- (void)setCallback:(NSObject<UNMHomeCallback>*)callback {
	
	_callback = callback;
	
	self.universitiesController.callback = callback;
}

- (void)setSelectedRegionId:(NSString*)selectedRegionId {
	
	_selectedRegionId = selectedRegionId;
	
	[self.tableView reloadData];
}

- (void)setSelectedUniversityId:(NSString*)selectedUniversityId {
	
	self.universitiesController.selectedUniversityId = selectedUniversityId;
}

#pragma mark - Internal data

- (UNMRegionData*)getRegionDataById:(NSString*)regionId {
		
	for (UNMRegionData* const regionData in _regionsData) {
		
		if ([regionData.id isEqualToString:regionId]) {
			
			return regionData;
		}
	}
	
	return NULL;
}

- (UNMUniversityData*)getUniversityDataById:(NSString*)universityId {
	
	for (UNMRegionData* const regionData in _regionsData) {
		
		for (UNMUniversityData* const universityData in regionData.universities) {
			
			if ([universityData.id isEqualToString:universityId]) {
				
				return universityData;
			}
		}
	}
	
	return NULL;
}

- (void)addUniversityId:(NSString*)id title:(NSString*)title toRegionId:(NSString*)regionId {
	
	UNMRegionData* const regionData = [self getRegionDataById:regionId];
	
	if (regionData) {
		
		[regionData addUniversityWithId:id title:title];
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
	
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	
    return section == 0 ? [self.regionsData count] : 0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"region"];
	
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"region"];
    }
	
	const NSUInteger row = [indexPath row];
	
	const UNMRegionData* const regionData = [self.regionsData objectAtIndex:row];

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

	const UNMRegionData* const regionData = [self.regionsData objectAtIndex:row];

	NSString* const oldSelectedRegionId = self.selectedRegionId;
	
	self.selectedRegionId = regionData.id;
	
	if (![regionData.id isEqualToString:oldSelectedRegionId]) {
		self.universitiesController.selectedUniversityId = NULL;
	}
	
	self.universitiesController.regionData = regionData;
	
	@weakify(self)
	
	dispatch_async(dispatch_get_main_queue(), ^{
		
		@strongify(self)
		
		[self.navigationController pushViewController:self.universitiesController animated:YES];
	});
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
