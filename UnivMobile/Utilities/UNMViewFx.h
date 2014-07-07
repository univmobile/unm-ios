//
//  UNMViewFx.h
//  UnivMobile
//
//  Created by David on 06/07/2014.
//  Copyright (c) 2014 David. All rights reserved.
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

+ (UNMViewFxVerticalSliderFromTo*)createPageTransition:(UNMPageTransitionType)UNMPageTransitionSliding
				 fromView:(UIView*)fromView
				   toView:(UIView*)toView
					 edge:(UNMPageTransitionEdge)edge;

@end
