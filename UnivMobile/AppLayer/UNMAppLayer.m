//
//  UNMAppLayer.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 06/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMAppLayer.h"
#import "UNMInitialRegionsData.h"
#import "UNMJsonRegionsData.h"
#import "UNMJsonPoisData.h"
#import "UNMJsonFetcher.h"
#import "NSBundle+String.h"

@interface UNMAppLayer ()

@property (strong, nonatomic, readonly) NSMutableArray* callbacks; // array of NSObject*
@property (strong, nonatomic, readonly) NSBundle* bundle;
@property (strong, nonatomic, readonly) NSObject <UNMJsonFetcher>* jsonFetcher;
@property (strong, nonatomic, readonly) UNMJsonRegionsData* jsonRegionsData;
@property (strong, nonatomic, readonly) UNMJsonPoisData* jsonPoisData;

@end

@implementation UNMAppLayer

- (instancetype) initWithBundle:(NSBundle*)bundle jsonFetcher:(NSObject<UNMJsonFetcher>*)jsonFetcher {

	self = [super init];
	
	if (self) {
		
		_bundle = bundle;
		
		_buildInfo = [[UNMBuildInfo alloc] initWithBundle:bundle];
		
		[self loadInitialRegionsData];
		
		_callbacks = [[NSMutableArray alloc] init];
		_jsonFetcher = jsonFetcher;
		
		NSString* const jsonBaseURL = [bundle stringForKey:@"UNMJsonBaseURL" defaultValue:nil];
		// NSLog(@"bundle: %@", bundle);
		
		// NSLog(@"UNMAppLayer:jsonBaseURL: %@",jsonBaseURL);
		
		_jsonRegionsData = [[UNMJsonRegionsData alloc] initWithJSONBaseURL:jsonBaseURL];
		_jsonPoisData = [[UNMJsonPoisData alloc] initWithJSONBaseURL:jsonBaseURL];
	}
	
	return self;
}

- (void) setSelectedRegionId:(NSString*)selectedRegionId {
	
	_selectedRegionId = selectedRegionId;
}

- (void) setSelectedUniversityId:(NSString*)selectedUniversityId {
	
	_selectedUniversityId = selectedUniversityId;
}

#pragma mark - AppLayer Callbacks

- (void) addCallback:(NSObject*)callback {
	
	[_callbacks addObject:callback];
}

- (void) setSelectedRegionIdInList:(NSString*) regionId {
	
	[self invokeCallbacksForSelector:@selector(setSelectedRegionIdInList:) withObject:regionId];
}

- (void) setSelectedUniversityIdInList:(NSString*) universityId {
	
	[self invokeCallbacksForSelector:@selector(setSelectedUniversityIdInList:) withObject:universityId];
}

- (void) goBackFromRegions {
	
	[self invokeCallbacksForSelector:@selector(goBackFromRegions)];
}

- (void) goBackFromGeocampus {
	
	//NSLog(@"AppLayer.goBackFromGeocampus...");
	
	[self invokeCallbacksForSelector:@selector(goBackFromGeocampus)];
}

- (void) showUniversityList {
	
	[self invokeCallbacksForSelector:@selector(showUniversityList)];
}

// Add a @"callback" prefix to a (capitalized-) selector name,
// to find what callback method must be called.
+ (SEL) calcCallbackSelector:(SEL)selector {
	
	NSString* const selectorAsString = NSStringFromSelector(selector);
	
	NSString* const callbackSelectorAsString = [@"callback" stringByAppendingString:
												[[[selectorAsString substringToIndex:1] capitalizedString]
												 stringByAppendingString:[selectorAsString substringFromIndex:1]]
												];
	
	return NSSelectorFromString(callbackSelectorAsString);
}

// This method fires all callbacks for the given selector.
// Example: If the selector is @(doSomething),
// all methods named @(callbackDoSomething) in the registered callback objects
// will be invoked.
- (void) invokeCallbacksForSelector:(SEL)selector {
	
	const SEL callbackSelector = [UNMAppLayer calcCallbackSelector:selector];
	
	for (NSObject* const callback in _callbacks) {
		
		if ([callback respondsToSelector:callbackSelector]) {
			
#pragma clang push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
			[callback performSelector:callbackSelector];
#pragma clang pop
			
			/*
			 // Or, without any warning:
			 const IMP implementation = [callback methodForSelector:callbackSelector];
			 void (*function)(id, SEL) = (void*)implementation;
			 function(callback, callbackSelector);
			 */
		}
	}
}

// This method fires all callbacks for the given selector.
// Example: If the selector is @(doSomething:),
// all methods named @(callbackDoSomething:) in the registered callback objects
// will be invoked.
- (void) invokeCallbacksForSelector:(SEL)selector withObject:(id)arg {
	
	const SEL callbackSelector = [UNMAppLayer calcCallbackSelector:selector];
	
	for (NSObject* const callback in _callbacks) {
		
		if ([callback respondsToSelector:callbackSelector]) {
			
#pragma clang push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
			[callback performSelector:callbackSelector withObject:arg];
#pragma clang pop
			
			/*
			 // Or, without any warning: (arg should then explicitly be a NSString*):
			 const IMP implementation = [callback methodForSelector:callbackSelector];
			 void (*function)(id, SEL, NSString*) = (void*)implementation;
			 function(callback, callbackSelector, arg);
			 */
		}
	}
}

#pragma mark - Regions

- (UNMRegionsData*)loadInitialRegionsData {
	
	UNMRegionsData* const regionsData = [UNMInitialRegionsData loadInitialRegionsData];
	
	if (regionsData != nil) {
		
		_regionsData = regionsData;
	}
	
	return _regionsData;
}

- (void) refreshRegionsData {
	
	// Please keep this method synchronous so automatic callbacks may occur consistently.
	// Use the asyncXxxYyy naming pattern for asynchronous tasks.
	
	// NSLog(@"self.jsonRegionsData: %@", self.jsonRegionsData);
	// NSLog(@"self.jsonFetcher: %@", self.jsonFetcher);
	
	UNMRegionsData* const regionsData = [self.jsonRegionsData fetchRegionsData:self.jsonFetcher
															withErrorHandler:^(NSError* error) {
		
		UIAlertView* alert = [[UIAlertView alloc]
							  initWithTitle:@"Erreur de transmission"
							  message:[NSString stringWithFormat:@"Build %@ %@",
									   self.buildInfo.BUILD_DISPLAY_NAME, error]
							  delegate:nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil
							  ];
		
		[alert show];
		
	}];
	
	// NSLog(@"regionsData: %@",regionsData);
	
	if (regionsData != nil) {
		
		_regionsData = regionsData;
		
		_regionsData.refreshedAt = [NSDate date];

		[self invokeCallbacksForSelector:@selector(refreshRegionsData)];
	}
}

#pragma mark - POIs

- (void) refreshPoisData {
	
	// Please keep this method synchronous so automatic callbacks may occur consistently.
	// Use the asyncXxxYyy naming pattern for asynchronous tasks.
	
	// NSLog(@"refreshPoisData");
	
	// NSLog(@"self.jsonPoisData: %@", self.jsonPoisData);
	// NSLog(@"self.jsonFetcher: %@", self.jsonFetcher);
	
	UNMPoisData* const poisData = [self.jsonPoisData fetchPoisData:self.jsonFetcher
															  withErrorHandler:^(NSError* error) {
																  
																  UIAlertView* alert = [[UIAlertView alloc]
																						initWithTitle:@"Erreur de transmission"
																						message:[NSString stringWithFormat:@"Build %@ %@",
																								 self.buildInfo.BUILD_DISPLAY_NAME, error]
																						delegate:nil
																						cancelButtonTitle:@"OK"
																						otherButtonTitles:nil
																						];
																  
																  [alert show];
																  
															  }];
	
	// NSLog(@"poisData: %@",poisData);
	
	if (poisData != nil) {
		
		_poisData = poisData;
		
		// _poisData.refreshedAt = [NSDate date];
		
		[self invokeCallbacksForSelector:@selector(refreshPoisData)];
	}
}

- (UNMPoiData*) poiById:(NSInteger)poiId {
	
	if (self.poisData == nil) return nil;
	
	for (UNMPoiGroupData* poiGroup in self.poisData.poiGroups) {
		
		for (UNMPoiData* const poi in poiGroup.pois) {
			
			if (poi.id == poiId) return poi;
		}
	}
	
	return nil;
}

@end
