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
#import "UNMMapViewController.h"
#import "UNMProfileFooterTableViewCell.h"
#import "UNMRegionBasic.h"

@interface UNMHomeViewController ()
@property NSIndexPath *selectedCell;
@property CGFloat closedTableViewHeight;
@property (weak, nonatomic) IBOutlet UIControl *leftTab;
@property (weak, nonatomic) IBOutlet UIControl *middleTab;
@property (weak, nonatomic) IBOutlet UIControl *rightTab;
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
    [self loadStaticMapImage];
    self.newsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UNMRegionBasic *region = [UNMRegionBasic getSavedObject];
    if (![region.ID isEqualToNumber:[NSNumber numberWithInt:1]]) {
        [self removeMiddleRightTabs];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initActivityIndicator];

    [UNMNewsBasic fetch4NewsWithSuccess:^(NSArray *items) {
        self.newsItems = items;
        UNMNewsBasic *first = [self.newsItems firstObject];
        if (first) {
            self.titleLabel.text = first.name;
            self.titleBodyLabel.text = first.desc;
            self.dateLabel.text = [NSString stringWithFormat:@"Nom du flux %@",[first.date newsCellDateString]];
            if ([first.thumbURLStr class] != [NSNull class]) {
                [self.topImageView setImageWithURL:[NSURL URLWithString:first.thumbURLStr]];
            }
            [self sizeHeaderToFit];
        }
        [self.newsTableView reloadData];
        [self removeActivityIndicator];
    } failure:^{
        [self removeActivityIndicator];
    }];
}

- (UNMMapViewController *)loadStaticMapImage {
    if (self.mapView == nil) {
        self.mapView = [self.storyboard instantiateViewControllerWithIdentifier:@"mapview"];
        self.mapView.forHomeView = YES;
        [self addChildViewController:self.mapView];
        self.mapView.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.mapPlaceholder addSubview:self.mapView.view];
        [self.mapView didMoveToParentViewController:self];
        
        
        NSArray *constraint_Horz = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[slideout]-0-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"slideout":self.mapView.view}];
        NSArray *constraint_Vert = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[slideout]-0-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"slideout":self.mapView.view}];
        
        [self.mapPlaceholder addConstraints:constraint_Horz];
        [self.mapPlaceholder addConstraints:constraint_Vert];
        self.mapPlaceholder.userInteractionEnabled = NO;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            cell.dateLabel.text = [NSString stringWithFormat:@"Nom du flux %@",[item.date newsCellDateString]];
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
                newsCell.dateLabel.text = [NSString stringWithFormat:@"Nom du flux %@",[date newsCellDateString]];
                newsCell.detailLabel.text = [newsItem desc];
            } else {
                newsCell.titleLabel.text    = @"name";
                newsCell.dateLabel.text    = @"Nom du flux /1/1/2015";
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
    if (indexPath.row < [self.newsItems count]) {
        UNMNewsBasic *item = self.newsItems[indexPath.row];
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

- (void)removeMiddleRightTabs {
    [self.middleTab removeFromSuperview];
    [self.rightTab removeFromSuperview];
    NSDictionary *viewsDictionary = @{@"left":self.leftTab};
    
    NSArray *constraint_Vert = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[left]-0-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:viewsDictionary];
    
    
    [self.view addConstraints:constraint_Vert];
}

@end
