//
//  UNMUniversitySelectionTableViewController.m
//  unm-ios
//
//  Created by UnivMobile on 1/12/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMUniversitySelectionTableViewController.h"
#import "AFNetworking.h"
#import "UNMUniversityBasic.h"
#import "UNMUtilities.h"
#import "UNMConstants.h"
#import "UIColor+Extension.h"

@interface UNMUniversitySelectionTableViewController ()
@property (strong, nonatomic) NSArray *universities;
@property (strong, nonatomic) UIView *activityIndicatorView;
@end

@implementation UNMUniversitySelectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.universities = [NSMutableArray new];

    [self fetchDataFromAPI];
    
    [self setTintColor];
}

- (void)setTintColor {
    UINavigationBar *bar = [self.navigationController navigationBar];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [bar setBarTintColor:[UIColor navBarPurple]];
        [bar setTintColor:[UIColor whiteColor]];
    }
}

- (void)fetchDataFromAPI {
    if (self.region.universitiesURL != nil) {
        [self initActivityIndicator];
        [UNMUniversityBasic fetchUniversitiesWithPath:[NSString stringWithFormat:@"universities/search/findAllActiveWithoutCrousByRegion?regionId=%d",[self.region.ID intValue]] andSuccess:^(NSArray *items) {
            self.universities = items;
            [self.tableView reloadData];
            [self removeActivityIndicator];
        } failure:^{
            [self removeActivityIndicator];
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.universities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"universityCell" forIndexPath:indexPath];
    
    UNMUniversityBasic *university = self.universities[indexPath.row];
    
    cell.textLabel.text = university.title;
    
    cell.textLabel.adjustsFontSizeToFitWidth=YES;
    cell.textLabel.minimumScaleFactor=0.5;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UNMUniversityBasic *university = self.universities[indexPath.row];
    
    [university saveToUserDefaults];
    [self.region saveToUserDefaults];
    [university postAsUsageStat];
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)didSelectCancel:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    if (self.navigationController.navigationBarHidden) {
        return UIStatusBarStyleBlackTranslucent;
    }
    return UIStatusBarStyleLightContent;
}

#pragma mark - Activity indicator

- (void)initActivityIndicator {
    if (self.activityIndicatorView == nil) {
        self.activityIndicatorView = [UNMUtilities initActivityIndicatorContainerWithParentView:self.view aboveSubview:self.tableView];
    } else {
        [self.view addSubview:self.activityIndicatorView];
    }
}

- (void)removeActivityIndicator {
    if (self.activityIndicatorView) {
        [self.activityIndicatorView removeFromSuperview];
        self.activityIndicatorView = nil;
    }
}
@end
