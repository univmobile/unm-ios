//
//  UNMUniversitySelectionViewController.m
//  unm-ios
//
//  Created by UnivMobile on 2/20/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMUniversitySelectionViewController.h"
#import "UNMUniversityBasic.h"
#import "UIScrollView+ScrollIndicator.h"
#import "UNMScrollIndicatorHelper.h"
#import "UNMUniversitySelectionViewController.h"
#import "UIColor+Extension.h"
#import "UNMUnivSelectTableViewCell.h"
#import "UNMUtilities.h"
#import "UNMRegionBasic.h"
#import "UIColor+Extension.h"

@interface UNMUniversitySelectionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *curentUnivAnotLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentUnivLabel;
@property (strong, nonatomic) NSArray *universities;
@property (strong, nonatomic) UNMScrollIndicatorHelper *scrollHelper;
@property (strong, nonatomic) UIView *activityIndicatorView;
@end

@implementation UNMUniversitySelectionViewController {
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _scrollHelper = [UNMScrollIndicatorHelper new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor univSelectDarkerPurple];
    UNMUniversityBasic *univ = [UNMUniversityBasic getSavedObject];
    if (univ) {
        self.currentUnivLabel.text = [univ title];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initActivityIndicator];
    [UNMUniversityBasic fetchUniversitiesWithSuccess:^(NSArray *items) {
        self.universities = items;
        [self.tableView reloadData];
        [self removeActivityIndicator];
    } failure:^{
        [self removeActivityIndicator];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.scrollHelper  setUpScrollIndicatorWithScrollView:self.tableView andColor:[UIColor whiteColor]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView refreshCustomScrollIndicatorsWithAlpha:1.0];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.25 animations:^{
        [scrollView refreshCustomScrollIndicatorsWithAlpha:0.0];
    }];
}

#pragma mark - TableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.universities count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - TableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UNMUnivSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"universityCell" forIndexPath:indexPath];
    if (indexPath.row < [self.universities count]) {
        UNMUniversityBasic *univ = self.universities[indexPath.row];
        cell.titleLabel.text = univ.title;
        cell.backgroundColor = [UIColor middleTabPurple];
        cell.separator.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < [self.universities count]) {
        [self initActivityIndicator];
        UNMUniversityBasic *univ = self.universities[indexPath.row];
        [UNMRegionBasic fetchRegionWithPath:univ.regionUrl success:^(UNMRegionBasic *region) {
            [univ saveToUserDefaults];
            [region saveToUserDefaults];
            self.currentUnivLabel.text = [univ title];
            if ([self.delegate respondsToSelector:@selector(setSelectedUniversityString:)]) {
                [self.delegate setSelectedUniversityString:[univ title]];
            }
            [self removeActivityIndicator];
        } failure:^{
            [self removeActivityIndicator];
        }];
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

- (IBAction)closeSelected:(id)sender {
    if ([self.delegate respondsToSelector:@selector(closeUnivSelect)]) {
        [self.delegate closeUnivSelect];
    }
}

@end
