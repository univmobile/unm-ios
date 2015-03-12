//
//  UNMLibraryViewController.m
//  unm-ios
//
//  Created by UnivMobile on 1/22/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMLibraryViewController.h"
#import "UNMLibraryTableViewCell.h"
#import "UNMUniversityBasic.h"
#import "UNMConstants.h"
#import "UNMMapItemBasic.h"
#import "UNMUtilities.h"
#import "UNMUnivLibraryItem.h"

@interface UNMLibraryViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBarHeightConst;
@property (strong, nonatomic) NSCache *offscreenCells;
@property (strong, nonatomic) NSCache *offscreenCellHeights;
@property (strong, nonatomic) NSArray *libraryItems;
@property (strong, nonatomic) UIView *activityIndicatorView;
@end

@implementation UNMLibraryViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _offscreenCells = [NSCache new];
        _offscreenCellHeights = [NSCache new];
    }
    return self;
}
- (IBAction)addSelected:(id)sender {
    [UNMUtilities setCenterControllerToMapWithCategoryID:[NSNumber numberWithInt:7]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initActivityIndicator];
    [UNMUnivLibraryItem fetchLibraryItemsWithSuccess:^(NSArray *items) {
        self.libraryItems = items;
        [self.tableView reloadData];
        [self removeActivityIndicator];
    } failure:^{
        [self removeActivityIndicator];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.libraryItems count] == 0) {
        return 1;
    }
    else {
        return [self.libraryItems count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    NSNumber *height = [self.offscreenCellHeights objectForKey:indexPath];
    if (!height) {
        NSString *reuseIdentifier = @"libraryCell";
        UNMLibraryTableViewCell *cell = [self.offscreenCells objectForKey:reuseIdentifier];
        if (!cell) {
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"libraryCell"];
            [self.offscreenCells setObject:cell forKey:reuseIdentifier];
        }
        UNMUnivLibraryItem *item;
        if (indexPath.row < [self.libraryItems count]) {
            item = self.libraryItems[indexPath.row];
            cell.titleLabel.text = item.poiName;
        } else {
            cell.titleLabel.text = @"Pas de bibliothèque";
        }
        
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        
        cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(cell.bounds));
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        
        height = [NSNumber numberWithFloat:cell.titleTopConst.constant + cell.titleLabel.frame.size.height + kTitleLabelBottomPadding];
        if (item && item.ruedesfacs) {
            height = [NSNumber numberWithFloat:[height floatValue] + cell.logoTopConst.constant + cell.logoHeightConst.constant];
        }
        if ([height floatValue] < cell.pinIconHeightConst.constant + kPinIconVerticalPadding*2) {
            height = [NSNumber numberWithFloat:cell.pinIconHeightConst.constant + kPinIconVerticalPadding*2];
        }
        
        height = [NSNumber numberWithFloat:[height floatValue]+1.0f];
        
        [self.offscreenCellHeights setObject:height forKey:indexPath];
    }
    
    return [height floatValue];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UNMLibraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"libraryCell" forIndexPath:indexPath];
    if ([self.libraryItems count] == 0) {
        [cell removeLogo];
        [cell centerLabelToPinIcon];
        cell.titleLabel.text = @"Pas de bibliothèque";
        cell.pinIcon.hidden = YES;
    }
    else if (indexPath.row < [self.libraryItems count]) {
        UNMUnivLibraryItem *item = self.libraryItems[indexPath.row];
        cell.titleLabel.text = item.poiName;
        cell.pinIcon.hidden = NO;
        if (!item.ruedesfacs) {
            [cell removeLogo];
            [cell centerLabelToPinIcon];
        } else {
            [cell addLogo];
            [cell removeCenterLabelToPinIcon];
        }
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < [self.libraryItems count]) {
        UNMUnivLibraryItem *item = self.libraryItems[indexPath.row];
        [self initActivityIndicator];
        [UNMMapItemBasic fetchMarkerWithMap:nil withUrl:[NSString stringWithFormat:@"pois/%d",[item.poiID intValue]] success:^(UNMMapItemBasic *mapItem) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UNMUtilities setCenterControllerToMapWithSingleItem:mapItem andTabSelected:MapTabLeft];
                [self removeActivityIndicator];
            });
        } failure:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeActivityIndicator];
            });
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
@end
