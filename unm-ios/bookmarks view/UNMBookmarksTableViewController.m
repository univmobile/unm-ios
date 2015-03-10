//
//  UNMBookmarksTableViewController.m
//  unm-ios
//
//  Created by UnivMobile on 1/27/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMBookmarksTableViewController.h"
#import "UNMBookmarksTableViewCell.h"
#import "UNMBookmarkBasic.h"
#import "UNMMapItemBasic.h"
#import "UNMUtilities.h"


@interface UNMBookmarksTableViewController ()
@property (strong, nonatomic) NSArray *bookmarks;
@property (strong, nonatomic) UIView *activityIndicatorView;
@end

@implementation UNMBookmarksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgSideMenu"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initActivityIndicator];
    [UNMBookmarkBasic fetchBookmarksWithSuccess:^(NSArray *items) {
        self.bookmarks = items;
        [self.tableView reloadData];
        [self removeActivityIndicator];
    } failure:^{
        [self removeActivityIndicator];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.bookmarks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UNMBookmarksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookmarkCell" forIndexPath:indexPath];
    
    if (indexPath.row < [self.bookmarks count]) {
        UNMBookmarkBasic *item = self.bookmarks[indexPath.row];
        cell.titleLabel.text = item.poiName;
    } else {
        cell.titleLabel.text = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < [self.bookmarks count]) {
        UNMBookmarkBasic *item = self.bookmarks[indexPath.row];
        [self initActivityIndicator];
        [UNMMapItemBasic fetchMarkerWithMap:nil withUrl:item.poiUrlStr success:^(UNMMapItemBasic *mapItem) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UNMUtilities setCenterControllerToMapWithSingleItem:mapItem andTabSelected:item.tab];
                [self removeActivityIndicator];
            });
        } failure:^{
            [self removeActivityIndicator];
        }];

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
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
