/**
 *  CodeBreaker Beta
 *  This is a simple remake of the MasterMind game from the 1970's
 *  Author: James George
 *  Cocoa Camp Application Competetion entry
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
