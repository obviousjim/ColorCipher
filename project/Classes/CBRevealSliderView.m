//
//  CBRevealSliderView.m
//  ColorCipher
//
//  Created by Jim on 2/5/09.
//  Copyright 2009 University of Washington. All rights reserved.
//

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
