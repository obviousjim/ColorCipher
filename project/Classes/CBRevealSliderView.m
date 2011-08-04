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

#import "CBRevealSliderView.h"


@implementation CBRevealSliderView
@synthesize thumb;		
@synthesize delegate;
@synthesize text;

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(!slideComplete){
		UITouch* touch = [touches anyObject];
		touchX = [touch locationInView:self.thumb].x;
		if(touchX > 0 && touchX < self.thumb.frame.size.width){
			fingerOn = YES;
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:.35];
			[UIView commitAnimations];
		}
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(fingerOn){
		UITouch* touch = [touches anyObject];
		double currentX = [touch locationInView:self].x - touchX;
		double maxX = self.frame.size.width - self.thumb.frame.size.width;
		if(currentX >= maxX){
			slideComplete = YES;
			currentX = maxX;
		}
		else{
			slideComplete = NO;
		}
		if(currentX < 0){
			currentX = 0;
		}
		CGAffineTransform translation = CGAffineTransformMakeTranslation(currentX , 0);
		self.thumb.transform = translation;
		self.text.transform = translation;
	}
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	fingerOn = NO;
	if(slideComplete){
		if(self.delegate && [self.delegate respondsToSelector:@selector(sliderDidComplete:)]){
			[self.delegate sliderDidComplete:self];
		}
	}
	else{
		[self resetThumb];
	}
	
}

- (void)touchesCanceled:(NSSet *)touches withEvent:(UIEvent *)event 
{
	fingerOn = NO;
	slideComplete = NO;
	[self resetThumb];
}
	
- (void) resetThumb
{
	slideComplete = NO;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration: .15];
	
	self.thumb.transform = CGAffineTransformIdentity;
	self.text.transform = CGAffineTransformIdentity;
	
	[UIView commitAnimations];
}

- (void)setAlpha:(CGFloat)newAlpha
{
	super.alpha = newAlpha;
	self.thumb.alpha = newAlpha;
	self.text.alpha = newAlpha;
}

- (void)dealloc
{
    [super dealloc];
}


@end
