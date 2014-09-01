//
//  UNMMapController.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 01/09/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMMapController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "UNMPoisData.h"
#import "UNMPoiData.h"

@interface UNMMapController ()

@property (assign, nonatomic) GMSMapView* mapView;

@end

@implementation UNMMapController

@synthesize appLayer = _appLayer;

- (instancetype) initWithAppLayer:(UNMAppLayer*)appLayer {
	
    self = [super init];
	
    if (self) {
		
		_appLayer = appLayer;
		
		[self.appLayer addCallback:self];
		
		self.tabBarItem = [[UITabBarItem alloc] //initWithTitle:@"Plan"
						   initWithTitle:NULL
						   image:[UIImage imageNamed:@"earth-usa.png"] tag:2];
		
		self.tabBarItem.accessibilityLabel = @"Plan";
    }
	
    return self;
}

// Override: UIViewController
- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	//self.accessibilityIdentifier = @"table-pois";
	
	//self.view.backgroundColor = [UNMConstants RGB_9bc9e1];
	
	//self.view.backgroundColor = [UIColor redColor];
	
/*	self.tabBarController.title = @"POIs";
	//self.title = @"POIs";
	
	UIBarButtonItem* const rightBarButton = [[UIBarButtonItem alloc]
											 initWithTitle:@"Retour"
											 style:UIBarButtonItemStyleBordered
											 target:nil
											 action:nil];
	rightBarButton.accessibilityIdentifier = @"button-retour";
	
	//self.navigationItem.rightBarButtonItem = rightBarButton;
	self.tabBarController.navigationItem.rightBarButtonItem = rightBarButton;
	
	@weakify(self)
	
	rightBarButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
		
		@strongify(self)
		
		[self.appLayer goBackFromGeocampus];
		
		return [RACSignal empty];
	}];
 */
	
	//[super viewDidLoad];
	NSLog(@"--------------camera");
	GMSCameraPosition* const camera = [GMSCameraPosition cameraWithLatitude:-33.868
															longitude:151.2086
																 zoom:12];
	
	GMSMapView* const mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];

	mapView.userInteractionEnabled = YES;
//	mapView.settings.
	
	/*
	GMSMarker* const marker = [[GMSMarker alloc] init];
	marker.position = camera.target;
	marker.snippet = @"Hello World";
	marker.appearAnimation = kGMSMarkerAnimationPop;
	marker.map = mapView;
	 */
	
	self.mapView = mapView;
	
	self.view = mapView;
	
	[self callbackRefreshPoisData];
}

// Override: UIViewController
- (void)didReceiveMemoryWarning {
	
    [super didReceiveMemoryWarning];
	
}

// Override: UIViewController
- (void)viewWillLayoutSubviews {
	
	 // TODO: Add a swiepable infoZone at the bottom? Above the tabBar?
	 
	NSLog(@"Map.viewWillLayoutSubviews");
	
	const CGRect enclosingFrame = self.view.superview.frame;
	
	const CGRect navBarFrame = self.tabBarController.navigationController.navigationBar.frame;
	NSLog(@"navBar:%f,%f %f,%f",navBarFrame.origin.x,navBarFrame.origin.y,
		  navBarFrame.size.width,navBarFrame.size.height);
	
	const CGRect tabBarFrame = self.tabBarController.tabBar.frame;
	NSLog(@"tabBar:%f,%f %f,%f",tabBarFrame.origin.x,tabBarFrame.origin.y,
		  tabBarFrame.size.width,tabBarFrame.size.height);
	
	const CGFloat viewHeight = self.view.window.rootViewController.view.bounds.size.height;
	
	NSLog(@"viewHeight:%f",viewHeight);
	
	const BOOL IS_IOS6 = (viewHeight == 548.0f || viewHeight == 460.0f);
	
	self.view.frame = CGRectMake(
								 enclosingFrame.origin.x,
								 navBarFrame.origin.y+
								 (IS_IOS6 ? 0 : navBarFrame.size.height),
								 enclosingFrame.size.width ,
								 tabBarFrame.origin.y
								 -navBarFrame.origin.y-
								 (IS_IOS6 ? 0 : navBarFrame.size.height));
	
	[super viewWillLayoutSubviews];
	
}

// Override: UIViewController
- (void)viewDidLayoutSubviews {
	
	[super viewDidLayoutSubviews];
	
	//NSLog(@"viewDidLayoutSubviews");
}

#pragma mark - AppLayer Callbacks

// Override: UNMAppViewCallback
- (void) callbackRefreshPoisData {
	
	if (!self.appLayer.poisData) return;
	
	//[self.tableView reloadData];
	
	// NSLog(@"Map:callbackRefreshPoisData()");
	
	[self.mapView clear];
	
	BOOL hasCenter = NO;
	CLLocationDegrees centerLat = 0.0;
	CLLocationDegrees centerLng = 0.0;
	
	for (UNMPoiGroupData* const poiGroup in self.appLayer.poisData.poiGroups) {
		
		for (UNMPoiData* const poi in poiGroup.pois) {
			
			if (!hasCenter) {
				centerLat = poi.lat;
				centerLng = poi.lng;
				hasCenter = YES;
			}
			
			//NSLog(@"c:%@, l/l:%f,%f", poi.coordinates,poi.lat,poi.lng);
			
			GMSMarker* const marker = [[GMSMarker alloc] init];
			
			marker.position = CLLocationCoordinate2DMake(poi.lat, poi.lng);
			marker.snippet = poi.name;
			marker.appearAnimation = kGMSMarkerAnimationPop;
			marker.map = self.mapView;
		}
	}
	
	if (hasCenter) {
		NSLog(@"c:xxx, l/l:%f,%f", centerLat,centerLng);
		[self.mapView animateToLocation:CLLocationCoordinate2DMake(centerLat, centerLng)];
		//[self.mapView setNeedsDisplay];
	}
	
	//self.mapView.
}

@end
