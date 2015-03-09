//
//  UNMMapViewController.m
//  unm-ios
//
//  Created by UnivMobile on 1/16/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import "UNMMapViewController.h"
#import "UNMMapItemBasic.h"
#import "UNMTabButton.h"
#import "UNMUtilities.h"
#import "CPAnimationSequence.h"
#import "CPAnimationProgram.h"
#import "UNMAppDelegate.h"
#import "UNMUniversityBasic.h"
#import "NSString+URLEncoding.h"
#import "UNMImageMap.h"
#import "UNMConstants.h"
#import "UIColor+Extension.h"
#import "UNMRegionBasic.h"
#import "UNMCategoryIcons.h"
#import "UNMBookmarkBasic.h"

typedef NS_ENUM(NSInteger, UNMSlideOut) {
    SlideOutCategory     = 1,
    SlideOutDescription  = 2,
    SlideOutBonPlan      = 3,
    SlideOutNone         = 4
};

@interface UNMMapViewController ()
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (nonatomic) UNMSlideOut slideOutVisible;
@property (nonatomic) BOOL slideOutAnimationDone;
@property (weak, nonatomic) IBOutlet UNMTabButton *leftTab;
@property (weak, nonatomic) IBOutlet UNMTabButton *middleTab;
@property (weak, nonatomic) IBOutlet UNMTabButton *rightTab;
@property (strong, nonatomic) IBOutletCollection(UNMTabButton) NSArray *tabs;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightTabLeadingConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftTabTrailingConst;
@property (strong, nonatomic) NSArray *categoryIDs;
@property (strong, nonatomic) UIView *activityIndicatorView;
@property (strong, nonatomic) GMSCoordinateBounds *imageMapBounds;
@property (nonatomic) CLLocationCoordinate2D lastPosition;
@property (strong, nonatomic) UNMImageMap *imageMap;
@property (nonatomic) BOOL viewLoaded;
@property (strong, nonatomic) NSCache *markerIcons;
@property (strong, nonatomic) NSArray *userBookmarks;
@end

@implementation UNMMapViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _slideOutAnimationDone = YES;
        _slideOutVisible = SlideOutNone;
        _categoryIDs = [NSArray new];
        _markerIcons = [NSCache new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewLoaded = NO;
    [self setTabColor:[UIColor tabGray] SelectedColor:[UIColor blueColor]];
    self.leftTab.highlightColor = [UIColor leftTabYellow];
    self.middleTab.highlightColor = [UIColor middleTabPurple];
    self.rightTab.highlightColor = [UIColor rightTabGreen];
    
    if (self.forHomeView) {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:kParisLat
                                                                longitude:kParisLon
                                                                     zoom:14];
        self.mapView.myLocationEnabled = YES;
        self.mapView.delegate = self;
        [self.mapView setMinZoom:6 maxZoom:kGMSMaxZoomLevel];
        [self.mapView setCamera:camera];
        [self removeAllTabs];
        self.TabSelected = MapTabLeft;
        [self fetch20MarkersWithMap:self.mapView];

    } else {
        [self fetchUserBookmarks];
        if (self.imageMapUrl) {
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:CLLocationCoordinate2DMake(0, 0) zoom:100];
            self.mapView.delegate = self;
            [self.mapView setCamera:camera];
            self.mapView.mapType = kGMSTypeNone;
            [self removeAllTabs];
            [self loadImageMapDataWithURL:self.imageMapUrl];
            [self addDescriptionSlideOutForImageMap:YES];
            self.descSlideOut.viewColor = [UIColor leftTabYellow];
        } else {
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:kParisLat
                                                                    longitude:kParisLon
                                                                         zoom:16];
            self.mapView.myLocationEnabled = YES;
            self.mapView.delegate = self;
            [self.mapView setMinZoom:6 maxZoom:kGMSMaxZoomLevel];
            [self.mapView setCamera:camera];
            [self checkParisRegion];
            [self categorySlideOut];
            [self addDescriptionSlideOutForImageMap:NO];
            if (self.TabSelected == MapTabNone) {
                [self setSelectedTab:MapTabLeft];
            } else {
                [self setSelectedTab:self.TabSelected];
            }
            if (self.singleItem == nil) {
                if (self.preselectedCategoryID) {
                    self.categoryIDs = [NSArray arrayWithObject:self.preselectedCategoryID];
                    [self.categorySlideOut addCategoryIdToSelected:self.preselectedCategoryID];
                }
                [self fetchMarkersWithMap:self.mapView];
                [self startLocationServices];
            } else {
                [self.mapView clear];
                [[UNMUtilities mapManager].operationQueue cancelAllOperations];
                [self removeActivityIndicator];
                GMSMarker *marker = [GMSMarker new];
                marker.position = CLLocationCoordinate2DMake(self.singleItem.lat, self.singleItem.lon);
                marker.map = self.mapView;
                marker.userData = self.singleItem;
                [self mapView:self.mapView didTapMarker:marker];
                [UNMCategoryIcons getCategoryImageWithCategoryProtocolItem:self.singleItem success:^(UNMCategoryIcons *catIcon) {
                    marker.icon = catIcon.markerImage;
                    [self.markerIcons setObject:catIcon.markerImage forKey:self.singleItem.categoryID];
                }];
                GMSCameraUpdate *update = [GMSCameraUpdate setTarget:marker.position];
                [self.mapView moveCamera:update];
            }
        }
    }
    UNMAppDelegate *appDelegate = (UNMAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.view addGestureRecognizer:[appDelegate.container panGestureRecognizer]];
    self.viewLoaded = YES;
}

- (void)checkParisRegion {
    UNMRegionBasic *region = [UNMRegionBasic getSavedObject];
    if (region) {
        if ([region.ID intValue] != 1) {
            [self removeMiddleRightTabs];
        }
    }
}

- (void)fetchUserBookmarks {
    [UNMBookmarkBasic fetchBookmarksWithSuccess:^(NSArray *items) {
        self.userBookmarks = items;
    } failure:^{
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[UNMUtilities mapManager].operationQueue cancelAllOperations];
    [self removeActivityIndicator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.navigationController.navigationBarHidden) {
        return UIStatusBarStyleDefault;
    }
    return UIStatusBarStyleLightContent;
}


- (void)setSingleItem:(UNMMapItemBasic *)singleItem {
    if (self.viewLoaded) {
        [self.mapView clear];
        GMSMarker *marker = [GMSMarker new];
        marker.position = CLLocationCoordinate2DMake(singleItem.lat, singleItem.lon);
        marker.map = self.mapView;
        marker.userData = singleItem;
        UIImage *icon = [self.markerIcons objectForKey:singleItem.categoryID];
        if (!icon) {
            [UNMCategoryIcons getCategoryImageWithCategoryProtocolItem:singleItem success:^(UNMCategoryIcons *catIcon) {
                marker.icon = catIcon.markerImage;
                [self.markerIcons setObject:catIcon.markerImage forKey:singleItem.categoryID];
            }];
        } else {
            marker.icon = icon;
        }
    }
    _singleItem = singleItem;
}

- (void)setTabColor:(UIColor *)color SelectedColor:(UIColor *)selectedColor {
    for (UNMTabButton *tab in self.tabs) {
        tab.backgroundColor = color;
        tab.highlightColor = selectedColor;
    }
}

- (void)setSelectedTab:(UNMMapTabs)tabIndex {
    switch (tabIndex) {
        case MapTabLeft:
            [self tabSelected:self.leftTab];
            break;
        case MapTabMiddle:
            [self tabSelected:self.middleTab];
            break;
        case MapTabRight:
            [self tabSelected:self.rightTab];
            break;
        default:
            break;
    }
}

- (UNMTabButton *)getSelectedTab {
    for (UNMTabButton *tab in self.tabs) {
        if (tab.selected) {
            return tab;
        }
    }
    return nil;
}

- (IBAction)tabSelected:(UNMTabButton *)sender {
    if (sender.selected) {
        //do nothing
    } else {
        for (UNMTabButton *tab in self.tabs) {
            if (tab != sender) {
                tab.selected = NO;
            }
        }
        [self setCategoryIdWithTab:sender];
        sender.selected = YES;
        if (sender == self.leftTab) {
            self.TabSelected = MapTabLeft;
        } else if (sender == self.middleTab) {
            self.TabSelected = MapTabMiddle;
        } else if (sender == self.rightTab) {
            self.TabSelected = MapTabRight;
        } else {
            self.TabSelected = MapTabNone;
        }
        if (self.slideOutVisible != SlideOutNone) {
            sender.dottedLine.hidden = NO;
        }
        [self.descSlideOut setViewColor:sender.highlightColor];
        self.descSlideOut.tabSelected = self.TabSelected;
        [self.categorySlideOut setViewColor:sender.highlightColor];
        [self resetCategoryIDs];
        [self fetchMarkersWithMap:self.mapView];
    }
}

- (void)setCategoryIdWithTab:(UNMTabButton *)tab {
    if (self.leftTab == tab) {
        self.categorySlideOut.categoryId = [NSNumber numberWithInt:1];
        [self removeBonPlanButton];
        [self addQrButton];
    } else if (self.middleTab == tab) {
        [self removeBonPlanButton];
        [self removeQrCodeButton];
        self.categorySlideOut.categoryId = [NSNumber numberWithInt:5];
    } else if (self.rightTab == tab) {
        [self addBonPlanButton];
        [self removeQrCodeButton];
        self.categorySlideOut.categoryId = [NSNumber numberWithInt:2];
    }
}

#pragma mark - activity indicator

- (void)initActivityIndicator {
    if (self.activityIndicatorView == nil) {
        self.activityIndicatorView = [UNMUtilities initActivityIndicatorContainerWithParentView:self.view aboveSubview:self.mapView];
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

#pragma mark - Layout constraint code

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

- (void)removeAllTabs {
    [self.leftTab removeFromSuperview];
    [self.middleTab removeFromSuperview];
    [self.rightTab removeFromSuperview];
    [self pinMapViewToBottomSuperview];
}

- (void)pinMapViewToBottomSuperview {
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self.view addConstraint:bottom];
}

- (UIControl *)addButtonWithImage:(UIImage *)image andSelector:(SEL)selector {
    UIControl *button = [[UIControl alloc]init];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 25;
    button.layer.masksToBounds = YES;
    button.backgroundColor = [UIColor profileHeaderRed];
    [self.view insertSubview:button aboveSubview:self.mapView];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50];
    
    NSArray *constraint_Horz = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[button]-8-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:@{@"button":button}];
    NSArray *constraint_Vert;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        constraint_Vert = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[topGuide]-8-[button]"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:@{@"button":button,@"topGuide":self.topLayoutGuide}];
    } else {
        constraint_Vert = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[button]"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:@{@"button":button}];
    }
    
    
    [self.view addConstraints:constraint_Horz];
    [self.view addConstraints:constraint_Vert];
    [button addConstraint:height];
    [button addConstraint:width];
    
    
    UIImageView *plusIcon = [[UIImageView alloc]initWithImage:image];
    plusIcon.translatesAutoresizingMaskIntoConstraints = NO;
    [button addSubview:plusIcon];
    
    height = [NSLayoutConstraint constraintWithItem:plusIcon attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:35];
    width = [NSLayoutConstraint constraintWithItem:plusIcon attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:35];
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:plusIcon attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:plusIcon attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [plusIcon addConstraint:height];
    [plusIcon addConstraint:width];
    [button addConstraint:centerX];
    [button addConstraint:centerY];
    [button layoutIfNeeded];
    return button;
}

- (UNMBonPlanViewController *)bonPlanSlideOut {
    if (_bonPlanSlideOut == nil) {
        _bonPlanSlideOut = [self.storyboard instantiateViewControllerWithIdentifier:@"bonPlanSlideOut"];
        _bonPlanSlideOut.delegate = self;
        [self addChildViewController:_bonPlanSlideOut];
        _bonPlanSlideOut.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_bonPlanSlideOut.view];
        [_bonPlanSlideOut didMoveToParentViewController:self];
        
        CGFloat viewHeight = self.view.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height;
        
        self.bonPlanSlideOutHeightConst = [NSLayoutConstraint constraintWithItem:_bonPlanSlideOut.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:viewHeight];
        self.bonPlanSlideBottomConst = [NSLayoutConstraint constraintWithItem:_bonPlanSlideOut.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:viewHeight];
        
        NSArray *constraint_Horz = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[slideout]-0-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"slideout":_bonPlanSlideOut.view}];
        
        [self.view addConstraints:constraint_Horz];
        [_bonPlanSlideOut.view addConstraint:self.bonPlanSlideOutHeightConst];
        [self.view addConstraint:self.bonPlanSlideBottomConst];
    }
    return _bonPlanSlideOut;
}

- (UNMCategoryViewController *)categorySlideOut {
    if (_categorySlideOut == nil) {
        _categorySlideOut = [self.storyboard instantiateViewControllerWithIdentifier:@"categorySlideOut"];
        _categorySlideOut.delegate = self;
        [self setCategoryIdWithTab:[self getSelectedTab]];
        [self addChildViewController:_categorySlideOut];
        _categorySlideOut.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view insertSubview:_categorySlideOut.view aboveSubview:self.mapView];
        [_categorySlideOut didMoveToParentViewController:self];
        
        CGFloat viewHeight = self.view.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height-CGRectGetHeight(self.leftTab.frame);
        
        viewHeight *= 0.95;
        
        self.categorySlideOutHeightConst = [NSLayoutConstraint constraintWithItem:_categorySlideOut.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:viewHeight];
        
        CGFloat bottomConst = viewHeight-_categorySlideOut.separator.frame.origin.y;
        
        self.categorySlideBottomConst = [NSLayoutConstraint constraintWithItem:_categorySlideOut.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.leftTab attribute:NSLayoutAttributeTop multiplier:1.0 constant:bottomConst];
        
        NSArray *constraint_Horz = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[slideout]-0-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:@{@"slideout":_categorySlideOut.view}];
        
        [self.view addConstraints:constraint_Horz];
        [_categorySlideOut.view addConstraint:self.categorySlideOutHeightConst];
        [self.view addConstraint:self.categorySlideBottomConst];
    }
    return _categorySlideOut;
}

- (void)addDescriptionSlideOutForImageMap:(BOOL)forImageMap {
    self.descSlideOut = [self.storyboard instantiateViewControllerWithIdentifier:@"descriptionSlideOut"];
    if (forImageMap) {
        self.descSlideOut.isImageMapDesc = YES;
    }
    [self addChildViewController:self.descSlideOut];
    self.descSlideOut.delegate = self;
    self.descSlideOut.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.descSlideOut.view];
    [self.descSlideOut didMoveToParentViewController:self];
    
    CGFloat viewHeight = self.view.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height;
    viewHeight *= 0.95;
    
    self.descSlideOutHeightConst = [NSLayoutConstraint constraintWithItem:self.descSlideOut.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:viewHeight];
    self.descSlideBottomConst = [NSLayoutConstraint constraintWithItem:self.descSlideOut.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:viewHeight+10]; //+10 because the top of the category icon is above the view frame
    
    NSArray *constraint_Horz = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[slideout]-0-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:@{@"slideout":self.descSlideOut.view}];
    
    [self.view addConstraints:constraint_Horz];
    [self.descSlideOut.view addConstraint:self.descSlideOutHeightConst];
    [self.view addConstraint:self.descSlideBottomConst];
}

- (void)setSlideOutOpen:(BOOL)open withType:(UNMSlideOut)type animated:(BOOL)animated {
    void (^animation)(void);
    void (^completion)(BOOL);
    if (open) {
        animation = ^void(){
            switch (type) {
                case SlideOutDescription:
                    self.descSlideBottomConst.constant = 0;
                    break;
                case SlideOutCategory:
                    [self getSelectedTab].dottedLine.hidden = NO;
                    self.categorySlideBottomConst.constant = 0;
                    break;
                case SlideOutBonPlan:
                    self.bonPlanSlideBottomConst.constant = 0;
                    break;
                default:
                    break;
            }
            [self.mapView stopRendering];
            self.mapView.userInteractionEnabled = NO;
            [self.view layoutIfNeeded];
        };
        completion = ^void(BOOL finished) {
            self.slideOutAnimationDone = YES;
            switch (type) {
                case SlideOutDescription:
                    self.slideOutVisible = SlideOutDescription;
                    break;
                case SlideOutCategory:
                    self.slideOutVisible = SlideOutCategory;
                    break;
                case SlideOutBonPlan:
                    self.slideOutVisible = SlideOutBonPlan;
                    break;
                default:
                    break;
            }
        };
    } else {
        animation = ^void(){
            self.slideOutAnimationDone = NO;
            switch (type) {
                case SlideOutDescription:{
                    CGFloat viewHeight = self.view.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height;
                    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
                        viewHeight += 44;
                    }
                    viewHeight *= 0.95;
                    self.descSlideBottomConst.constant = viewHeight+10;
                    break;
                }
                case SlideOutCategory:{
                    [self getSelectedTab].dottedLine.hidden = YES;
                    CGFloat viewHeight = self.view.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height-CGRectGetHeight(self.leftTab.frame);
                    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
                        viewHeight += 44;
                    }
                    viewHeight *= 0.95;
                    CGFloat bottomConst = viewHeight-_categorySlideOut.separator.frame.origin.y;
                    self.categorySlideBottomConst.constant = bottomConst;
                    break;
                }
                case SlideOutBonPlan:{
                    CGFloat viewHeight = self.view.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height;
                    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
                        viewHeight += 44;
                    }
                    self.bonPlanSlideBottomConst.constant = viewHeight;
                    break;
                }
                default:
                    break;
            }
            [self.mapView startRendering];
            self.mapView.userInteractionEnabled = YES;
            [self.view layoutIfNeeded];
        };
        completion = ^void(BOOL finished) {
            self.slideOutAnimationDone = YES;
            switch (type) {
                case SlideOutDescription:{
                    if (self.slideOutVisible == SlideOutDescription) {
                        self.slideOutVisible = SlideOutNone;
                    }
                    break;
                }
                case SlideOutCategory:
                    if (self.slideOutVisible == SlideOutCategory) {
                        self.slideOutVisible = SlideOutNone;
                    }
                    break;
                case SlideOutBonPlan:{
                    if (self.slideOutVisible == SlideOutBonPlan) {
                        self.slideOutVisible = SlideOutNone;
                    }
                    break;
                }
                default:
                    break;
            }
        };
    }
    if (animated) {
        [UIView animateWithDuration:0.5 animations:animation completion:completion];
    } else {
        animation();
        completion(YES);
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (self.slideOutVisible == SlideOutDescription) {
        CGFloat height = self.view.window.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
        CPAnimationProgram *sequence = [CPAnimationProgram programWithSteps:
                                        [CPAnimationStep after:0.0 for:0.5 animate:^{
            self.descSlideOut.isLayouting = YES;
            self.descSlideOutHeightConst.constant = height;
            [self.descSlideOut.view layoutIfNeeded];
        }],[self.descSlideOut stepsForkeyboardWillShow:notification], nil];
        [sequence run];
    } else if (self.slideOutVisible == SlideOutBonPlan) {
        CGFloat height = self.navigationController.navigationBar.frame.size.height;
        self.bonPlanSlideOutHeightConst.constant += height;
        [self.bonPlanSlideOut layoutForKeyboardShown:notification];
    }
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (self.slideOutVisible == SlideOutDescription) {
        CPAnimationProgram *sequence = [CPAnimationProgram programWithSteps:
        [CPAnimationStep after:0.0 for:0.5 animate:^{
            CGFloat viewHeight = self.view.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height;
            viewHeight *= 0.95;
            self.descSlideOutHeightConst.constant = viewHeight;
            [self.descSlideOut.view layoutIfNeeded];
            
        }],[self.descSlideOut stepsForKeyboardWillHide:notification],nil];
        [sequence run];
    } else if (self.slideOutVisible == SlideOutBonPlan) {
        CGFloat height = self.navigationController.navigationBar.frame.size.height;
        self.bonPlanSlideOutHeightConst.constant -= height;
        [self.bonPlanSlideOut layoutForKeyboardHidden:notification];
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

#pragma mark - Layout logic

- (void)addBonPlanButton {
    [self bonPlanSlideOut];
    if (self.bonPlanButton == nil) {
        self.bonPlanButton = [self addButtonWithImage:[UIImage imageNamed:@"bonPlanPlusIcon"] andSelector:@selector(didSelectBonPlan:)];
    }
    
}

- (void)addQrButton {
    if (self.qrCodeButton == nil) {
        self.qrCodeButton = [self addButtonWithImage:[UIImage imageNamed:@"qrCodeIcon"] andSelector:@selector(didSelectQrCode:)];
    }
}

- (void) removeBonPlanButton {
    [self.bonPlanButton removeFromSuperview];
    self.bonPlanButton = nil;
}

- (void) removeQrCodeButton {
    [self.qrCodeButton removeFromSuperview];
    self.qrCodeButton = nil;
}

- (void)closeBonPlanView {
    [self toggleSlideOutWithType:SlideOutBonPlan];
}

- (void)updateAfterBonPlan {
    [self fetchMarkersWithMap:self.mapView];
}

- (void)toggleCategorySlideOut {
    if (self.slideOutVisible == SlideOutCategory) {
        [self resetCategoryIDs];
    }
    [self toggleSlideOutWithType:SlideOutCategory];
}

- (void)toggleSlideOutWithType:(UNMSlideOut)type {
    if (self.slideOutAnimationDone) {
        if (type != SlideOutCategory) {
            [self setSlideOutOpen:NO withType:SlideOutCategory];
        }
        if (type != SlideOutDescription) {
            [self setSlideOutOpen:NO withType:SlideOutDescription];
        }
        if (type != SlideOutBonPlan) {
            [self setSlideOutOpen:NO withType:SlideOutBonPlan];
        }
        switch (type) {
            case SlideOutCategory:
                [self setSlideOutOpen:self.slideOutVisible == SlideOutCategory ? NO : YES withType:SlideOutCategory];
                break;
            case SlideOutDescription:
                if (self.slideOutVisible != SlideOutDescription) {
                    UNMTabButton *selectedTab = [self getSelectedTab];
                    if (selectedTab != self.rightTab) {
                        [self.descSlideOut removeCommentTab];
                    } else {
                        [self.descSlideOut addCommentTab];
                    }
                }
                [self setSlideOutOpen:self.slideOutVisible == SlideOutDescription ? NO : YES withType:SlideOutDescription];
                break;
            case SlideOutBonPlan:
                [self setSlideOutOpen:self.slideOutVisible == SlideOutBonPlan ? NO : YES withType:SlideOutBonPlan];
            default:
                break;
        }
    }
}

- (void)setSlideOutOpen:(BOOL)open withType:(UNMSlideOut)type {
    [self setSlideOutOpen:open withType:type animated:YES];
}

#pragma mark - Data fetching

- (void)fetchMarkersWithMap:(GMSMapView *)map {
    void (^success)(NSArray *objects) = ^(NSArray *objects) {
        for (UNMMapItemBasic *item in objects) {
            dispatch_async(dispatch_get_main_queue(), ^{
                GMSMarker *marker = [GMSMarker new];
                marker.position = CLLocationCoordinate2DMake(item.lat, item.lon);
                marker.userData = item;
                marker.map = map;
                UIImage *icon = [self.markerIcons objectForKey:item.categoryID];
                if (!icon) {
                    [UNMCategoryIcons getCategoryImageWithCategoryProtocolItem:item success:^(UNMCategoryIcons *catIcon) {
                        marker.icon = catIcon.markerImage;
                        [self.markerIcons setObject:catIcon.markerImage forKey:item.categoryID];
                    }];
                } else {
                    marker.icon = icon;
                }
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeActivityIndicator];
        });
    };
    void (^fail)(void) = ^{ [self removeActivityIndicator]; };
    [self initActivityIndicator];
    [self.mapView clear];
    [[UNMUtilities mapManager].operationQueue cancelAllOperations];
    if (self.TabSelected == MapTabLeft) {
        [UNMMapItemBasic fetchMarkersWithMap:map categoryIds:self.categoryIDs success:success failure:fail];
    } else if (self.TabSelected == MapTabMiddle) {
        if ([self.categoryIDs count] > 0) {
            [UNMMapItemBasic fetchMarkersWithMap:map WithRootIDs:self.categoryIDs success:success failure:fail];
        } else {
            [UNMMapItemBasic fetchMarkersWithMap:map WithRootIDs:[NSArray arrayWithObject:[NSNumber numberWithInt:5]] success:success failure:fail];
        }
    } else if (self.TabSelected == MapTabRight) {
        if ([self.categoryIDs count] > 0) {
            [UNMMapItemBasic fetchMarkersWithMap:map WithRootIDs:self.categoryIDs success:success failure:fail];
        } else {
            [UNMMapItemBasic fetchMarkersWithMap:map WithRootIDs:[NSArray arrayWithObject:[NSNumber numberWithInt:2]] success:success failure:fail];
        }
    }
}

- (void)fetch20MarkersWithMap:(GMSMapView *)map {
    void (^success)(NSArray *objects) = ^(NSArray *objects) {
        for (UNMMapItemBasic *item in objects) { 
            dispatch_async(dispatch_get_main_queue(), ^{
                GMSMarker *marker = [GMSMarker new];
                marker.position = CLLocationCoordinate2DMake(item.lat, item.lon);
                marker.userData = item;
                marker.map = map;
                UIImage *icon = [self.markerIcons objectForKey:item.categoryID];
                if (!icon) {
                    [UNMCategoryIcons getCategoryImageWithCategoryProtocolItem:item success:^(UNMCategoryIcons *catIcon) {
                        marker.icon = catIcon.markerImage;
                        [self.markerIcons setObject:catIcon.markerImage forKey:item.categoryID];
                    }];
                } else {
                    marker.icon = icon;
                }
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeActivityIndicator];
        });
    };
    void (^fail)(void) = ^{ [self removeActivityIndicator]; };
    [self initActivityIndicator];
    [self.mapView clear];
    [[UNMUtilities mapManager].operationQueue cancelAllOperations];
    if (self.TabSelected == MapTabLeft) {
        [UNMMapItemBasic fetch20MarkersWithSuccess:success failure:fail];
    }
}

- (void)loadImageMapDataWithURL:(NSString *)imageMapURL {
    self.imageMap = [[UNMImageMap alloc]initWithURLStr:imageMapURL andCallback:^(UNMImageMap *imgMap){
        [self loadImageMapWithURL:imgMap.imageUrl];
        [self initActivityIndicator];
        [self.mapView clear];
        NSString *path = [imgMap.poisURLStr stringByReplacingOccurrencesOfString:kBaseApiURLStr withString:@""];
        [UNMMapItemBasic fetchMarkersWithMap:self.mapView andPath:path success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeActivityIndicator];
            });
        } failure:^{
            [self removeActivityIndicator];
        }];
    }];
}

- (void)loadImageMapWithURL:(NSURL *)imageURL {
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *imgMap = responseObject;
            CLLocationCoordinate2D mapCenter = CLLocationCoordinate2DMake(0, 0);
            CLLocationDistance heigthDistance = imgMap.size.height*imgMap.scale;
            CLLocationDistance widthDistance = imgMap.size.width*imgMap.scale;
            CLLocationCoordinate2D n = GMSGeometryOffset(mapCenter, heigthDistance/2, 0);
            CLLocationCoordinate2D s = GMSGeometryOffset(mapCenter, heigthDistance/2, 180);
            CLLocationCoordinate2D e = GMSGeometryOffset(mapCenter, widthDistance/2, 90);
            CLLocationCoordinate2D w = GMSGeometryOffset(mapCenter, widthDistance/2, 270);
            CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(s.latitude, w.longitude);
            CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(n.latitude, e.longitude);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageMapBounds = [[GMSCoordinateBounds alloc] initWithCoordinate:southWest
                                                                      coordinate:northEast];
                GMSGroundOverlay *overlay = [GMSGroundOverlay groundOverlayWithBounds:self.imageMapBounds icon:imgMap];
                overlay.bearing = 0;
                overlay.map = self.mapView;
                GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:self.imageMapBounds withPadding:0];
                [self.mapView moveCamera:update];
                [self.mapView setMinZoom:self.mapView.camera.zoom maxZoom:kGMSMaxZoomLevel];
            });
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UNMUtilities showErrorWithTitle:@"Impossible d'obtenir l'image du plan du bâtiment" andMessage:[error localizedDescription] andDelegate:nil];
    }];
    [requestOperation start];
}

#pragma mark - Map view delegate

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    if (self.imageMapUrl) {
        if (![self.imageMapBounds containsCoordinate:position.target]) {
            GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate setTarget:self.lastPosition];
            [self.mapView moveCamera:cameraUpdate];
        } else {
            self.lastPosition = position.target;
        }
    }
}

-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    [self toggleSlideOutWithType:SlideOutDescription];
    self.descSlideOut.mapItem = marker.userData;
    [self.descSlideOut setSelectedTab:0];
    return YES;
}

#pragma mark - Location services

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        if (status == kCLAuthorizationStatusAuthorized || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            [manager startUpdatingLocation];
        }
    } else {
        [manager startUpdatingLocation];
    }
}

- (void)startLocationServices {
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self requestInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations firstObject];
    if (location && !self.forHomeView) {
        GMSCameraUpdate *update = [GMSCameraUpdate setTarget:location.coordinate];
        [self.mapView moveCamera:update];
        [manager stopUpdatingLocation];
    }
}

- (void)requestInUseAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = @"Les services de géolocalisation sont désactivés";
        NSString *message = @"Pour utiliser la géolocalisation, vous devez activer leur utilisation dans le paramétrage des services de géolocalisation.";
        UIAlertView *alertView;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") && &UIApplicationOpenSettingsURLString != NULL) {
            alertView = [[UIAlertView alloc] initWithTitle:title
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:@"Annuler"
                                         otherButtonTitles:@"Paramètres", nil];
        } else {
            alertView = [[UIAlertView alloc] initWithTitle:title
                                                   message:message
                                                  delegate:self
                                         cancelButtonTitle:@"Annuler"
                                         otherButtonTitles:nil];
        }
        [alertView show];
        [self centerMapOnUniversity];
    }
    // The user has not enabled any location services. Request in use authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }
        }
        [self centerMapOnUniversity];
    }
}

- (void)centerMapOnUniversity {
    UNMUniversityBasic *univ = [UNMUniversityBasic getSavedObject];
    if (univ && self.mapView) {
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(univ.center.x, univ.center.y);
        GMSCameraUpdate *update = [GMSCameraUpdate setTarget:location];
        [self.mapView moveCamera:update];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        if (&UIApplicationOpenSettingsURLString != NULL) { //ios8 feature
            if (buttonIndex == 1) {
                // Send the user to the Settings for this app
                NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:settingsURL];
            }
        }
    }
}

- (void)updateCategoryIDsWithArray:(NSArray *)ids {
    if ([self.categoryIDs isEqualToArray:ids]) {
        return;
    } else {
        self.categoryIDs = ids;
        [self fetchMarkersWithMap:self.mapView];
    }
}

- (void)resetCategoryIDs {
    [self updateCategoryIDsWithArray:[self.categorySlideOut getSelectedCategoryIDS]];
}


- (void)closeDescriptionView {
    [self toggleSlideOutWithType:SlideOutDescription];
}

- (void)didSelectBonPlan:(id)sender {
    [self toggleSlideOutWithType:SlideOutBonPlan];
}

#pragma mark - QR handling

- (void)didSelectQrCode:(id)sender {
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    [reader.scanner setSymbology: ZBAR_QRCODE
                          config: ZBAR_CFG_ENABLE
                              to: 1];
    reader.readerView.zoom = 1.0;
    [self presentViewController:reader animated:YES completion:^{}];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    for(ZBarSymbol *symbol in results) {
        NSDictionary *dict = [UNMUtilities parseQueryString:[symbol data]];
        NSString *ID = dict[@"ID"];
        if (ID != nil && ![ID isEqualToString:@"null"]) {
            [picker dismissViewControllerAnimated:YES completion:^{
                [UNMUtilities setCenterControllerToImageMapWithURL:[NSString stringWithFormat:@"imageMaps/%d",[ID intValue]]];
            }];
        }
    }
    
}

- (void)reloadController {
    [self.mapView clear];
    self.mapView = nil;
    [UNMUtilities setCenterControllerToMapIgnoreCurrent];
}

#pragma mark - Segues

- (void)displaySearch {
    [self performSegueWithIdentifier:@"search" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"search"]) {
        UNMSearchViewController *searchVC = [segue destinationViewController];
        searchVC.delegate = self;
    }
}

#pragma mark - UNMSearchViewControllerDelegate

- (void)setSelectedMapItem:(UNMMapItemBasic *)mapItem {
    self.singleItem = mapItem;
    [self toggleSlideOutWithType:SlideOutNone];
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(mapItem.lat, mapItem.lon);
    GMSMarker *marker = [GMSMarker markerWithPosition:location];
    marker.userData = mapItem;
    marker.map = self.mapView;
    [UNMCategoryIcons getCategoryImageWithCategoryProtocolItem:mapItem success:^(UNMCategoryIcons *catIcon) {
        marker.icon = catIcon.markerImage;
        [self.markerIcons setObject:catIcon.markerImage forKey:mapItem.categoryID];
    }];
    GMSCameraUpdate *update = [GMSCameraUpdate setTarget:location];
    [self.mapView moveCamera:update];
    AFHTTPRequestOperationManager *manager = [UNMUtilities mapManager];
    [manager.operationQueue cancelAllOperations];
    [self removeActivityIndicator];
}

- (NSNumber *)getCategoryID {
    UNMTabButton *tab = [self getSelectedTab];
    if (self.leftTab == tab) {
        return [NSNumber numberWithInt:1];
    } else if (self.middleTab == tab) {
        return [NSNumber numberWithInt:5];
    } else {
        return [NSNumber numberWithInt:2];
    }
}

- (NSNumber *)getUniversityID {
    UNMTabButton *tab = [self getSelectedTab];
    if (self.leftTab == tab) {
        UNMUniversityBasic *univ = [UNMUniversityBasic getSavedObject];
        if (univ) {
            return [univ univId];
        }
        return nil;
    } else {
        return nil;
    }
}

#pragma mark - UNMDescriptionViewDelegate

- (BOOL)itemBookmarked:(UNMMapItemBasic *)item {
    for (UNMBookmarkBasic *bookmark in self.userBookmarks) {
        if ([bookmark.poiId isEqualToNumber:item.ID]) {
            return YES;
        }
    }
    [self fetchUserBookmarks];
    return NO;
}

- (UNMBookmarkBasic *)bookmarkForMapItem:(UNMMapItemBasic *)item {
    for (UNMBookmarkBasic *bookmark in self.userBookmarks) {
        if ([bookmark.poiId isEqualToNumber:item.ID]) {
            return bookmark;
        }
    }
    [self fetchUserBookmarks];
    return nil;
}

#pragma mark - UNMDescriptionViewDelegate

- (void)updateUserBookmarksWithBookmark:(UNMBookmarkBasic *)bookmark {
    self.userBookmarks = [self.userBookmarks arrayByAddingObject:bookmark];
    [self fetchUserBookmarks];
}

- (void)removeUserBookmark:(UNMBookmarkBasic *)bookmark {
    NSMutableArray *newArray = [[NSMutableArray alloc]initWithCapacity:[self.userBookmarks count]-1];
    for (UNMBookmarkBasic *item in self.userBookmarks) {
        if (![item.poiId isEqual:bookmark.poiId]) {
            [newArray addObject:item];
        }
    }
    self.userBookmarks = [NSArray arrayWithArray:newArray];
}


@end
