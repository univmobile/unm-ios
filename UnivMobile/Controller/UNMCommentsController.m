//
//  UNMCommentsController.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 01/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMCommentsController.h"
#import "UNMCommentData.h"
#import "UNMPoiData.h"
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import <EXTScope.h>

@interface UNMCommentsController ()

@property (assign, nonatomic) BOOL tabSelected;
@property (weak, nonatomic, readonly) UNMDetailsController* detailsController;
@property (strong, nonatomic) NSArray* comments; // Array of UNMCommentData*

@end

@implementation UNMCommentsController

@synthesize appLayer = _appLayer;

- (instancetype)initWithAppLayer:(UNMAppLayer*)appLayer
			   detailsController:(UNMDetailsController*)detailsController {
	
    self = [super initWithStyle:UITableViewStylePlain];
    
	if (self) {
		
		_appLayer = appLayer;
		
		_detailsController = detailsController;
		
		// [self.appLayer addCallback:self];
		
		self.tabBarItem = [[UITabBarItem alloc] //initWithTitle:@"Plan"
						   initWithTitle:nil
						   image:[UIImage imageNamed:@"text-left.png"] tag:1];
		
		self.tabBarItem.accessibilityLabel = @"Commentaires";
		
		self.tabSelected = NO;
		
		[RACObserve(detailsController, poi) subscribeNext:^(UNMPoiData* poi) {
			
			if (!poi  || !self.appLayer.poisData) return;
			
			self.comments = [self.appLayer loadCommentsForPoi:poi];
			
			[self.tableView reloadData];
		}];
    }
    
	return self;
}

// Override: UIViewController
- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];
}

// Override: UIViewController
- (void)didReceiveMemoryWarning {
	
    [super didReceiveMemoryWarning];
}

#pragma mark - UITabBarControllerDelegate

// Override: UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController*)tabBarController didSelectViewController:(UIViewController*)viewController {
	
	//NSLog(@"didSelectViewController");
		
	if (viewController != self) {
		
		self.tabSelected = NO;
		
		return;
	}
	
	//NSLog(@"didSelectViewController: MAP %d", self.tabSelected);
	
	// Note: We reload the data each time the tab bar item is tapped,
	// even when the tab is already selected.
	
	 if (!self.tabSelected) {
		
		self.tabSelected = YES; // do nothing more
	 }
		
	if (!self.detailsController.poi  || !self.appLayer.poisData) return;
		
	self.comments = [self.appLayer loadCommentsForPoi:self.detailsController.poi];
	
	[self.tableView reloadData];
}

#pragma mark - Table view data source

// Override: UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
	
    return 1;
}

// Override: UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	
    return 1 + [self.comments count];
}

// Override: UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	
	const NSUInteger row = indexPath.row;
	const BOOL isNameCell = (row == 0);
	
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"comment"];
	
    if (!cell) {
		
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"comment"];
    }
	
	// For details, see:
	// https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/iPhoneAccessibility/Making_Application_Accessible/Making_Application_Accessible.html
	//
	cell.isAccessibilityElement = NO; // Important.
	cell.textLabel.isAccessibilityElement = YES;
	cell.textLabel.accessibilityElementsHidden = NO;
	
	cell.textLabel.accessibilityIdentifier =
	[NSString stringWithFormat:@"table-comments-%lu", (unsigned long) row];
	
	//NSLog(@"cell.textLabel.accessibilityIdentifier: %@",cell.textLabel.accessibilityIdentifier);
	
	//cell.userInteractionEnabled = NO;
	
	// cell.detailTextLabel.textColor = [UIColor redColor];
	
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // TODO use a custom PNG image
	
    //cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
	// cell.textLabel.font = [UIFont systemFontOfSize:18.0];
	
	cell.detailTextLabel.text = nil; // Clear old value
	
	if (isNameCell) {
		
		const NSUInteger count = [self.comments count];
		
		switch (count) {
			case 0:
				cell.textLabel.font = [UIFont italicSystemFontOfSize:16.0];
				cell.textLabel.textColor = [UIColor lightGrayColor];
				cell.textLabel.text = @"Aucun commentaire";
				break;
			case 1:
				cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
				cell.textLabel.textColor = [UIColor lightGrayColor];
				cell.textLabel.text = @"Un commentaire";
				break;
			default:
				cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
				cell.textLabel.textColor = [UIColor lightGrayColor];
				cell.textLabel.text = [NSString stringWithFormat:@"%lu commentaires", (unsigned long) count];
				break;
		}
		//cell.textLabel.textAlignment = NSTextAlignmentCenter;
		
		//cell.backgroundColor = [UNMConstants RGB_9bc9e1];
		
	} else {
		
		UNMCommentData* const comment = [self.comments objectAtIndex:row - 1];
		
		cell.textLabel.font = [UIFont boldSystemFontOfSize:12.0];
		cell.textLabel.textColor = [UIColor blackColor];
		cell.textLabel.text = comment.authorDisplayName;
		cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
		//cell.detailTextLabel.textColor = [UIColor greenColor];
		cell.detailTextLabel.text = [comment.text
									 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	}
	
    return cell;
}

@end
