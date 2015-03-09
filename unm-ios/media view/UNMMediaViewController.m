//
//  UNMMediaViewController.m
//  unm-ios
//
//  Created by UnivMobile on 1/23/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMMediaViewController.h"
#import "UNMMediaTableViewCell.h"
#import "UNMConstants.h"
#import "UNMMediaItemBasic.h"
#import "UNMUnivNewsWebViewController.h"
#import "UNMUtilities.h"

@interface UNMMediaViewController ()
@property (strong, nonatomic) NSArray *mediaItems;
@property (strong, nonatomic) NSURL *webviewURL;
@property (strong, nonatomic) UIView *activityIndicatorView;
@end

@implementation UNMMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initActivityIndicator];
    [UNMMediaItemBasic fetchMediaItemsWithSuccess:^(NSArray *items) {
        self.mediaItems = items;
        [self.tableView reloadData];
        [self removeActivityIndicator];
    } failure:^{
        [self removeActivityIndicator];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mediaItems count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UNMMediaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mediaCell" forIndexPath:indexPath];
    if (indexPath.row < [self.mediaItems count]) {
        UNMMediaItemBasic *item = self.mediaItems[indexPath.row];
        cell.titleLabel.text = item.label;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.mediaItems count]) {
        UNMMediaItemBasic *item = self.mediaItems[indexPath.row];
        self.webviewURL = [NSURL URLWithString:item.urlStr];
        [self performSegueWithIdentifier:@"webview" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"webview"]) {
        UNMUnivNewsWebViewController *vc = [segue destinationViewController];
        if (self.webviewURL) {
            vc.articleURL = self.webviewURL;
        }
    }
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
