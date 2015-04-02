//
//  UNMDescriptionViewController.h
//  unm-ios
//
//  Created by UnivMobile on 2/2/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPAnimationSequence.h"
#import "UNMTabButton.h"
#import "UNMMapItemBasic.h"
#import "TTTAttributedLabel.h"

@class UNMBookmarkBasic;

@protocol UNMDescriptionViewDelegate <NSObject>
- (void)closeDescriptionView;
- (void)reloadController;
- (void)displaySearch;
- (BOOL)itemBookmarked:(UNMMapItemBasic *)item;
- (UNMBookmarkBasic *)bookmarkForMapItem:(UNMMapItemBasic *)item;
- (void)updateUserBookmarksWithBookmark:(UNMBookmarkBasic *)bookmark;
- (void)removeUserBookmark:(UNMBookmarkBasic *)bookmark;
@end

@interface UNMDescriptionViewController : UIViewController<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,TTTAttributedLabelDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) UIColor *viewColor;
@property (weak, nonatomic) id<UNMDescriptionViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *categoryIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomSeparator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBarHeightConst;
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomButtonHeightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatorHeightConst;
@property (weak, nonatomic) UITextView *commentField;
@property (weak, nonatomic) IBOutlet UNMTabButton *infoTab;
@property (weak, nonatomic) IBOutlet UNMTabButton *commentTab;
@property (weak, nonatomic) IBOutlet UNMTabButton *menuTab;
@property (strong, nonatomic) IBOutletCollection(UNMTabButton) NSArray *tabs;
@property (strong, nonatomic) UNMMapItemBasic *mapItem;
@property (nonatomic) BOOL isLayouting;
@property (nonatomic) BOOL isImageMapDesc;
@property (nonatomic) NSInteger tabSelected;
- (CPAnimationStep *)stepsForkeyboardWillShow:(NSNotification *)notification;
- (CPAnimationStep *)stepsForKeyboardWillHide:(NSNotification *)notification;
- (void)setSelectedTab:(NSInteger)tabIndex;
- (void)removeCommentTab;
- (void)addCommentTab;
@end
