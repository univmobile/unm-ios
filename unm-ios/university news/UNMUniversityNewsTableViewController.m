//
//  UNMUniversityNewsTableViewController.m
//  unm-ios
//
//  Created by UnivMobile on 1/22/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMUniversityNewsTableViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "UNMUtilities.h"
#import "UNMUniversityBasic.h"
#import "UNMNewsBasic.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+notificationDate.h"
#import "UNMUnivNewsWebViewController.h"
#import "SVPullToRefresh.h"
#import "UNMNewsFeed.h"
#import "UNMNewsFeedButton.h"

@interface UNMUniversityNewsTableViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *headerScrollView;
@property (weak, nonatomic) IBOutlet UIView *headerParentView;
@property (strong, nonatomic) NSIndexPath *selectedCell;
@property (strong, nonatomic) NSNumber *cellHeightClosed;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *newsItems;
@property (strong, nonatomic) UIView *activityIndicatorView;
@property (strong, nonatomic) NSCache *offscreenCells;
@property (strong, nonatomic) NSCache *offscreenCellHeights;
@property (strong, nonatomic) NSURL *webviewURL;
@property (strong, nonatomic) NSString *nextNewsPath;
@property (strong, nonatomic) NSString *freshNextNewsPath;
@property (strong, nonatomic) NSMutableArray *selectedItems;
@property (strong, nonatomic) NSDictionary<NSString *,UNMNewsFeedSelectable *> *newsFeedSelectableItems;
@end

@implementation UNMUniversityNewsTableViewController


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _newsItems = [NSMutableArray new];
        _offscreenCellHeights = [NSCache new];
        _offscreenCells = [NSCache new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self retrieveSavedFeedsIDs];
    NSNumber *univId = [[UNMUniversityBasic getSavedObject] univId];
    [UNMNewsFeed fetchUniversityNewsFeedsWithUniversityID:univId success:^(NSArray *newsFeeds) {
        
        self.newsFeedSelectableItems = [UNMNewsFeedSelectable selectableNewsFeeds:newsFeeds];
        if(newsFeeds.count>1){
        [self addNewsFeedButtons:newsFeeds];
        }
        else {
            [self.headerScrollView setHidden:YES];
            CGRect newFrame = self.headerParentView.frame;
            
            newFrame.size.height = newFrame.size.height / 2.0;
            [self.headerParentView setFrame:newFrame];
        }
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.navigationItem setHidesBackButton:YES];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak UNMUniversityNewsTableViewController *weakSelf = self;
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf addNewsItemsToBottom];
        }];
        [self.tableView addPullToRefreshWithActionHandler:^{
            [weakSelf addFreshNewsItems];
        }];
        [self.tableView.pullToRefreshView setTitle:@"Lâcher pour rafraichir" forState:SVPullToRefreshStateStopped];
        [self.tableView.pullToRefreshView setTitle:@"Tirez pour rafraichir" forState:SVPullToRefreshStateTriggered];
        [self.tableView.pullToRefreshView setTitle:@"Chargement" forState:SVPullToRefreshStateLoading];
        
        [self.tableView triggerInfiniteScrolling];
    }];

    
    }

- (UNMNewsFeedButton *)createNewsFeedButtonWithTitle:(NSString *)title andID:(NSNumber *) id {
    UNMNewsFeedButton *button = [[UNMNewsFeedButton alloc] initWithID:id];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(newsFeedButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [button setContentEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    button.selected = [self setSelectedForButton:id];
    //button.titleLabel.font = [UIFont fontWithName:@"Exo-Light" size:20];
    return button;
}



-(BOOL) isItemSelected: (UNMNewsFeed*) item {
    return true;
}

- (NSMutableArray*) retrieveSavedFeedsIDs {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.selectedItems = [NSMutableArray arrayWithArray:[defaults objectForKey:@"savedFeeds"]];
    
    return self.selectedItems;
    
}


-(BOOL)setSelectedForButton:(NSNumber*) id {
    if(self.selectedItems.count==0){
        return true;
    }
    UNMNewsFeedSelectable *selectableItem = [self.newsFeedSelectableItems valueForKey:[id stringValue]];
    for (NSNumber *number in self.selectedItems) {
        if ([number isEqualToNumber:id]){
            selectableItem.selected = true;
            return true;
        }
    }
    selectableItem.selected = false;
    return false;
}

-(BOOL)everythingIsUnchecked {
    for (NSString* key in self.newsFeedSelectableItems) {
        UNMNewsFeedSelectable *selectableItem = [self.newsFeedSelectableItems objectForKey:key];
        if(selectableItem.selected)
        {
            return false;
        }
    }
    return true;
}


- (void)newsFeedButtonSelected:(id)sender {
    if ([sender isKindOfClass:[UNMNewsFeedButton class]]) {
        UNMNewsFeedButton *button = sender;
        UNMNewsFeedSelectable *selectableItem = [self.newsFeedSelectableItems valueForKey:[button.tagId stringValue]];
        if (selectableItem) {
            selectableItem.selected = !selectableItem.selected;
            button.selected = selectableItem.selected;
        }
        
        if([self everythingIsUnchecked]){
        
            [self checkEverything];
        }
        
        [self refreshNewsItems];
    }
}

- (void)checkEverything{
    for (NSString* key in self.newsFeedSelectableItems) {
        UNMNewsFeedSelectable *selectableItem = [self.newsFeedSelectableItems objectForKey:key];
        selectableItem.selected = true;
        
        for (UIView *i in self.headerScrollView.subviews){
            if([i isKindOfClass:[UNMNewsFeedButton class]]){
                UNMNewsFeedButton *newLbl = (UNMNewsFeedButton *)i;
                newLbl.selected = true;            }
        }
    }
}


- (void)addNewsFeedButtons:(NSArray *)newsFeeds {
    CGFloat lastX = 0;
    CGRect scrollFrame = self.headerScrollView.frame;
    for (UNMNewsFeed *newsFeed in newsFeeds) {
        UNMNewsFeedButton *button = [self createNewsFeedButtonWithTitle:newsFeed.title andID:newsFeed.ID];
        [button sizeToFit];
        CGRect buttonFrame = [button frame];
        buttonFrame.size.height = scrollFrame.size.height / 2.0;
        buttonFrame.origin.x = lastX + 10;
        buttonFrame.origin.y = (scrollFrame.size.height - buttonFrame.size.height) / 2.0;
        lastX = buttonFrame.origin.x + buttonFrame.size.width;
        button.frame = buttonFrame;
        
        [self.headerScrollView addSubview:button];
    }
    
    scrollFrame.size.width = lastX + 10;
    scrollFrame.size.height = scrollFrame.size.height - 2;
    self.headerScrollView.contentSize = scrollFrame.size;
}

-(NSString*)getCurrentFeedsString{
    NSMutableString*  returnString = [NSMutableString stringWithCapacity:1];
    for (NSString* key in self.newsFeedSelectableItems) {
        UNMNewsFeedSelectable *selectableItem = [self.newsFeedSelectableItems objectForKey:key];
        if(selectableItem.selected)
        {
            [returnString appendFormat:@"&feedIds=%@ ", key];
        }
        }
    
    return [returnString stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)addFreshNewsItems {
    [UNMNewsBasic fetchNewsWithPath:self.freshNextNewsPath withFeedString:[self getCurrentFeedsString] andSuccess:^(NSArray *newsItems, NSString *nextPath) {
        BOOL foundMatch = NO;
        self.nextNewsPath = nextPath;
        if ([newsItems count] > 0) {
            [self.tableView beginUpdates];
            NSRange indexes = NSMakeRange(0,newsItems.count-1);
            NSMutableArray *indexPaths = [NSMutableArray new];
            NSUInteger idx;
            for(idx = indexes.location; idx <= indexes.location + indexes.length; idx++ ){
                UNMNewsBasic *item = [newsItems objectAtIndex:(idx-indexes.location)];
                if ([self.newsItems containsObject:item]) {
                    foundMatch = YES;
                    break;
                }
                [self.newsItems addObject:item];
                NSIndexPath *path = [NSIndexPath indexPathForRow:idx inSection:0];
                [indexPaths addObject:path];
            }
            if ([indexPaths count] > 0) {
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            }
            [self.tableView endUpdates];
        }
        [self.tableView.pullToRefreshView stopAnimating];
        if (!foundMatch && nextPath) {
            [self addFreshNewsItems];
        }
    } failure:^{
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}

- (void)addNewsItemsToBottom {
    if (self.nextNewsPath != nil || [self.newsItems count] == 0) {
        [UNMNewsBasic fetchNewsWithPath:self.nextNewsPath withFeedString:[self getCurrentFeedsString] andSuccess:^(NSArray *newsItems, NSString *nextPath) {
            self.nextNewsPath = nextPath;
            if (newsItems && [newsItems count] > 0) {
                NSUInteger currentCount = self.newsItems.count;
                [self.tableView beginUpdates];
                NSRange indexes = NSMakeRange(currentCount,newsItems.count-1);
                [self.newsItems addObjectsFromArray:newsItems];
                NSMutableArray *indexPaths = [NSMutableArray new];
                NSUInteger idx;
                for(idx = indexes.location; idx <= indexes.location + indexes.length; idx++ ){
                    NSIndexPath *path = [NSIndexPath indexPathForRow:idx inSection:0];
                    [indexPaths addObject:path];
                }
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                [self.tableView.infiniteScrollingView stopAnimating];
            }
        } failure:^{
            [self.tableView.infiniteScrollingView stopAnimating];
        }];
    } else {
        [self.tableView.infiniteScrollingView stopAnimating];
    }
}

//refreshing all items

- (void)refreshNewsItems {
        [UNMNewsBasic fetchNewsWithPath:self.freshNextNewsPath withFeedString:[self getCurrentFeedsString] andSuccess:^(NSArray *newsItems, NSString *nextPath) {
            [self.newsItems removeAllObjects];
            [self.tableView reloadData];
            self.nextNewsPath = nextPath;
            if (newsItems && [newsItems count] > 0) {
                NSUInteger currentCount = self.newsItems.count;
                [self.tableView beginUpdates];
                NSRange indexes = NSMakeRange(currentCount,newsItems.count-1);
                [self.newsItems addObjectsFromArray:newsItems];
                NSMutableArray *indexPaths = [NSMutableArray new];
                NSUInteger idx;
                for(idx = indexes.location; idx <= indexes.location + indexes.length; idx++ ){
                    NSIndexPath *path = [NSIndexPath indexPathForRow:idx inSection:0];
                    [indexPaths addObject:path];
                }
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                [self.tableView.infiniteScrollingView stopAnimating];
            }
        } failure:^{
            [self.tableView.infiniteScrollingView stopAnimating];
        }];
}


-(void)viewWillDisappear:(BOOL)animated {
    
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    
    for (NSString* key in self.newsFeedSelectableItems) {
        UNMNewsFeedSelectable *selectableItem = [self.newsFeedSelectableItems objectForKey:key];
        if(selectableItem.selected)
        {
            [newArray addObject:selectableItem.item.ID];
        }
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:newArray forKey:@"savedFeeds"];
    [defaults synchronize];
    
    
//    NSMutableArray *array = [NSMutableArray arrayWithArray:[defaults objectForKey:@"savedFeeds"]];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.newsItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UNMNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell" forIndexPath:indexPath];
    if (indexPath.row < [self.newsItems count]) {
        UNMNewsBasic *item = self.newsItems[indexPath.row];
        cell.titleLabel.text = item.name;
        cell.detailLabel.text = item.desc;
        if ([item feedName] && [item.feedName class] != [NSNull class] && [item date]) {
            cell.dateLabel.text = [NSString stringWithFormat:@"%@ %@",[item feedName],[item.date newsCellDateString]];
        }
        else if ([item date]) {
            cell.dateLabel.text = [NSString stringWithFormat:@"%@",[item.date newsCellDateString]];
        }
        else if ([item feedName] && [item.feedName class] != [NSNull class]) {
            cell.dateLabel.text = [NSString stringWithFormat:@"%@",[item feedName]];
        }
        
        cell.thumbnailImageView.image = nil;
        if (item.thumbURLStr && [item.thumbURLStr class] != [NSNull class]) {
            NSURL *thumbURL = [NSURL URLWithString:item.thumbURLStr];
            if (thumbURL && thumbURL.scheme && thumbURL.host) {
                [cell.thumbnailImageView setImageWithURL:thumbURL];
            }
        }
        if (!item.articleURLStr || [item.articleURLStr class] == [NSNull class]) {
            cell.showMoreButton = NO;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    if (self.selectedCell != nil && [self.selectedCell isEqual:indexPath]) {
        NSString *reuseIdentifier = @"newsCell";
        NSNumber *height;
        indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        height = [self.offscreenCellHeights objectForKey:indexPath];
        if (!height) {
            
            UITableViewCell *cell = [self.offscreenCells objectForKey:reuseIdentifier];
            if (!cell) {
                cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
                [self.offscreenCells setObject:cell forKey:reuseIdentifier];
            }
            
            UNMNewsTableViewCell *newsCell = (UNMNewsTableViewCell *)cell;
            if (indexPath.row < [self.newsItems count]) {
                UNMNewsBasic *newsItem = self.newsItems[indexPath.row];
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
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row < [self.newsItems count]) {
        UNMNewsBasic *item = self.newsItems[indexPath.row];
        if (item.articleURLStr && [item.articleURLStr class] != [NSNull class]) {
            NSURL *articleURL = [NSURL URLWithString:item.articleURLStr];
            if (articleURL && articleURL.scheme && articleURL.host) {
                self.webviewURL = articleURL;
                [self performSegueWithIdentifier:@"webview" sender:self];
            }
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
@end
