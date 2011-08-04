/*
 *  ColorCipher
 *
 * by James George
 * Copyright (C) 2008-2011
 *
 **********************************************************
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 *
 * ----------------------
 *
 * ColorCipher is a version of the popular game MasterMind for the iPhone
 */

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
