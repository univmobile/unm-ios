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
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import <EXTScope.h>

@interface UNMMapController ()

@property (strong, nonatomic, readonly) GMSMapView* mapView;
@property (strong, nonatomic, readonly) UIView* infoView;
@property (strong, nonatomic, readonly) UILabel* poiNameLabel;
@property (strong, nonatomic, readonly) UILabel* poiAddressLabel;
@property (weak, nonatomic) UNMPoiData* selectedPoi;
@property (assign, nonatomic) NSInteger selectedPoiId;
@property (strong, nonatomic) NSMutableArray* markers; // Array of Markers
@property (weak, nonatomic, readonly) UNMDetailsController* detailsController;

//@property (assign, nonatomic) BOOL noSelectedPoi;
@property (assign, nonatomic) BOOL tabSelected;

@end

@implementation UNMMapController

@synthesize appLayer = _appLayer;

- (instancetype) initWithAppLayer:(UNMAppLayer*)appLayer
				detailsController:(UNMDetailsController*)detailsController {
	
    self = [super init];
	
    if (self) {
		
		_appLayer = appLayer;
		_detailsController = detailsController;
		
		[self.appLayer addCallback:self];
		
		self.tabBarItem = [[UITabBarItem alloc] //initWithTitle:@"Plan"
						   initWithTitle:nil
						   image:[UIImage imageNamed:@"earth-usa.png"] tag:2];
		
		self.tabBarItem.accessibilityLabel = @"Plan";
		
		self.tabSelected = NO;
		
		//NSLog(@"RESET self.selectedPoi");
		
		self.selectedPoi = nil;
		//self.noSelectedPoi = YES;
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
	
	// GOOGLE MAP
	
	const CGFloat ZOOM = 10.0;
	
	GMSCameraPosition* const camera = [GMSCameraPosition cameraWithLatitude:-33.868
															longitude:151.2086
																 zoom:ZOOM];
	
	GMSMapView* const mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];

	mapView.userInteractionEnabled = YES;
	
	mapView.delegate = self;
	
	_mapView = mapView;
	
	//self.view = mapView;
	
	[self.view addSubview:mapView];
	
	// POI INFO
	
	const CGRect frame = self.view.window.frame;
	
	const CGFloat width = frame.size.width;
	
	UIView* const infoView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 40.0)];
	
	_infoView = infoView;
	
	[self.view addSubview:infoView];
	
	infoView.backgroundColor = [UIColor whiteColor];
	
	UITapGestureRecognizer* const tapGestureRecognizer =
	[[UITapGestureRecognizer alloc] initWithTarget:self
											action:@selector(clickInfoView:)];
	
	[infoView addGestureRecognizer:tapGestureRecognizer];
	
	// POI INFO: NAME
	 
	_poiNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(4.0, 11.0, 200.0, 20.0)];
	self.poiNameLabel.text = @"Aucun POI sélectionné";
	self.poiNameLabel.textColor = [UIColor blackColor];
	self.poiNameLabel.font = [UIFont boldSystemFontOfSize:18.0];
	self.poiNameLabel.textAlignment = NSTextAlignmentCenter;
	self.poiNameLabel.backgroundColor = [UIColor whiteColor];
	self.poiNameLabel.accessibilityIdentifier = @"label-poi-name";
	
	[self.infoView addSubview:self.poiNameLabel];
	
	_poiAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(4.0, 36.0, 200.0, 18.0)];
	self.poiAddressLabel.text = @"(Adresse)";
	self.poiAddressLabel.textColor = [UIColor blackColor];
	self.poiAddressLabel.font = [UIFont systemFontOfSize:14.0];
	self.poiAddressLabel.textAlignment = NSTextAlignmentCenter;
	self.poiAddressLabel.backgroundColor = [UIColor whiteColor];
	self.poiAddressLabel.accessibilityIdentifier = @"label-poi-address";
	
	[self.infoView addSubview:self.poiAddressLabel];

	// REFRESH MARKERS

	[self refreshMarkers];
}

// Override: UIViewController
- (void)didReceiveMemoryWarning {
	
    [super didReceiveMemoryWarning];
}

// Override: UIViewController
- (void)viewWillLayoutSubviews {
	
	 // TODO: Add a swiepable infoZone at the bottom? Above the tabBar?
	 
	//NSLog(@"Map.viewWillLayoutSubviews");
	
	const CGRect enclosingFrame = self.view.superview.frame;
	
	const CGRect navBarFrame = self.tabBarController.navigationController.navigationBar.frame;
	//NSLog(@"navBar:%f,%f %f,%f",navBarFrame.origin.x,navBarFrame.origin.y,
	//	  navBarFrame.size.width,navBarFrame.size.height);
	
	const CGRect tabBarFrame = self.tabBarController.tabBar.frame;
	//NSLog(@"tabBar:%f,%f %f,%f",tabBarFrame.origin.x,tabBarFrame.origin.y,
	//	  tabBarFrame.size.width,tabBarFrame.size.height);
	
	const CGFloat viewHeight = self.view.window.rootViewController.view.bounds.size.height;
	
	const CGRect poiNameFrame = self.poiNameLabel.frame;
	const CGRect poiAddressFrame = self.poiAddressLabel.frame;
	
	//NSLog(@"viewHeight:%f",viewHeight);
	
	const BOOL IS_IOS6 = (viewHeight == 548.0f || viewHeight == 460.0f);
	
	const CGFloat x = enclosingFrame.origin.x;
	const CGFloat width = enclosingFrame.size.width;
	const CGFloat mapViewY = navBarFrame.origin.y
		+ (IS_IOS6 ? 0 : navBarFrame.size.height);
	const CGFloat infoViewHeight = tabBarFrame.size.height * 1.5;
	const CGFloat mapViewHeight = tabBarFrame.origin.y - navBarFrame.origin.y - infoViewHeight
		- (IS_IOS6 ? 0 : navBarFrame.size.height);
	
	self.mapView.frame = CGRectMake(x, mapViewY, width, mapViewHeight);
	
	self.infoView.frame = CGRectMake(x, mapViewY + mapViewHeight, width, infoViewHeight);
	
	// NSLog(@"poiNameFrame.origin.x: %f",poiNameFrame.origin.x);
	
	self.poiNameLabel.frame = CGRectMake(poiNameFrame.origin.x, poiNameFrame.origin.y,
										 width - 2 * poiNameFrame.origin.x,
										 poiNameFrame.size.height);
	self.poiAddressLabel.frame = CGRectMake(poiAddressFrame.origin.x, poiAddressFrame.origin.y,
										 width - 2 * poiAddressFrame.origin.x,
											poiAddressFrame.size.height);
				
	
	// [self.poiNameLabel setNeedsDisplay];
	
	// NSLog(@"self.poiNameLabel: %@",self.poiNameLabel);
	// NSLog(@"hidden:%d",self.poiNameLabel.isHidden);
	
	[super viewWillLayoutSubviews];
}

// Override: UIViewController
- (void)viewDidLayoutSubviews {
	
	[super viewDidLayoutSubviews];
	
	//NSLog(@"viewDidLayoutSubviews");
}

#pragma mark - UITabBarControllerDelegate

// Override: UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController*)tabBarController didSelectViewController:(UIViewController*)viewController {
	
	//NSLog(@"didSelectViewController");
	
	if (viewController != self) return;

	//NSLog(@"didSelectViewController: MAP %d", self.tabSelected);

	if (!self.tabSelected || self.selectedPoi == nil) {
		
		self.tabSelected = YES;
		
		if (!self.appLayer.poisData) return;
		
		for (UNMPoiGroupData* const poiGroup in self.appLayer.poisData.poiGroups) {
			
			for (UNMPoiData* const poi in poiGroup.pois) {
				
				[self selectPoi:poi];
				
				break;
			}
		}
	}
}

- (void) selectPoi:(UNMPoiData*)poi {
	
	//NSLog(@"selectPoi: nil?%d", poi == nil);
	
	self.poiNameLabel.text = poi.name;
	
	self.poiAddressLabel.text = poi.address;
	
	self.selectedPoi = poi;
	
	self.selectedPoiId = poi.id;
	
	GMSMarker* const marker = [self markerForPoi:poi];
	
	//self.mapView.selectedMarker = marker;
	
	[self.mapView animateToLocation:marker.position];
	
	self.mapView.selectedMarker = marker; // Show the infoWondow
}

#pragma mark - GMSMapViewDelegate

// Override: GMSMapViewDelegate
- (BOOL)mapView:(GMSMapView*)mapView didTapMarker:(GMSMarker*)marker {
	
	UNMPoiData* const poi = marker.userData;
	
	if (mapView.selectedMarker == marker) {
		
		mapView.selectedMarker = nil; // Hide the infoWondow
		
		//[self showDetailsPage:poi];
		
		return YES;
	}
	
	// NSLog(@"poi: %d", poi.id);
	
	[self selectPoi:poi];
	
	return YES;
}

// Override: GMSMapViewDelegate
-(void)mapView:(GMSMapView*)mapView didTapInfoWindowOfMarker:(GMSMarker*)marker{
	
	UNMPoiData* const poi = marker.userData;
	
	[self showDetailsPage:poi];
}

- (void) showDetailsPage:(UNMPoiData*)poi {
	
	self.detailsController.poi = poi;
	
	@weakify(self)
	
	dispatch_async(dispatch_get_main_queue(), ^{
		
		@strongify(self)
		
		[self.tabBarController.navigationController pushViewController:self.detailsController.tabBarController animated:YES];
		
		[self.detailsController.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
	});
}

#pragma mark - Gestures

- (void)clickInfoView:(UITapGestureRecognizer*)recognizer {

	// NSLog(@"clickInfoView, nil?%d", self.selectedPoi == nil);
	
	if (self.selectedPoi == nil) {
		
		self.selectedPoi = [self.appLayer poiById:self.selectedPoiId]; // After a refresh
	
		if (self.selectedPoi == nil) return;
	}
	
	GMSMarker* const marker = [self markerForPoi:self.selectedPoi];
	
	if (self.mapView.selectedMarker == marker) {
		
		[self showDetailsPage:self.selectedPoi];
		
	} else {
		
		[self selectPoi:self.selectedPoi];
		
		self.mapView.selectedMarker = marker; // Show the infoWondow
	}
}

#pragma mark - AppLayer Callbacks

// Override: UNMAppViewCallback
- (void) callbackRefreshPoisData {
	
	
	[self refreshMarkers];
}

#pragma mark - Markers

- (void) refreshMarkers {
	
	if (!self.appLayer.poisData) return;
	
	//[self.tableView reloadData];
	
	// NSLog(@"Map:callbackRefreshPoisData()");
	
	[self.mapView clear];
	
	self.markers = [[NSMutableArray alloc] init];
	
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
			// marker.title = poi.name;
			marker.userData = poi;
			marker.snippet = poi.name;
			// marker.appearAnimation = kGMSMarkerAnimationPop;
			marker.map = self.mapView;
			
			[self.markers addObject:marker];
		}
	}
	
	if (hasCenter) {
		//NSLog(@"c:xxx, l/l:%f,%f", centerLat,centerLng);
		[self.mapView animateToLocation:CLLocationCoordinate2DMake(centerLat, centerLng)];
		//[self.mapView setNeedsDisplay];
	}
	
	//self.mapView.
}

- (GMSMarker*)markerForPoi:(UNMPoiData*)poi {
	
	for (GMSMarker* const marker in self.markers) {
		
		if (marker.userData == poi) return marker;
	}
	
	return nil;
}

@end
