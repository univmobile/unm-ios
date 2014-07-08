//
//  UNMViewFx.h
//  UnivMobile
//
//  Created by David Andrianavalontsalama on 06/07/2014.
//  Copyright (c) 2014 UNPIdF. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    UNMPageTransitionTypeSliding
} UNMPageTransitionType;

typedef enum {
    UNMPageTransitionEdgeTop
} UNMPageTransitionEdge;


@interface UNMViewFxVerticalSliderFromTo : NSObject

- (void) scrollBackFrontView;
- (void) scrollOutFrontView;

@end

@interface UNMViewFx : NSObject

// Create an instance of UNMViewFxVerticalSliderFromTo
// that will transition from a view to another using a "slide" gesture.
//
// The "autorelease_" prefix means the returned object will be created as already
// associated (RETAIN) to an existing object (actually "fromView") and should not
// be retained elsewhere, particularly as a "@property (strong)" in the calling class.
// Use "@property (weak)" in the calling class in case you need a property there,
// otherwise don’t even bother to name a variable to hold this method’s result.
// The created instance of UNMViewFxVerticalSliderFromTo will be released when the
// "fromView" object will be released from memory.
+ (UNMViewFxVerticalSliderFromTo*)autorelease_viewFx:(UNMPageTransitionType)UNMPageTransitionSliding
											fromView:(UIView*)fromView
											  toView:(UIView*)toView
												edge:(UNMPageTransitionEdge)edge;

@end
