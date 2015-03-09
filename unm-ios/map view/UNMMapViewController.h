//
//  UNMMapViewController.h
//  unm-ios
//
//  Created by UnivMobile on 1/16/15.
//  Copyright (c) 2015 UnivMobile. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "UNMBaseViewController.h"
#import "UNMDescriptionViewController.h"
#import "UNMBonPlanViewController.h"
#import "UNMCategoryViewController.h"
#import "AFNetworking.h"
#import "ZBarSDK.h"
#import "UNMSearchViewController.h"

typedef NS_ENUM(NSInteger, UNMMapTabs) {
    MapTabNone,
    MapTabLeft,
    MapTabMiddle,
    MapTabRight
};

@interface UNMMapViewController : UNMBaseViewController<CLLocationManagerDelegate,GMSMapViewDelegate,UNMDescriptionViewDelegate,UNMBonPlanViewControllerDelegate,UNMCategoryViewControllerDelegate,ZBarReaderDelegate,UNMSearchViewControllerDelegate>
@property (strong, nonatomic) NSLayoutConstraint *descSlideOutHeightConst;
@property (strong, nonatomic) NSLayoutConstraint *descSlideBottomConst;
@property (strong, nonatomic) NSLayoutConstraint *bonPlanSlideOutHeightConst;
@property (strong, nonatomic) NSLayoutConstraint *bonPlanSlideBottomConst;
@property (strong, nonatomic) NSLayoutConstraint *categorySlideOutHeightConst;
@property (strong, nonatomic) NSLayoutConstraint *categorySlideBottomConst;
@property (strong, nonatomic) UNMDescriptionViewController *descSlideOut;
@property (strong, nonatomic) UNMBonPlanViewController *bonPlanSlideOut;
@property (strong, nonatomic) UNMCategoryViewController *categorySlideOut;
@property (strong, nonatomic) UIControl *bonPlanButton;
@property (strong, nonatomic) UIControl *qrCodeButton;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *imageMapUrl;
@property (strong, nonatomic) UNMMapItemBasic *singleItem;
@property (nonatomic) UNMMapTabs TabSelected;
@property (nonatomic) BOOL forHomeView;
@property (strong, nonatomic) NSNumber *preselectedCategoryID;
@end
