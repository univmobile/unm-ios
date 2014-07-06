//
//  UNMAppLayer.m
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 06/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import "UNMAppLayer.h"

@interface UNMAppLayer ()

@property (strong, nonatomic, readonly) NSArray* regionsData; // array of UNMRegionData*

@property (strong, nonatomic) NSMutableArray* callbacks; // array of NSObject*

@end

@implementation UNMAppLayer

- (id) init {
	
	self = [super init];
	
	if (self) {
		
		NSMutableArray* const array = [[NSMutableArray alloc] init];
		
		// TODO hardcoded values
		
		[array addObject:[[UNMRegionData alloc] initWithId:@"bretagne" label:@"Bretagne"]];
		[array addObject:[[UNMRegionData alloc] initWithId:@"unrpcl" label:@"Limousin/Poitou-Charentes"]];
		[array addObject:[[UNMRegionData alloc] initWithId:@"ile_de_france" label:@"Île de France"]];
		
		_regionsData = array;
		
		[self addUniversityId:@"ubo" title:@"Université de Bretagne Occidentale" toRegionId:@"bretagne"];
		[self addUniversityId:@"rennes1" title:@"Université de Rennes 1" toRegionId:@"bretagne"];
		[self addUniversityId:@"rennes2" title:@"Université Rennes 2" toRegionId:@"bretagne"];
		[self addUniversityId:@"enscr" title:@"École Nationale Supérieure de Chimie de Rennes" toRegionId:@"bretagne"];
		
		[self addUniversityId:@"ulr" title:@"Université de La Rochelle" toRegionId:@"unrpcl"];
		[self addUniversityId:@"ul" title:@"Université de Limoges" toRegionId:@"unrpcl"];
		[self addUniversityId:@"up" title:@"Université de Poitiers" toRegionId:@"unrpcl"];
		[self addUniversityId:@"ensma" title:@"ISAE-ENSMA" toRegionId:@"unrpcl"];
		[self addUniversityId:@"crousp" title:@"CROUS PCL" toRegionId:@"unrpcl"];
		
		[self addUniversityId:@"paris1" title:@"Paris 1 Panthéon-Sorbonne" toRegionId:@"ile_de_france"];
		[self addUniversityId:@"paris3" title:@"Paris 3 Sorbonne Nouvelle" toRegionId:@"ile_de_france"];
		[self addUniversityId:@"paris13" title:@"Paris Nord" toRegionId:@"ile_de_france"];
		[self addUniversityId:@"uvsq" title:@"UVSQ" toRegionId:@"ile_de_france"];
		[self addUniversityId:@"museum" title:@"Muséum national d'Histoire naturelle" toRegionId:@"ile_de_france"];
		[self addUniversityId:@"evry" title:@"Evry-Val d'Essonne" toRegionId:@"ile_de_france"];
		[self addUniversityId:@"paris6" title:@"UPMC" toRegionId:@"ile_de_france"];
		[self addUniversityId:@"paris7" title:@"Paris Diderot" toRegionId:@"ile_de_france"];
		[self addUniversityId:@"paris8" title:@"Paris 8" toRegionId:@"ile_de_france"];
		[self addUniversityId:@"paris10" title:@"Paris Ouest Nanterre la Défense" toRegionId:@"ile_de_france"];
		[self addUniversityId:@"paris11" title:@"Paris-Sud" toRegionId:@"ile_de_france"];
		[self addUniversityId:@"upec" title:@"UPEC" toRegionId:@"ile_de_france"];
		[self addUniversityId:@"crousVersailles" title:@"Cergy-Pontoise" toRegionId:@"ile_de_france"];
		[self addUniversityId:@"paris1" title:@"CROUS Versailles" toRegionId:@"ile_de_france"];
		[self addUniversityId:@"enscachan" title:@"ENS Cachan" toRegionId:@"ile_de_france"];
		[self addUniversityId:@"ensiie" title:@"ENSIIE" toRegionId:@"ile_de_france"];
		[self addUniversityId:@"unpidf" title:@"UNPIdF" toRegionId:@"ile_de_france"];
		[self addUniversityId:@"enc" title:@"École nationale des chartes" toRegionId:@"ile_de_france"];
		
		_callbacks = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void) setSelectedRegionId:(NSString*)selectedRegionId {
	
	_selectedRegionId = selectedRegionId;
}

- (void) setSelectedUniversityId:(NSString*)selectedUniversityId {
	
	_selectedUniversityId = selectedUniversityId;
}

#pragma mark - Internal data

- (NSUInteger) sizeOfRegionData {
	
	return [_regionsData count];
}

- (UNMRegionData*) getRegionDataAtIndex:(NSUInteger)row {
	
	return [_regionsData objectAtIndex:row];
}

- (UNMRegionData*)getRegionDataById:(NSString*)regionId {
	
	for (UNMRegionData* const regionData in _regionsData) {
		
		if ([regionData.id isEqualToString:regionId]) {
			
			return regionData;
		}
	}
	
	return NULL;
}

- (UNMUniversityData*)getUniversityDataById:(NSString*)universityId {
	
	for (UNMRegionData* const regionData in _regionsData) {
		
		for (UNMUniversityData* const universityData in regionData.universities) {
			
			if ([universityData.id isEqualToString:universityId]) {
				
				return universityData;
			}
		}
	}
	
	return NULL;
}

- (void)addUniversityId:(NSString*)id title:(NSString*)title toRegionId:(NSString*)regionId {
	
	UNMRegionData* const regionData = [self getRegionDataById:regionId];
	
	if (regionData) {
		
		[regionData addUniversityWithId:id title:title];
	}
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

- (void) showUniversityList {
	
	[self invokeCallbacksForSelector:@selector(showUniversityList)];
}

// Add a @"callback_" prefix to a selector name,
// to find what callback method must be called.
+ (SEL) calcCallbackSelector:(SEL)selector {
	
	NSString* const selectorAsString = NSStringFromSelector(selector);
	
	return NSSelectorFromString([@"callback_" stringByAppendingString:selectorAsString]);
}

// This method fires all callbacks for the given selector.
// Example: If the selector is @(doSomething),
// all methods named @(callback_doSomething) in the registered callback objects
// will be invoked.
- (void) invokeCallbacksForSelector:(SEL)selector {
	
	const SEL callback_selector = [UNMAppLayer calcCallbackSelector:selector];
	
	for (NSObject* const callback in _callbacks) {
		
		if ([callback respondsToSelector:callback_selector]) {
			
#pragma clang push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
			[callback performSelector:callback_selector];
#pragma clang pop
			
			/*
			 // Or, without any warning:
			 const IMP implementation = [callback methodForSelector:callback_selector];
			 void (*function)(id, SEL) = (void*)implementation;
			 function(callback, callback_selector);
			 */
		}
	}
}

// This method fires all callbacks for the given selector.
// Example: If the selector is @(doSomething:),
// all methods named @(callback_doSomething:) in the registered callback objects
// will be invoked.
- (void) invokeCallbacksForSelector:(SEL)selector withObject:(id)arg {
	
	const SEL callback_selector = [UNMAppLayer calcCallbackSelector:selector];
	
	for (NSObject* const callback in _callbacks) {
		
		if ([callback respondsToSelector:callback_selector]) {
			
#pragma clang push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
			[callback performSelector:callback_selector withObject:arg];
#pragma clang pop
			
			/*
			 // Or, without any warning: (arg should then explicitly be a NSString*):
			 const IMP implementation = [callback methodForSelector:callback_selector];
			 void (*function)(id, SEL, NSString*) = (void*)implementation;
			 function(callback, callback_selector, arg);
			 */
		}
	}
}

@end
