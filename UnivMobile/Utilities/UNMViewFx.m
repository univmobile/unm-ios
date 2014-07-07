//
//  UNMViewFx.m
//  UnivMobile
//
//  Created by David on 06/07/2014.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "UNMViewFx.h"
#import <objc/runtime.h>

@interface UNMViewFx ()

@property (strong, nonatomic) UIGestureRecognizer* gestureRecognizer;

@end

@interface UNMViewFxVerticalSliderFromTo()

- (instancetype) initWithFromView:(UIView*)fromView toView:(UIView*)toView;

@end

@implementation UNMViewFx

+ (UNMViewFxVerticalSliderFromTo*)createPageTransition:(UNMPageTransitionType)UNMPageTransitionSliding
				 fromView:(UIView*)fromView
				   toView:(UIView*)toView
					 edge:(UNMPageTransitionEdge)edge {
	
	UNMViewFxVerticalSliderFromTo* const viewFx = [[UNMViewFxVerticalSliderFromTo alloc] initWithFromView:fromView
																								   toView:toView];
	
	objc_setAssociatedObject(fromView, @selector(createPageTransition:fromView:toView:edge:),
							 viewFx, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	
	return viewFx;
}

/*
- (instancetype) init {
	
	self = [super init];
	
	if (self) {
		
		
	}
	
	return self;
}
 */

@end

@interface UNMViewFxVerticalSlider : NSObject

@property (strong, nonatomic) UIPanGestureRecognizer* gestureRecognizer;

- (instancetype) initWithView:(UIView*)view
					direction:(UISwipeGestureRecognizerDirection)direction
					frontView:(UIView*)frontView;

@end

@interface UNMViewFxVerticalSliderFromTo()

@property (strong, nonatomic) UNMViewFxVerticalSlider* fromSlider;
@property (strong, nonatomic) UNMViewFxVerticalSlider* toSlider;

@end

@implementation UNMViewFxVerticalSlider {
	
	UIView* _frontView;
	BOOL _moveHasBegun;
	CGRect _initFrame;
	CGRect _currentFrame;
	CFTimeInterval _moveBeganAt;
	CGFloat _offsetY; // used if the swipe has gone outside the screen
	CGFloat _lastTranslationY; // "translation" is given by gestureRecognizer
	CGFloat _moveOriginY; // but "move" depends on the current direction
	UISwipeGestureRecognizerDirection _expectedDirection;
	UISwipeGestureRecognizerDirection _currentDirection;
	BOOL _shouldCompleteMove;
	
	BOOL _allowGesture;
	BOOL _currentlyScrolling;
}

- (instancetype) initWithView:(UIView*)view
					direction:(UISwipeGestureRecognizerDirection)direction
					frontView:(UIView *)frontView {
	
	self = [super init];
	
	if (self) {
		
		_expectedDirection = direction;
		_frontView = frontView;
		
		self.gestureRecognizer = [[UIPanGestureRecognizer alloc]
										 initWithTarget:self
										 action:@selector(handleGestureRecognizer:)];
		
		// panGestureRecognizer.minimumNumberOfTouches = 1;
		// panGestureRecognizer.maximumNumberOfTouches = UINT_MAX;
		
		[view addGestureRecognizer:self.gestureRecognizer];

		_moveHasBegun = NO;
		
		_allowGesture = YES;
		_currentlyScrolling = NO;
	}
	
	return self;
}

- (void) handleGestureRecognizer:(UIPanGestureRecognizer*)gestureRecognizer {
	
	const CGFloat translationY = [gestureRecognizer translationInView:gestureRecognizer.view.superview].y;
	
	if (_currentlyScrolling) _allowGesture = NO;
	
	switch (gestureRecognizer.state) {
			
		case UIGestureRecognizerStateBegan:
			if (!_allowGesture) {
				if (_currentlyScrolling) return; // cancel
				_allowGesture = YES; // reallow
			}

			_moveBeganAt = CACurrentMediaTime();
			_moveHasBegun = NO;
			_shouldCompleteMove = NO;
			_offsetY = 0.0;
			_moveOriginY = _lastTranslationY = 0.0;
			_currentFrame = _initFrame = _frontView.frame;
			break;
			
		case UIGestureRecognizerStateChanged:
			if (!_allowGesture) return; // cancel
			
			const CGFloat total = gestureRecognizer.view.frame.size.height / 4; // scroll out if > 1/4 of the screen
			
			const CGFloat fraction = fmaxf(-1.0, fminf(1.0, (translationY - _moveOriginY) / total));
			
			if (!_moveHasBegun && fabsf(fraction) > 0.5) {
				_moveBeganAt = CACurrentMediaTime();
				_moveOriginY = translationY;
				_offsetY = translationY;
				_lastTranslationY = translationY;
				_currentDirection = (translationY > _moveOriginY)
				? UISwipeGestureRecognizerDirectionDown
				: UISwipeGestureRecognizerDirectionUp;
				_moveHasBegun = YES;
			}
			
			if (!_moveHasBegun) return;
			
			if (translationY >= _lastTranslationY) {
				if (_currentDirection == UISwipeGestureRecognizerDirectionUp) {
					// change direction
					_moveBeganAt = CACurrentMediaTime();
					_currentDirection = UISwipeGestureRecognizerDirectionDown;
					_moveOriginY = _lastTranslationY;
				}
				
			} else {
				if (_currentDirection == UISwipeGestureRecognizerDirectionDown) {
					// change direction
					_moveBeganAt = CACurrentMediaTime();
					_currentDirection = UISwipeGestureRecognizerDirectionUp;
					_moveOriginY = _lastTranslationY  - _offsetY;
				}
			}
			
			_lastTranslationY = translationY;
			
			if (_initFrame.origin.y + translationY < _offsetY) {
			
				_offsetY = _initFrame.origin.y + translationY;
			}
			
			if (_currentDirection != _expectedDirection) {
				_shouldCompleteMove = NO;
			} else if (fabsf(fraction) >= 1.0) {
				_shouldCompleteMove = YES;
			}
			
			const CGFloat offsetY = fmaxf(-_initFrame.origin.y, // do not scroll outside the screen
										  translationY - _offsetY);
			
			_currentFrame = CGRectOffset(_initFrame, 0, offsetY);
			
			_frontView.frame = _currentFrame;
			
			[_frontView setNeedsDisplay];
			
			break;

		case UIGestureRecognizerStateCancelled:
		case UIGestureRecognizerStateEnded:
			if (!_allowGesture) {
				if (!_currentlyScrolling) _allowGesture = YES; // reallow
				return;
			}
			
			[self setCurrentlyScrolling];
			
			const CFTimeInterval now = CACurrentMediaTime();
			
			const CFTimeInterval elapsed = now - _moveBeganAt;
			
			const CGFloat frameHeight = _frontView.frame.size.height;
			
			if (_expectedDirection == UISwipeGestureRecognizerDirectionUp) _shouldCompleteMove = !_shouldCompleteMove;
			
			if (!_shouldCompleteMove) {
				
				// If the entire view height should be scrolled independently, it should last a maximum of 3.0 sec.
				const CGFloat durationWithoutSpeed = 3.0f * ((translationY - _offsetY) / frameHeight);
				
				// What speed gave the user?
				const CGFloat speed = (_currentDirection != UISwipeGestureRecognizerDirectionUp
									   || translationY - _offsetY >= _moveOriginY)
				? 3.0 / frameHeight // default
				: elapsed / (_moveOriginY - translationY + _offsetY);
				
				const CGFloat durationWithSpeed = speed * fmaxf(0.0, translationY - _offsetY);
				
				[self scrollBackView:_frontView duration:fminf(durationWithoutSpeed, durationWithSpeed)];
				
			} else {
				
				// If the entire view height should be scrolled independently, it should last a maximum of 3.0 sec.
				const CGFloat durationWithoutSpeed = 3.0f * ((frameHeight - translationY + _offsetY) / frameHeight);
				
				// What speed gave the user?
				const CGFloat speed = (_currentDirection != UISwipeGestureRecognizerDirectionDown
									   || translationY - _offsetY <= _moveOriginY)
				? 3.0 / frameHeight // default
				: elapsed / (translationY - _offsetY - _moveOriginY);
				
				const CGFloat durationWithSpeed = speed * fmaxf(0.0,
																_expectedDirection == UISwipeGestureRecognizerDirectionDown
																? translationY - _offsetY
																: -(translationY - _offsetY));
				
				[self scrollOutView:_frontView duration:fminf(durationWithoutSpeed, durationWithSpeed)];
			}
			
			break;
			
		default:
			break;
	}
}

- (void) scrollBackView:(UIView*)view duration:(NSTimeInterval)duration {
	
	_currentlyScrolling = YES;
	_allowGesture = NO; // Note: Set _allowGesture = NO after _currentScrolling = YES

	const CGRect bounds = view.superview.frame;
	
	[UIView animateWithDuration:fminf(1.0, duration) animations:^{
		
		view.frame = bounds;
		
	} completion:^(BOOL finished) {
		
		view.frame = bounds;
		
		_currentlyScrolling = NO;
	}];
}

- (void) scrollOutView:(UIView*)view duration:(NSTimeInterval)duration {
	
	[self setCurrentlyScrolling];

	const CGRect bounds = CGRectOffset(view.superview.frame, 0, view.superview.frame.size.height);
	
	[UIView animateWithDuration:fminf(1.0, duration) animations:^{
		
		view.frame = bounds;
		
	} completion:^(BOOL finished) {
		
		view.frame = bounds;
		
		_currentlyScrolling = NO;
	}];
}

- (void) setCurrentlyScrolling {
	
	_currentlyScrolling = YES;
	_allowGesture = NO; // Note: Set _allowGesture = NO after _currentScrolling = YES
}

- (void) scrollBackViewWithDuration:(NSTimeInterval)duration {
	
	[self scrollBackView:self.gestureRecognizer.view duration:duration];
}

- (void) scrollOutViewWithDuration:(NSTimeInterval)duration {
	
	[self scrollOutView:self.gestureRecognizer.view duration:duration];
}

@end

@implementation UNMViewFxVerticalSliderFromTo

- (instancetype) initWithFromView:(UIView*)fromView toView:(UIView*)toView {
	
	self = [super init];
	
	if (self) {
		
		self.fromSlider = [[UNMViewFxVerticalSlider alloc] initWithView:fromView
															  direction:UISwipeGestureRecognizerDirectionDown
															  frontView:fromView];
		
		self.toSlider = [[UNMViewFxVerticalSlider alloc] initWithView:toView
															direction:UISwipeGestureRecognizerDirectionUp
															frontView:fromView];
	}
	
	return self;
}

- (void) scrollBackFrontView {
	
	[self.fromSlider scrollBackViewWithDuration:1.0f];
}

- (void) scrollOutFrontView {
	
	[self.fromSlider scrollOutViewWithDuration:1.0f];
}


@end