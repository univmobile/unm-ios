//
//  UNMNotificationsViewController.m
//  unm-ios
//
//  Created by UnivMobile on 1/16/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMNotificationsTableViewController.h"
#import "UNMNotificationTableViewCell.h"
#import "UNMUtilities.h"
#import <AFNetworking.h>
#import "NSString+URLEncoding.h"
#import "UNMUniversityBasic.h"
#import "NSDate+notificationDate.h"
#import "UNMConstants.h"
#import "UNMNotificationBasic.h"

@interface UNMNotificationsTableViewController ()
@property (strong, nonatomic) NSCache *offscreenCells;
@property (strong, nonatomic) NSArray *notifications;
@property (strong, nonatomic) UIView *activityIndicatorView;
@end

@implementation UNMNotificationsTableViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _offscreenCells = [NSCache new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"notificationCell" bundle:nil] forCellReuseIdentifier:@"notificationCell"];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.font = [UIFont fontWithName:@"Exo-Regular" size:20.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Notifications";
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.navigationItem setTitleView:titleLabel];
    [self.tableView setTableHeaderView:[self createHeaderForTableView]];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgSideMenu"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initActivityIndicator];
    NSDate *lastFetchDate = [NSDate getSavedNotificationDate];
    if (lastFetchDate) {
        [UNMNotificationBasic fetchMonthOldNotificationsWithSuccess:^(NSArray *notifs) {
            self.notifications = notifs;
            UNMNotificationBasic *notification = [self.notifications firstObject];
            [notification postAsRead];
            [self.tableView reloadData];
            [self removeActivityIndicator];
        } failure:^{
            [self removeActivityIndicator];
        }];
    } else {
        [UNMNotificationBasic fetchNotificationsWithSuccess:^(NSArray *notifs) {
            self.notifications = notifs;
            UNMNotificationBasic *notification = [self.notifications firstObject];
            [notification postAsRead];
            [self.tableView reloadData];
            [self removeActivityIndicator];
        } failure:^{
            [self removeActivityIndicator];
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)createHeaderForTableView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 44)];
    UILabel *label = [UILabel new];
    label.text = @"notifications:";
    label.font = [UIFont fontWithName:@"Exo-Regular" size:15.0];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    [view addSubview:label];
    
    NSDictionary *viewsDictionary = @{@"label":label};
    
    NSArray *constraint_Hor = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[label]-8-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:viewsDictionary];
    
    NSArray *constraint_Vert = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[label]-8-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:viewsDictionary];
    
    [view addConstraints:constraint_Hor];
    [view addConstraints:constraint_Vert];
    return view;
}



#pragma mark - tableview data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.notifications count];
}

#pragma mark - tableview delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UNMNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notificationCell" forIndexPath:indexPath];
    if (indexPath.row < [self.notifications count]) {
        UNMNotificationBasic *notif = self.notifications[indexPath.row];
        cell.notificationDescription.text = notif.content;
        cell.dateLabel.text = [notif.date getTimeSinceString];
    }
    cell.notificationDescription.textColor = [UIColor whiteColor];
    cell.dateLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"notificationCell";

    UNMNotificationTableViewCell *cell = [self.offscreenCells objectForKey:reuseIdentifier];
    if (!cell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"notificationCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        [self.offscreenCells setObject:cell forKey:reuseIdentifier];
    }
    
    NSString *content = @"";
    if (indexPath.row < [self.notifications count]) {
        UNMNotificationBasic *notif = self.notifications[indexPath.row];
        content = notif.content;
    }
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName: cell.notificationDescription.font}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){CGRectGetWidth(tableView.bounds)-cell.notifLeading.constant-cell.notifTrailing.constant, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize notifSize = rect.size;
    notifSize.height = ceilf(notifSize.height);
    notifSize.width = ceilf(notifSize.width);
    
    notifSize.height += cell.dateLabel.frame.size.height+cell.notifTop.constant + 10.0 + cell.dateBottom.constant;
    
    return notifSize.height;
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
