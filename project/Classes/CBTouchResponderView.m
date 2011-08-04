//
//  CBTouchResponderView.m
//  ColorCipher
//
//  Created by Jim on 1/29/09.
//  Copyright 2009 University of Washington. All rights reserved.
//

#import "CBTouchResponderView.h"
#import "CBPegView.h"

#define TAP_TIME_THRESHOLD .35
#define DRAG_THRESHOLD 5

@interface CBTouchResponderView (Private)
- (void) singleTap;
- (void) doubleTap;
@end

@implementation CBTouchResponderView
@synthesize currentPegTarget;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	totalDisplacement = 0;
	[self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(self.currentPegTarget){
		UITouch* touch = [touches anyObject];
		double dist = [touch locationInView:self].y - [touch previousLocationInView:self].y;
		totalDisplacement += abs(dist);
		[self.currentPegTarget moveBy:dist];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(self.currentPegTarget){
		if(totalDisplacement < DRAG_THRESHOLD){
			UITouch* touch = [touches anyObject];
			if(touch.tapCount == 1){
				[self.currentPegTarget performSelector:@selector(showNextColor) withObject:nil afterDelay:TAP_TIME_THRESHOLD];
			} else if(touch.tapCount == 2){
				[NSObject cancelPreviousPerformRequestsWithTarget:self.currentPegTarget selector:@selector(showNextColor) object:nil];
				[self.currentPegTarget performSelector:@selector(showPreviousColor) withObject:nil afterDelay:TAP_TIME_THRESHOLD];
			}
		}
		else{
			[self touchesMoved:touches withEvent:event];
			[self.currentPegTarget finishTouches];
		}
	}
}

- (void)touchesCanceled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event];
}

//- (void) singleTap
//{
//	NSLog(@"calling single tap");
//	if(self.currentPegTarget){
//		[self.currentPegTarget showNextColor];
//	}
//}
//
//- (void) doubleTap
//{
//	if(self.currentPegTarget){
//		[self.currentPegTarget showPreviousColor];
//
//	}		
//}


@end
