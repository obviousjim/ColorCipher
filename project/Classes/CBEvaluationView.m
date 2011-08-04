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

#import "CBEvaluationView.h"
#import "CBEvaluationModel.h"
#import "MainViewController.h"

#define QUADRANT_SIZE 12.

@interface CBEvaluationView (Private)
- (void) addPegForColor:(NSString*)color quadrant:(NSUInteger)quadrant;
- (CGPoint) centerPointForQuadrant:(NSUInteger)quadrant;
@end


@implementation CBEvaluationView
@synthesize mainView;

-(id) initWithEvaluation:(CBEvaluationModel*) evaluation
{
	if(self = [super initWithImage:[UIImage imageNamed:@"eval_grid.png"]]){
		NSUInteger quadrant = 0;
		int i;
		for(i = 0; i < evaluation.red; i++){
			[self addPegForColor:@"red"   quadrant:quadrant++];
		}
		for(i = 0; i < evaluation.white; i++){
			[self addPegForColor:@"white" quadrant:quadrant++];
		}
		guess = [evaluation.guess retain];
		self.userInteractionEnabled = YES;
	}
	return self;
}

- (void) addPegForColor:(NSString*)color quadrant:(NSUInteger)quadrant
{	
	UIImage* pegImage = [UIImage imageNamed:[NSString stringWithFormat:@"eval_%d_%@.png", quadrant, color]];
	UIImageView* peg = [[UIImageView alloc] initWithImage:pegImage];
	peg.center = [self centerPointForQuadrant:quadrant];
	[self addSubview:peg];
	[peg release];
}

- (CGPoint) centerPointForQuadrant:(NSUInteger)quadrant
{
	 switch (quadrant) {
		 case 0:
			 return CGPointMake(QUADRANT_SIZE/2, QUADRANT_SIZE/2);
		 case 1:
			 return CGPointMake(QUADRANT_SIZE + 1 + QUADRANT_SIZE/2, QUADRANT_SIZE/2);
		 case 2:
			 return CGPointMake(QUADRANT_SIZE/2, QUADRANT_SIZE + 1 + QUADRANT_SIZE/2);
		 default:
			 return CGPointMake(QUADRANT_SIZE + 1 +QUADRANT_SIZE/2, QUADRANT_SIZE + 1 + QUADRANT_SIZE/2);
	 }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	self.mainView.currentGuess = guess;
}

- (void)dealloc
{
	[guess release];
	[super dealloc];
}

@end
