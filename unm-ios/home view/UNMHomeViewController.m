//
//  UNMHomeViewController.m
//  unm-ios
//
//  Created by UnivMobile on 1/13/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMHomeViewController.h"
#import "UNMAppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "UNMNewsTableViewCell.h"
#import "UNMMapItemBasic.h"
#import "UNMUtilities.h"
#import "UNMConstants.h"
#import "UNMNewsBasic.h"
#import "NSDate+notificationDate.h"
#import "UNMUnivNewsWebViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UNMProfileFooterTableViewCell.h"
#import "UNMRegionBasic.h"
#import "UNMHomePageNewsHeader.h"
#import "UNMHomePageMapFooter.h"
#import "UNMSideMenuViewController.h"
#import "UNMMenuItemBasic.h"

@interface UNMHomeViewController ()
@property NSIndexPath *selectedCell;
@property CGFloat closedTableViewHeight;
@property (strong, nonatomic) NSArray *newsItems;
@property (strong, nonatomic) UIView *activityIndicatorView;
@property (strong, nonatomic) NSCache *offscreenCells;
@property (strong, nonatomic) NSCache *offscreenCellHeights;
@property (strong, nonatomic) NSURL *webviewURL;
@property (strong, nonatomic) UNMMapViewController *mapView;
@end

@implementation UNMHomeViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _newsItems = [NSArray new];
        _offscreenCellHeights = [NSCache new];
        _offscreenCells = [NSCache new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationItem setHidesBackButton:YES];
    self.closedTableViewHeight = self.newsTableViewHeightConst.constant;
    self.newsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UNMAppDelegate *appDelegate = (UNMAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.view addGestureRecognizer:[appDelegate.container panGestureRecognizer]];
    self.newsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self showMap];
}

- (void)showMap {
    [UNMMenuItemBasic fetchMenuItemsWithSuccess:^(NSArray *items) {
        [self handleMenuItems:items];
    } failure:^{}];
}

- (void)handleMenuItems:(NSArray *)items {
    BOOL showFirstTab = NO;
    BOOL showSecondTab = NO;
    BOOL showThirdTab = NO;
    for (UNMMenuItemBasic *item in items) {
        if ([item.name isEqualToString:@"GéoCampus"]) {
            showFirstTab = YES;
        }
        if ([item.name isEqualToString:@"Que faire à Paris"]) {
            showSecondTab = YES;
        }
        if ([item.name isEqualToString:@"Les bons plans"]) {
            showThirdTab = YES;
        }
    }
    if (showFirstTab || showSecondTab || showThirdTab) {
        [self loadStaticMapImageShowFirstTab:showFirstTab showSecondTab:showSecondTab showThirdTab:showThirdTab];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initActivityIndicator];

    [UNMNewsBasic fetch4NewsItemsWithSuccess:^(NSArray *items) {
        self.newsItems = items;
        UNMNewsBasic *first = [self.newsItems firstObject];
        if (first) {
            UNMHomePageNewsHeader *newsHeader = [[[NSBundle mainBundle] loadNibNamed:@"UNMHomePageNewsHeader" owner:self options:nil] firstObject];
            if (newsHeader) {
                newsHeader.titleLabel.text = first.name;
                newsHeader.titleBodyLabel.text = first.desc;
                if (first.feedName && [first.feedName class] != [NSNull class]) {
                    newsHeader.dateLabel.text = [NSString stringWithFormat:@"%@ %@",[first feedName],[first.date newsCellDateString]];
                }
                else {
                    newsHeader.dateLabel.text = [NSString stringWithFormat:@"%@",[first.date newsCellDateString]];
                }
                if ([first.thumbURLStr class] != [NSNull class]) {
                    [newsHeader.topImageView setImageWithURL:[NSURL URLWithString:first.thumbURLStr]];
                }
                self.newsTableView.tableHeaderView = newsHeader;
                [self sizeHeaderToFit];
            }
        }
        [self.newsTableView reloadData];
        [self removeActivityIndicator];
    } failure:^{
        [self removeActivityIndicator];
    }];
}

- (UNMMapViewController *)loadStaticMapImageShowFirstTab:(BOOL)showFirst showSecondTab:(BOOL)showSecond showThirdTab:(BOOL)showThird {
    if (self.mapView == nil) {
        UNMHomePageMapFooter *mapFooter = [[[NSBundle mainBundle] loadNibNamed:@"UNMHomePageMapFooter" owner:self options:nil] firstObject];
        if (mapFooter) {
            self.mapView = [self.storyboard instantiateViewControllerWithIdentifier:@"mapview"];
            self.mapView.forHomeView = YES;
            [self addChildViewController:self.mapView];
            self.mapView.view.translatesAutoresizingMaskIntoConstraints = NO;
            [mapFooter.mapPlaceholder addSubview:self.mapView.view];
            [self.mapView didMoveToParentViewController:self];
            
            
            NSArray *constraint_Horz = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[slideout]-0-|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:@{@"slideout":self.mapView.view}];
            NSArray *constraint_Vert = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[slideout]-0-|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:@{@"slideout":self.mapView.view}];
            
            [mapFooter.mapPlaceholder addConstraints:constraint_Horz];
            [mapFooter.mapPlaceholder addConstraints:constraint_Vert];
            mapFooter.mapPlaceholder.userInteractionEnabled = NO;
            [mapFooter.leftTab addTarget:self action:@selector(leftTabSelected:) forControlEvents:UIControlEventTouchUpInside];
            [mapFooter.middleTab addTarget:self action:@selector(middleTabSelected:) forControlEvents:UIControlEventTouchUpInside];
            [mapFooter.rightTab addTarget:self action:@selector(rightTabSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            self.newsTableView.tableFooterView = mapFooter;
            CGFloat topBarHeight = 0;
            if (self.navigationController) {
                topBarHeight = self.navigationController.navigationBar.frame.size.height;
                CGRect statusBarRect = [[UIApplication sharedApplication] statusBarFrame];
                topBarHeight += statusBarRect.size.height;
            }
            mapFooter.mapHeight.constant = self.view.bounds.size.height - 90 - topBarHeight; //90 = top geocampus bar and bottom tab button height
            [self sizeFooterToFit];
            [self.newsTableView sizeToFit];
            [UNMUtilities removeFirstTab:!showFirst secondTab:!showSecond thirdTab:!showThird firstTab:mapFooter.leftTab secondTab:mapFooter.middleTab thirdTab:mapFooter.rightTab constrainToView:self.view];
        }
    }
    
    return self.mapView;
}

- (void)sizeHeaderToFit
{
    UIView *header = self.newsTableView.tableHeaderView;
    
    [header setNeedsLayout];
    [header layoutIfNeeded];
    
    CGFloat height = [header systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = header.frame;
    
    frame.size.height = height;
    header.frame = frame;
    
    self.newsTableView.tableHeaderView = header;
}

- (void)sizeFooterToFit
{
    UIView *footer = self.newsTableView.tableFooterView;
    
    [footer setNeedsLayout];
    [footer layoutIfNeeded];
    
    CGFloat height = [footer systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = footer.frame;
    
    frame.size.height = height;
    footer.frame = frame;
    
    self.newsTableView.tableFooterView = footer;
}

#pragma mark - Activity indicator

- (void)initActivityIndicator {
    if (self.activityIndicatorView == nil) {
        self.activityIndicatorView = [UNMUtilities initActivityIndicatorContainerWithParentView:self.view aboveSubview:self.newsTableView];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.newsItems count] > 0) {
        return  [self.newsItems count];
    } else {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.newsItems count]-1) {
            UNMProfileFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"footerCell" forIndexPath:indexPath];
            cell.titleLabel.text = @"VOIR TOUTES LES ACTUALITÉS";
            return cell;
    } else {
        UNMNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell" forIndexPath:indexPath];
        if (indexPath.row+1 < [self.newsItems count]) {
            UNMNewsBasic *item = self.newsItems[indexPath.row+1];
            cell.titleLabel.text = item.name;
            cell.detailLabel.text = item.desc;
            if (item.feedName && [item.feedName class] != [NSNull class]) {
                cell.dateLabel.text = [NSString stringWithFormat:@"%@ %@",[item feedName],[item.date newsCellDateString]];
            }
            else {
                cell.dateLabel.text = [NSString stringWithFormat:@"%@",[item.date newsCellDateString]];
            }
            if (item.thumbURLStr && [item.thumbURLStr class] != [NSNull class]) {
                NSURL *thumbURL = [NSURL URLWithString:item.thumbURLStr];
                if (thumbURL && thumbURL.scheme && thumbURL.host) {
                    [cell.thumbnailImageView setImageWithURL:thumbURL];
                }
            }
        }
        cell.clipsToBounds = YES;
        if (self.selectedCell != nil && [self.selectedCell isEqual:indexPath]) {
            cell.detailLabel.hidden = NO;
            cell.moreButton.hidden = NO;
            [cell rotateDisclosureDown];
        } else {
            cell.detailLabel.hidden = YES;
            cell.moreButton.hidden = YES;
            [cell rotateDisclosureRight];
        }
        cell.delegate = self;
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.newsItems count]-1) {
        return 44.0;
    }
    indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    if (self.selectedCell != nil && [self.selectedCell isEqual:indexPath]) {
        NSString *reuseIdentifier = @"newsCell";
        NSNumber *height;
        indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        height = [self.offscreenCellHeights objectForKey:indexPath];
        if (!height) {
            
            UITableViewCell *cell = [self.offscreenCells objectForKey:reuseIdentifier];
            if (!cell) {
                cell = [self.newsTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
                [self.offscreenCells setObject:cell forKey:reuseIdentifier];
            }
            
            UNMNewsTableViewCell *newsCell = (UNMNewsTableViewCell *)cell;
            if (indexPath.row+1 < [self.newsItems count]) {
                UNMNewsBasic *newsItem = self.newsItems[indexPath.row+1];
                newsCell.titleLabel.text = [newsItem name];
                NSDate *date = [newsItem date];
                if (newsItem.feedName && [newsItem.feedName class] != [NSNull class]) {
                    newsCell.dateLabel.text = [NSString stringWithFormat:@"%@ %@",[newsItem feedName],[date newsCellDateString]];
                }
                else {
                    newsCell.dateLabel.text = [NSString stringWithFormat:@"%@",[date newsCellDateString]];
                }
                newsCell.detailLabel.text = [newsItem desc];
            } else {
                newsCell.titleLabel.text    = @"name";
                newsCell.dateLabel.text    = @"1/1/2015";
                newsCell.detailLabel.text = @"text text text text text text text text text text";
            }
            newsCell.detailLabel.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds);
            newsCell.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds) - CGRectGetWidth(newsCell.thumbnailImageView.frame);
            newsCell.dateLabel.preferredMaxLayoutWidth = CGRectGetWidth(tableView.bounds) - CGRectGetWidth(newsCell.thumbnailImageView.frame);
            
            [cell setNeedsUpdateConstraints];
            [cell updateConstraintsIfNeeded];
            
            cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(cell.bounds));
            [cell setNeedsLayout];
            [cell layoutIfNeeded];
            
            CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            height = [NSNumber numberWithFloat:size.height];
            
            height = [NSNumber numberWithFloat:[height floatValue]+1.0f];
            if (indexPath.row < [self.newsItems count]) {
                [self.offscreenCellHeights setObject:height forKey:indexPath];
            }
        }
        return [height floatValue];
    } else {
        return 106;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.newsItems count]-1) {
        [UNMUtilities setCenterControllerWithViewControllerIdentifier:@"news"];
        return;
    }
    UNMNewsTableViewCell *cell = (UNMNewsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UNMNewsTableViewCell *oldCell;
    [tableView beginUpdates];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectedCell != nil && [self.selectedCell isEqual:indexPath]) { //same cell selected, close it
        self.selectedCell = nil;
        [cell rotateDisclosureRight];
    } else {
        if (self.selectedCell != nil) {
            oldCell = (UNMNewsTableViewCell *)[tableView cellForRowAtIndexPath:self.selectedCell];
            [oldCell rotateDisclosureRight];
        }
        self.selectedCell = indexPath;
        [cell rotateDisclosureDown];
    }
    [tableView endUpdates];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [cell layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                     }];
}

- (void)moreSelectedFromCell:(UNMNewsTableViewCell *)cell {
    NSIndexPath *indexPath = [self.newsTableView indexPathForCell:cell];
    if (indexPath.row+1 < [self.newsItems count]) {
        UNMNewsBasic *item = self.newsItems[indexPath.row+1];
        NSURL *articleURL = [NSURL URLWithString:item.articeURLStr];
        if (articleURL && articleURL.scheme && articleURL.host) {
            self.webviewURL = articleURL;
            [self performSegueWithIdentifier:@"webview" sender:self];
        }
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

- (IBAction)leftTabSelected:(id)sender {
    [UNMUtilities setCenterControllerToMapWithTabSelected:1];
}

- (IBAction)middleTabSelected:(id)sender {
    [UNMUtilities setCenterControllerToMapWithTabSelected:2];
}

- (IBAction)rightTabSelected:(id)sender {
    [UNMUtilities setCenterControllerToMapWithTabSelected:3];
}

- (void)removeFirstTab:(BOOL)removeFirst secondTab:(BOOL)removeSecond thirdTab:(BOOL)removeThird {
    UNMHomePageMapFooter *mapFooter = (UNMHomePageMapFooter *)self.newsTableView.tableFooterView;
    if (mapFooter) {
        if (removeFirst) {
            [mapFooter.leftTab removeFromSuperview];
            mapFooter.leftTab = nil;
        }
        if (removeSecond) {
            [mapFooter.middleTab removeFromSuperview];
            mapFooter.middleTab = nil;
        }
        if (removeThird) {
            [mapFooter.rightTab removeFromSuperview];
            mapFooter.rightTab = nil;
        }
        if (!removeFirst) {
            if (removeSecond && removeThird) {
                NSDictionary *viewsDictionary = @{@"left":mapFooter.leftTab};
                
                NSArray *constraint_Vert = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[left]-0-|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:viewsDictionary];
                
                
                [self.view addConstraints:constraint_Vert];
            }
            else if (removeSecond && !removeThird) {
                NSDictionary *viewsDictionary = @{@"left":mapFooter.leftTab,@"right":mapFooter.rightTab};
                
                NSArray *constraint_Vert = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[left]-0-[right]"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:viewsDictionary];
                
                
                [self.view addConstraints:constraint_Vert];
            }
            else if (!removeSecond && removeThird) {
                NSDictionary *viewsDictionary = @{@"middle":mapFooter.middleTab};
                
                NSArray *constraint_Vert = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[middle]-0-|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:viewsDictionary];
                
                
                [self.view addConstraints:constraint_Vert];
            }
        }
        if (!removeSecond) {
            if (removeFirst && removeThird) {
                NSDictionary *viewsDictionary = @{@"middle":mapFooter.middleTab};
                
                NSArray *constraint_Vert = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[middle]-0-|"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:viewsDictionary];
                
                
                [self.view addConstraints:constraint_Vert];
            }
            else if (removeFirst && !removeThird) {
                NSDictionary *viewsDictionary = @{@"middle":mapFooter.middleTab};
                
                NSArray *constraint_Vert = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[middle]"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:viewsDictionary];
                
                
                [self.view addConstraints:constraint_Vert];
            }
        }
        if (!removeThird) {
            if (removeFirst && removeSecond) {
                NSDictionary *viewsDictionary = @{@"right":mapFooter.rightTab};
                
                NSArray *constraint_Vert = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[right]"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:viewsDictionary];
                
                
                [self.view addConstraints:constraint_Vert];
            }
        }
    }
}

@end
