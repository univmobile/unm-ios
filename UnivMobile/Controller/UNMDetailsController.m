//
//  UNMDetailsController.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 01/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMDetailsController.h"
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import <EXTScope.h>
#import "UIBarButtonItem+UIAccessibility.h"
#import "UNMConstants.h"

@interface UNMDetail : NSObject

@property (copy, nonatomic, readonly) NSString* id;
@property (copy, nonatomic, readonly) NSString* label;
@property (copy, nonatomic, readonly) NSString* value;

- (instancetype) initWithId:(NSString*)id label:(NSString*)label value:(NSString*)value;

@end

@implementation UNMDetail

- (instancetype) initWithId:(NSString*)id label:(NSString*)label value:(NSString*)value {
	
    self = [super init];
    
	if (self) {
		
		_id = id;
		_label = label;
		_value = value;
	}
	
	return self;
}

@end

@interface UNMDetailsController ()

@property (strong, nonatomic) NSMutableArray* details; // Array of NSDetail*

@end

@implementation UNMDetailsController

@synthesize appLayer = _appLayer;

- (instancetype)initWithAppLayer:(UNMAppLayer*)appLayer {
	
    self = [super initWithStyle:UITableViewStylePlain];
    
	if (self) {
		
		_appLayer = appLayer;
		
		// [self.appLayer addCallback:self];
		
		self.tabBarItem = [[UITabBarItem alloc] //initWithTitle:@"Plan"
						   initWithTitle:NULL
						   image:[UIImage imageNamed:@"info.png"] tag:1];
		
		self.tabBarItem.accessibilityLabel = @"Détails";
		
		//self.tabSelected = NO;
		
		//self.selectedPoi = NULL;
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
	
	if (self.poi) {
		
		self.poi = self.poi; // set self.title
		
	} else {
		
		self.tabBarController.title = @"(Unknown)"; // e.g. @"Université Paris Diderot"
	}
	
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

// Override
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
}

- (void) setPoi:(UNMPoiData*)poi {
	
	self.tabBarController.title = poi.name; // e.g. @"Université Paris Diderot"
	
	_poi = poi;
	
	self.details = [[NSMutableArray alloc] init];
	
	[self addToDetails:self.details label:@"Emplacement" id:@"floor" value:poi.floor];
	[self addToDetails:self.details label:@"Horaires" id:@"openingHours" value:poi.openingHours];
	[self addToDetails:self.details label:@"Téléphone" id:@"phone" value:poi.phone];
	[self addToDetails:self.details label:@"Adresse" id:@"address" value:poi.address];
	[self addToDetails:self.details label:@"E-mail" id:@"email" value:poi.email];
	[self addToDetails:self.details label:@"Accès" id:@"itinerary" value:poi.itinerary];
	[self addToDetails:self.details label:@"Site web" id:@"url" value:poi.url];
	[self addToDetails:self.details label:@"Coordonnées Lat/Lng" id:@"coordinates" value:poi.coordinates];

	[self.tableView reloadData];
}

- (void) addToDetails:(NSMutableArray*)details label:(NSString*)label id:(NSString*)id value:(NSString*)value {

	if (value == NULL) return;
	
	if ([[value
		  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""
		 ]) return;
	
	[details addObject:[[UNMDetail alloc] initWithId:id label:label value:value]];
}

#pragma mark - Table view data source

// Override: UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
	
    return 1;
}

// Override: UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	
    return 2 + [self.details count];
}

// Override: UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	
	const NSUInteger row = indexPath.row;
	
	const BOOL isNameCell = (row == 0);
	const BOOL isMapCell = (row == [self.details count] + 1);
	
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:(isMapCell?@"map":@"detail")];
	
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(isMapCell?UITableViewCellStyleDefault:UITableViewCellStyleSubtitle) reuseIdentifier:(isMapCell?@"map":@"detail")];
    }
	
	/*
	cell.backgroundColor = [UIColor whiteColor];
	cell.contentView.backgroundColor = [UIColor whiteColor];
	cell.textLabel.backgroundColor = [UIColor whiteColor];
	cell.detailTextLabel.backgroundColor = [UIColor whiteColor];
	cell.textLabel.text = [UIColor whiteColor];
	cell.detailTextLabel.backgroundColor = [UIColor whiteColor];
	 */
	
	// For details, see:
	// https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/iPhoneAccessibility/Making_Application_Accessible/Making_Application_Accessible.html
	//
	cell.isAccessibilityElement = NO; // Important.
	cell.textLabel.isAccessibilityElement = YES;
	cell.textLabel.accessibilityElementsHidden = NO;
	
	UNMDetail* const detail = isNameCell || isMapCell ? NULL : [self.details objectAtIndex:row -1];
	
	if (isNameCell) {
		cell.textLabel.accessibilityIdentifier = @"table-details-name";
	} else if (isMapCell) {
		cell.textLabel.accessibilityIdentifier = @"table-details-map";
	} else {
		cell.textLabel.accessibilityIdentifier = [@"table-details-" stringByAppendingString:detail.id];
	}
	
	//NSLog(@"cell.textLabel.accessibilityIdentifier: %@",cell.textLabel.accessibilityIdentifier);
	
	cell.userInteractionEnabled = NO;
	
	// cell.detailTextLabel.textColor = [UIColor redColor];
	
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // TODO use a custom PNG image
	
    //cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
	// cell.textLabel.font = [UIFont systemFontOfSize:18.0];
	
	cell.detailTextLabel.text = NULL; // Clear old value

	if (isNameCell) {
		cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
		cell.textLabel.textAlignment = NSTextAlignmentCenter;
		cell.textLabel.textColor = [UIColor blackColor];
		cell.textLabel.text = self.poi.name;
		//cell.backgroundColor = [UNMConstants RGB_9bc9e1];
	} else if (isMapCell) {
		//cell.textLabel.text = @"MAP";
	} else if (detail == NULL){
		cell.textLabel.text = @"???";
	} else {
		cell.textLabel.font = [UIFont systemFontOfSize:12.0];
		cell.textLabel.textColor = [UIColor lightGrayColor];
		cell.textLabel.text = detail.label;
		cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
		//cell.detailTextLabel.textColor = [UIColor greenColor];
		cell.detailTextLabel.text = detail.value;
	}
	
    return cell;
}

@end
