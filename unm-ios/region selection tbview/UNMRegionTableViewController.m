//
//  UNMRegionTableViewController.m
//  unm-ios
//
//  Created by UnivMobile on 1/12/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMRegionTableViewController.h"
#import "UNMUniversitySelectionTableViewController.h"
#import "AFNetworking.h"
#import "UNMRegionBasic.h"
#import "UNMUtilities.h"
#import "UIColor+Extension.h"

@interface UNMRegionTableViewController ()
@property (strong, nonatomic) NSMutableArray *regions;
@property (strong, nonatomic) UNMRegionBasic *selectedRegion;
@property (strong, nonatomic) UIView *activityIndicatorView;
@end

@implementation UNMRegionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Retour"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:nil
                                                                action:nil];
    
    [self.navigationItem setBackBarButtonItem:backItem];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.regions = [NSMutableArray new];
    
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
    [self initActivityIndicator];
    [UNMUtilities fetchFromApiWithPath:@"regions" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *embedded = responseObject[@"_embedded"];
        if ([embedded class] != [NSNull class]) {
            NSArray *objects = embedded[@"regions"];
            if ([objects class] != [NSNull class]) {
                for (NSDictionary *object in objects) {
                    NSString *title = object[@"name"];
                    NSString *label = object[@"label"];
                    NSDictionary *links = object[@"_links"];
                    NSString *universitiesURL = links[@"universities"][@"href"];
                    NSNumber *ID = object[@"id"];
                    if (ID != nil && title != nil && label != nil && [title class] != [NSNull class] && [label class] != [NSNull class] && [ID class] != [NSNull class]) {
                        UNMRegionBasic *region = [[UNMRegionBasic alloc]initWithTitle:title andLabel:label andUniversitiesURL:universitiesURL andID:ID];
                        [self.regions addObject:region];
                    }
                }
                [self.tableView reloadData];
            }
        }
        [self removeActivityIndicator];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [UNMUtilities showErrorWithTitle:@"Impossible d'accéder aux informations" andMessage:@"Merci de vérifier que vous êtes connecté à internet" andDelegate:nil];
        [self removeActivityIndicator];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.regions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"regionCell" forIndexPath:indexPath];
    
    UNMRegionBasic *region = self.regions[indexPath.row];
    
    cell.textLabel.text = region.title;
    
    cell.textLabel.adjustsFontSizeToFitWidth=YES;
    cell.textLabel.minimumScaleFactor=0.5;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRegion = self.regions[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"university" sender:self];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"university"]) {
        UNMUniversitySelectionTableViewController *univTBV = (UNMUniversitySelectionTableViewController *)segue.destinationViewController;
        univTBV.region = self.selectedRegion;
    }
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
