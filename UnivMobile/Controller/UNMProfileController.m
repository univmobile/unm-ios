//
//  UNMProfileController.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 29/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMProfileController.h"
#import "UIBarButtonItem+UIAccessibility.h"
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import <EXTScope.h>

@interface UNMProfileController () <UIActionSheetDelegate>

@end

@implementation UNMProfileController

@synthesize appLayer = _appLayer;

- (instancetype)initWithAppLayer:(UNMAppLayer*)appLayer {
	
    self = [super initWithStyle:UITableViewStylePlain];
    
	if (self) {
		
		_appLayer = appLayer;
		
		[appLayer addCallback:self];
    }
    
	return self;
}

// Override: UIViewController
- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];//
	//[UNMConstants RGB_9bc9e1];
	
	self.title = @"Profile";
	
	UIBarButtonItem* const rightBarButton = [[UIBarButtonItem alloc]
											 initWithTitle:@"Retour"
											 style:UIBarButtonItemStyleBordered
											 target:nil
											 action:nil];
	rightBarButton.accessibilityIdentifier = @"button-retour";
	
	self.navigationItem.rightBarButtonItem = rightBarButton;

	@weakify(self)
	
	rightBarButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
		
		@strongify(self)
		
		[self.appLayer goBackFromProfile];
		
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
	
    return 1;
}

// Override: UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	
    return 3 + self.user.sizeOfTwitterFollowers;
}

// Override: UITableViewDataSource
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	
	const NSUInteger row = indexPath.row;
	const BOOL isUidCell = (row == 0);
	const BOOL isDisplayNameCell = NO; // (row == 1);
	const BOOL isEmailCell = (row == 1);
	const BOOL isLogoutCell = (row >= 2 + self.user.sizeOfTwitterFollowers);
	const BOOL isTwitterFollowerCell = (row > 1) && !isLogoutCell;
	//const BOOL isMapCell = (row == [self.details count] + 1);
	//UNMDetail* const detail = isNameCell || isMapCell ? nil : [self.details objectAtIndex:row -1];
	
	UNMTwitterFollower* const twitterFollower = isTwitterFollowerCell
	 ? [self.user twitterFollowerAtIndex:row - 2]
		: nil;

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:(isLogoutCell?@"logout":@"profile")];
	
    if (!cell) {
		
		if (isLogoutCell) {
			
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"logout"];
			
			cell.userInteractionEnabled = YES; // Clicking the "Logout" cell ends the app session
			
		} else {
			
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"profile"];
				
			cell.userInteractionEnabled = NO; // By default, cell are not interactive
		}
		
		/*
			if (detail == nil || ![@"coordinates" isEqualToString:detail.id]) {
				
				cell.userInteractionEnabled = NO; // By default, cell are not interactive
				
			} else {
				
				cell.userInteractionEnabled = YES; // Clicking the "coordinates" cell makes recenter the map
			}
		}*/
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
	
	if (isUidCell) {
		cell.textLabel.accessibilityIdentifier = @"table-profile-uid";
	} else if (isDisplayNameCell) {
		cell.textLabel.accessibilityIdentifier = @"table-profile-displayName";
	} else if (isEmailCell) {
		cell.textLabel.accessibilityIdentifier = @"table-profile-email";
	} else if (isLogoutCell) {
		cell.textLabel.accessibilityIdentifier = @"table-profile-logout";
	}
	
	//NSLog(@"cell.textLabel.accessibilityIdentifier: %@",cell.textLabel.accessibilityIdentifier);
	
	//cell.userInteractionEnabled = NO;
	
	// cell.detailTextLabel.textColor = [UIColor redColor];
	
	//cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // TODO use a custom PNG image
	
    //cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
	// cell.textLabel.font = [UIFont systemFontOfSize:18.0];
	
	cell.detailTextLabel.text = nil; // Clear old value
	
	/*if (isUidCell) {
		cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
		cell.textLabel.textAlignment = NSTextAlignmentCenter;
		cell.textLabel.textColor = [UIColor blackColor];
		cell.textLabel.text = self.user.uid;
		//cell.backgroundColor = [UNMConstants RGB_9bc9e1];
	} else {*/
		cell.textLabel.font = [UIFont systemFontOfSize:12.0];
		cell.textLabel.textColor = [UIColor lightGrayColor];
		if (isUidCell) {
			cell.textLabel.text = @"uid";
		} else if (isDisplayNameCell) {
			cell.textLabel.text = @"Nom";
		} else if (isEmailCell) {
			cell.textLabel.text = @"e-mail";
		} else if (isLogoutCell) {
			cell.textLabel.font = [UIFont systemFontOfSize:16.0];
			cell.textLabel.textAlignment = NSTextAlignmentCenter;
			cell.textLabel.textColor = [UIColor blackColor];
			cell.textLabel.text = @"Déconnexion";
		} else if (isTwitterFollowerCell) {
			cell.textLabel.text = [@"Twitter Follower: " stringByAppendingString:twitterFollower.screenName];
		}
			
		cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
		//cell.detailTextLabel.textColor = [UIColor greenColor];
		if (isUidCell) {
			cell.detailTextLabel.text = self.user.uid;
		} else if (isDisplayNameCell) {
			cell.detailTextLabel.text = self.user.displayName;
		} else if (isEmailCell) {
			cell.detailTextLabel.text = self.user.email;
		} else if (isTwitterFollowerCell) {
			cell.detailTextLabel.text = twitterFollower.name;
		}
	//}
	
    return cell;
}

// Override: UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	
	const NSUInteger row = indexPath.row;
	const BOOL isLogoutCell = (row == 2);
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (isLogoutCell) {
		
		UIActionSheet* const actionSheet = [[UIActionSheet alloc]
											initWithTitle: [NSString
															stringWithFormat:
															@"Déconnexion du compte %@", self.appLayer.appToken.user.uid]
											delegate: self
											cancelButtonTitle: @"Annuler"
											destructiveButtonTitle: @"OK"
											otherButtonTitles: nil
											];
		
		[actionSheet showInView:self.view];
	}
}

// Override: UIActionSheetDelegate
- (void) actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == [actionSheet destructiveButtonIndex]) {
		
		[self.appLayer logout];
	}
}

// Override: UNMAppViewCallback
- (void)callbackGoFromLoginClassicToProfile {
	
	// NSLog(@"UNMProfileController:callbackGoFromLoginClassicToProfile()");
	
	self.user = self.appLayer.appToken.user;
	
	self.title = self.user.displayName;
	
	// NSLog(@"uid: %@", self.user.uid);
	// NSLog(@"  displayName: %@", self.user.displayName);
	// NSLog(@"  email: %@", self.user.email);
	
	[self.tableView reloadData];
}

@end
