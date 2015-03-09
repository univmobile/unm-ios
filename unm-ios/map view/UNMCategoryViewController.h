//
//  UNMCategoryViewController.h
//  unm-ios
//
//  Created by UnivMobile on 2/5/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNMCategoryBasic.h"

@protocol UNMCategoryViewControllerDelegate <NSObject>
@optional
- (void)toggleCategorySlideOut;
- (void)displaySearch;
- (void)updateCategoryIDsWithArray:(NSArray *)ids;
- (void)updateWithCategory:(UNMCategoryBasic *)category;
- (void)updateWithCategoryImage:(UIImage *)catImage;
@end

@interface UNMCategoryViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *openButton;
@property (weak, nonatomic) id<UNMCategoryViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *disclosureIcon;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *separator;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) NSNumber *categoryId;
@property (strong, nonatomic) UIColor *color;
@property (nonatomic) BOOL noTopElements;
@property (nonatomic) BOOL allowsMultipleSelect;
@property (strong, nonatomic) NSNumber *preselectedCategory;
- (void) setViewColor:(UIColor *)color;
- (NSArray *)getSelectedCategoryIDS;
- (void)addCategoryIdToSelected:(NSNumber *)catId;
@end
