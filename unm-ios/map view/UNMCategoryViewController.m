//
//  UNMCategoryViewController.m
//  unm-ios
//
//  Created by UnivMobile on 2/5/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMCategoryViewController.h"
#import "UIScrollView+ScrollIndicator.h"
#import "UNMCategoryCollectionViewCell.h"
#import "UNMCategoryBasic.h"
#import "UNMUtilities.h"
#import "UNMScrollIndicatorHelper.h"
#import "UNMCategoryIcons.h"

@interface UNMCategoryViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBtnHeightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separatorHeightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBtnHeightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discIconHeightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewTopConst;

@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSMutableArray *selectedIndexes;
@property (nonatomic) BOOL disclosurePointingUp;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UNMScrollIndicatorHelper *scrollHelper;
@property (strong, nonatomic) NSCache *cellIcons;
@property (strong, nonatomic) UIView *activityIndicatorView;
@property (nonatomic) BOOL skipOnce;
@end

@implementation UNMCategoryViewController {
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _selectedIndexes = [NSMutableArray new];
        _disclosurePointingUp = YES;
        _categoryId = [NSNumber numberWithInt:1];
        _scrollHelper = [UNMScrollIndicatorHelper new];
        _noTopElements = NO;
        _allowsMultipleSelect = YES;
        _cellIcons = [NSCache new];
        _skipOnce = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.noTopElements) {
        [self collapseTopElements];
    }
    if (!self.allowsMultipleSelect) {
        self.collectionView.allowsMultipleSelection = NO;
    } else {
        self.collectionView.allowsMultipleSelection = YES;
    }
    if (self.color) {
        [self setViewColor:self.color];
    }
    [self.collectionView setScrollEnabled:YES];
    self.searchButton.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    self.openButton.titleEdgeInsets = UIEdgeInsetsMake(0,CGRectGetWidth(self.disclosureIcon.frame)+10, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.skipOnce) {
        self.skipOnce = NO;
    } else {
        [self.scrollHelper setUpScrollIndicatorWithScrollView:self.collectionView andColor:[UIColor whiteColor]];
    }
}

- (void)addSelectBarButton {
    if ([self.selectedIndexes count] == 1 && [self.parentViewController class] == [UINavigationController class]) {
        UIBarButtonItem *selectBtn = [[UIBarButtonItem alloc]initWithTitle:@"select" style:UIBarButtonItemStyleDone target:self action:@selector(updateDelegateWithSelectedObject)];
        self.navigationItem.rightBarButtonItem = selectBtn;
    }
}

- (void)removeSelectBarButton {
    if ([self.parentViewController class] == [UINavigationController class]) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (IBAction)toggleView:(id)sender {
    if ([self.delegate respondsToSelector:@selector(toggleCategorySlideOut)]) {
        [self.delegate toggleCategorySlideOut];
        [self flipDisclosureIcon];
    }
}

- (void)flipDisclosureIcon {
    [UIView animateWithDuration:0.5 animations:^{
        if (self.disclosurePointingUp) {
            self.disclosureIcon.transform = CGAffineTransformMakeRotation(M_PI);
            self.disclosurePointingUp = NO;
        } else {
            self.disclosureIcon.transform = CGAffineTransformMakeRotation(0);
            self.disclosurePointingUp = YES;
        }
        [self.disclosureIcon layoutIfNeeded];
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.25 animations:^{
        [scrollView refreshCustomScrollIndicatorsWithAlpha:0.0];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scrollView refreshCustomScrollIndicatorsWithAlpha:1.0];
}

#pragma mark - Activity indicator

- (void)initActivityIndicator {
    if (self.activityIndicatorView == nil) {
        self.activityIndicatorView = [UNMUtilities initActivityIndicatorContainerWithParentView:self.view aboveSubview:nil];
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

#pragma mark - Data fetching

- (void)fetchCategories {
    [self initActivityIndicator];
    [UNMCategoryBasic fetchCategoriesWithCategoryID:self.categoryId andSuccess:^(NSArray *items) {
        self.categories = items;
        [self.collectionView reloadData];
        [self removeActivityIndicator];
    } failure:^{
        [self removeActivityIndicator];
    }];
}

#pragma mark - CollectionView Data Source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.categories count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(120, 130);
}

#pragma mark - CollectionView Delegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UNMCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"categorieCell" forIndexPath:indexPath];
    
    if ([self.categories count] > indexPath.row) {
    
        UNMCategoryBasic *category = self.categories[indexPath.row];
        
        cell.backgroundColor = [UIColor clearColor];
        
        cell.titleLabel.text = category.name;
        
        cell.imageView.image = nil;
        
        [self setImageForView:cell.imageView withCategoryID:category.ID];
        if ([self.selectedIndexes indexOfObject:indexPath] != NSNotFound) {
            cell.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        } else if(self.preselectedCategory && [category.ID isEqualToNumber:self.preselectedCategory]) {
            cell.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
            [self.selectedIndexes addObject:indexPath];
        } else {
            cell.backgroundColor = [UIColor clearColor];
        }
    } else {
        cell.titleLabel.text = @"";
    }
    return cell;
}

- (void)setImageForView:(UIImageView *)imgView withCategoryID:(NSNumber *)catID {
    if (imgView && catID) {
        UIImage *icon = [self.cellIcons objectForKey:catID];
        if (!icon) {
            imgView.image = nil;
            [UNMCategoryIcons getCategoryImageWithID:catID success:^(UNMCategoryIcons *icon) {
                imgView.image = icon.activeImage;
                [self.cellIcons setObject:icon.activeImage forKey:catID];
            } failure:^{
                imgView.image = nil;
            }];
        } else {
            imgView.image = icon;
        }
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.selectedIndexes indexOfObject:indexPath] == NSNotFound) {
        [self.selectedIndexes addObject:indexPath];
        UNMCategoryCollectionViewCell *cell = (UNMCategoryCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        cell.backgroundImageView.hidden = NO;
        [self addSelectBarButton];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.selectedIndexes indexOfObject:indexPath] != NSNotFound) {
        [self.selectedIndexes removeObject:indexPath];
        UNMCategoryCollectionViewCell *cell = (UNMCategoryCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundImageView.hidden = YES;
        [self removeSelectBarButton];
    }
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    return layoutAttributes;
}

- (void) setViewColor:(UIColor *)color {
    self.mainView.backgroundColor = color;
}

- (IBAction)didSelectSearch:(id)sender {
    if ([self.delegate respondsToSelector:@selector(displaySearch)]) {
        [self.delegate displaySearch];
    }
}

- (void)setCategoryId:(NSNumber *)categoryId {
    _categoryId = categoryId;
    if (_categoryId != nil) {
        [self.selectedIndexes removeAllObjects];
        [self.cellIcons removeAllObjects];
        [self fetchCategories];
    }
}

- (NSArray *)getSelectedCategoryIDS {
    NSMutableArray *categoryIDS = [[NSMutableArray alloc]initWithCapacity:[self.selectedIndexes count]];
    for (NSIndexPath *indexPath in self.selectedIndexes) {
        if ([self.categories count] > indexPath.row) {
            
            UNMCategoryBasic *category = self.categories[indexPath.row];
            
            [categoryIDS addObject:category.ID];
        }
    }
    return categoryIDS;
}

- (void)addCategoryIdToSelected:(NSNumber *)catId {
    if (catId) {
        self.preselectedCategory = catId;
    }
}

- (void)updateDelegateWithSelectedObject {
    if ([self.delegate respondsToSelector:@selector(updateWithCategory:)]) {
        if ([self.selectedIndexes count] == 1) {
            NSIndexPath *indexPath = [self.selectedIndexes firstObject];
            if (indexPath.row < [self.categories count]) {
                [self.delegate updateWithCategory:self.categories[indexPath.row]];
            }
        }
    }
    if ([self.delegate respondsToSelector:@selector(updateWithCategoryImage:)]) {
        if ([self.selectedIndexes count] == 1) {
            NSIndexPath *indexPath = [self.selectedIndexes firstObject];
            UNMCategoryCollectionViewCell *cell = (UNMCategoryCollectionViewCell *)[self collectionView:self.collectionView cellForItemAtIndexPath:indexPath];
            [self.delegate updateWithCategoryImage:cell.imageView.image];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)collapseTopElements {
    self.searchBtnHeightConst.constant = 0;
    self.topBtnHeightConst.constant = 0;
    self.discIconHeightConst.constant = 0;
    self.separatorHeightConst.constant = 0;
    CGFloat navBarStatusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
    self.collectionViewTopConst.constant = navBarStatusBarHeight;
    self.openButton.hidden = YES;
    [self.view layoutIfNeeded];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
