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

#import "CBPegView.h"
#import "CBGameConstants.h"

#define COLOR_BAR_HEIGHT NUM_COLORS*PEG_HEIGHT
#define DURATION_SPIN .15

@interface CBPegView (Private)
+ (CGFloat) offsetForColor:(NSUInteger)color;
+ (NSUInteger)colorForOffset:(CGFloat)offsetForColor;
@end


@implementation CBPegView
@synthesize colors, padding, color;

-(id) init
{
	if(self = [super initWithImage: [UIImage imageNamed:@"c6.png"]]){
		self.clipsToBounds = YES;
		UIImageView* shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dial_shadow.png"]]; 
		[self addSubview: shadow];
		[shadow release];
		self.colors = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blocks.png"]];
		self.colors.transform = CGAffineTransformIdentity;
		self.padding = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blocks_pad.png"]]; 
		self.padding.transform = CGAffineTransformIdentity;

		[self addSubview:self.colors];
		[self addSubview:self.padding];	
		[self sendSubviewToBack:self.colors];
		[self sendSubviewToBack:self.padding];
		
		self.colors.alpha = 0;
		self.padding.alpha = 0;
		self.frame = CGRectMake(0, 0, PEG_WIDTH, PEG_HEIGHT-1);
	}
	return self;
}

- (void) activate
{
	color = 0;
	self.colors.alpha = 1;
	self.padding.alpha = 1;
	[self displayCurrentColor:NO];
}

- (void) deactivate
{
	color = 0;
	[self displayCurrentColor:NO];
	self.padding.alpha = 0;
	self.colors.alpha = 0;
}
	
- (void) showSingleColor:(NSUInteger)theColor animate:(BOOL)animate
{
	[self moveBy:[CBPegView offsetForColor:theColor] - [CBPegView offsetForColor:self.color] animate:animate duration:DURATION_SPIN*abs(theColor-self.color)];
	[self finishTouches];
	[self displayCurrentColor:animate];	
}

- (void) showSingleColor:(NSUInteger)theColor
{
	[self showSingleColor:theColor animate:NO];
}

- (void) spin:(BOOL)down
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	
	color = down ? NUM_COLORS-1 : 0;
	[self.colors setTransform:(down ? CGAffineTransformIdentity : CGAffineTransformMakeTranslation(0, -COLOR_BAR_HEIGHT+PEG_HEIGHT))];
	[self displayCurrentColor:NO];
	
	[UIView commitAnimations];	
}

- (void) showNextColor
{
	[self moveBy:-PEG_HEIGHT animate:YES];
}

- (void) showPreviousColor
{
	[self moveBy:PEG_HEIGHT animate:YES];
}

- (void) displayCurrentColor:(BOOL)animate
{
	if(animate){
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:DURATION_SPIN];	
	}
	self.colors.transform = CGAffineTransformMakeTranslation(0, [CBPegView offsetForColor:self.color]);
	if(animate){
		[UIView commitAnimations];
	}
}

-(void) finishTouches
{
	if(self.colors.transform.ty > PEG_HEIGHT/2.){
		self.colors.transform = CGAffineTransformMakeTranslation(0, self.colors.transform.ty-COLOR_BAR_HEIGHT);
		self.padding.transform = CGAffineTransformMakeTranslation(0, -PEG_HEIGHT);		
	}
	else if(self.colors.transform.ty < -COLOR_BAR_HEIGHT+PEG_HEIGHT/2.){
		self.colors.transform = CGAffineTransformMakeTranslation(0, self.colors.transform.ty+COLOR_BAR_HEIGHT);
		self.padding.transform = CGAffineTransformIdentity;	
	}
	float position = abs(self.colors.transform.ty) + PEG_HEIGHT/2.;
	color = [CBPegView colorForOffset:position];
	[self displayCurrentColor:YES];

}

- (void) moveBy:(CGFloat)amount animate:(BOOL)animate duration:(NSTimeInterval)duration
{
	if(animate){
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:duration];	
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(finishTouches)];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	}	
	self.colors.transform = CGAffineTransformMakeTranslation(0, self.colors.transform.ty + amount);
	if(self.colors.transform.ty > 0){
		self.padding.transform = CGAffineTransformIdentity;
		if(self.colors.transform.ty > PEG_HEIGHT){
			self.colors.transform = CGAffineTransformMakeTranslation(0, self.colors.transform.ty-COLOR_BAR_HEIGHT);
		}
	}
	else if(self.colors.transform.ty < -COLOR_BAR_HEIGHT+PEG_HEIGHT){
		self.padding.transform = CGAffineTransformMakeTranslation(0, -PEG_HEIGHT);
		if(self.colors.transform.ty < -COLOR_BAR_HEIGHT){
			self.colors.transform = CGAffineTransformIdentity;		
		}
	}
	
	if(animate){
		[UIView commitAnimations];		
	}
}


- (void) moveBy:(CGFloat)amount
{
	[self moveBy:amount animate:NO duration:DURATION_SPIN];
}


- (void) moveBy:(CGFloat)amount animate:(BOOL)animate
{
	[self moveBy:amount animate:animate duration:DURATION_SPIN];
}

+ (CGFloat) offsetForColor:(NSUInteger)color
{
	return -1.*color*PEG_HEIGHT;
}

+ (NSUInteger)colorForOffset:(CGFloat)offset
{
	return ((NSUInteger)offset) / PEG_HEIGHT;
}
- (void)dealloc 
{
	[self.colors release];
	[self.padding release];
	[super dealloc];
}

@end
