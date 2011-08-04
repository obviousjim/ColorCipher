//
//  CBGameEndAlert.m
//  ColorCipher
//
//  Created by Jim on 2/14/09.
//  Copyright 2009 University of Washington. All rights reserved.
//

#import "CBGameEndAlert.h"
#import "CBStatisticsModel.h"

#define ANIMATION_ID_PANEL_SHOW @"ANIMATION_ID_PANEL_SHOW"
#define ANIMATION_ID_PANEL_HIDE @"ANIMATION_ID_PANEL_HIDE"
#define ANIMATION_ID_RESULTS_HIDE @"ANIMATION_ID_RESULTS_HIDE"
#define ANIMATION_ID_PERCENT_SHOW @"ANIMATION_ID_PERCENT_SHOW"
#define ANIMATION_ID_PERCENT_HIDE @"ANIMATION_ID_PERCENT_HIDE"
#define ANIMATION_ID_AVERAGE_SHOW @"ANIMATION_ID_AVERAGE_SHOW"
#define ANIMATION_ID_AVERAGE_HIDE @"ANIMATION_ID_AVERAGE_HIDE"

#define DURATION_FADE_PANEL 1.
#define DURATION_SHOW_PANEL 1.
#define DURATION_FADE_TEXT .5
#define DURATION_SHOW_TEXT 1.
#define DURATION_INITIAL_DELAY 1.

#define LABEL_TOP_PERCENTAGE @"You've now won"
#define LABEL_BOTTOM_PERCENTAGE @"of all games"
#define LABEL_TOP_AVERAGE @"You now take an average"
#define LABEL_BOTTOM_AVERAGE @"guesses to win"
#define LABEL_WIN @"You Win!"
#define LABEL_LOSE @"No More Guesses..."
#define LABEL_FORFEIT @"You Gave Up..."

@interface CBGameEndAlert (Private)
- (void) animationDidStop:(NSString*)animationID;
@end


@implementation CBGameEndAlert
@synthesize statsText;
@synthesize smallTextAbove;
@synthesize smallTextBelow;

- (void) displayWithStats:(CBStatisticsModel*)gameStats andStatus:(CBGameStatus)gameStatus;
{
	stats = gameStats;
	status = gameStatus;
	[self.superview bringSubviewToFront:self];
	self.statsText.font = [UIFont systemFontOfSize:48.];
	if(status == CBGameStatusWin){
		self.statsText.text = LABEL_WIN;
	}
	else if(status == CBGameStatusForfeit){
		self.statsText.text = LABEL_FORFEIT;			
	}
	else{
		self.statsText.text = LABEL_LOSE;		
	}
		
	self.smallTextAbove.alpha = self.smallTextBelow.alpha = 0;

	[UIView beginAnimations:ANIMATION_ID_PANEL_SHOW context:nil];
	[UIView setAnimationDuration:DURATION_FADE_PANEL];
	[UIView setAnimationDelay:DURATION_INITIAL_DELAY];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:)];
	self.alpha = 1;
	[UIView commitAnimations];
}

- (void) animationDidStop:(NSString*)animationID
{
	if([animationID isEqual:ANIMATION_ID_PANEL_SHOW]){
		if(stats.recordStats){
			[UIView beginAnimations:ANIMATION_ID_RESULTS_HIDE context:nil];
			[UIView setAnimationDelay:DURATION_SHOW_TEXT];
			[UIView setAnimationDuration:DURATION_FADE_TEXT];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(animationDidStop:)];			

			self.statsText.alpha = 0;
			
			[UIView commitAnimations];
		}
		else{
			[UIView beginAnimations:ANIMATION_ID_PANEL_HIDE context:nil];
			[UIView setAnimationDelay:DURATION_SHOW_PANEL];
			[UIView setAnimationDuration:DURATION_FADE_PANEL];
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(animationDidStop:)];			
			
			self.alpha = 0;
			
			[UIView commitAnimations];	
		}
	}
	else if([animationID isEqual:ANIMATION_ID_RESULTS_HIDE]){
		self.smallTextAbove.text = LABEL_TOP_PERCENTAGE;
		self.smallTextBelow.text = LABEL_BOTTOM_PERCENTAGE;
		self.statsText.text = [NSString stringWithFormat:@"%.1f%%", 100*stats.percentWon];
		
		[UIView beginAnimations:ANIMATION_ID_PERCENT_SHOW context:nil];
		[UIView setAnimationDuration:DURATION_FADE_TEXT];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:)];			
		
		self.smallTextAbove.alpha = self.smallTextBelow.alpha = self.statsText.alpha = 1;		
		
		[UIView commitAnimations];			
	}
	else if([animationID isEqual:ANIMATION_ID_PERCENT_SHOW] && status == CBGameStatusWin){
		[UIView beginAnimations:ANIMATION_ID_PERCENT_HIDE context:nil];
		[UIView setAnimationDuration:DURATION_FADE_TEXT];
		[UIView setAnimationDelay:DURATION_SHOW_TEXT];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:)];			
		
		self.smallTextAbove.alpha = self.smallTextBelow.alpha = self.statsText.alpha = 0;
		
		[UIView commitAnimations];					
	}
	else if([animationID isEqual:ANIMATION_ID_PERCENT_HIDE]){
		self.smallTextAbove.text = LABEL_TOP_AVERAGE;
		self.smallTextBelow.text = LABEL_BOTTOM_AVERAGE;
		self.statsText.text = [NSString stringWithFormat:@"%.2f", stats.averageGuessesToWin];
		
		[UIView beginAnimations:ANIMATION_ID_AVERAGE_SHOW context:nil];
		[UIView setAnimationDuration:DURATION_FADE_TEXT];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:)];			
		
		self.smallTextAbove.alpha = self.smallTextBelow.alpha = self.statsText.alpha = 1;
		
		[UIView commitAnimations];					
	}
	else if([animationID isEqual:ANIMATION_ID_AVERAGE_SHOW] || ([animationID isEqual:ANIMATION_ID_PERCENT_SHOW] && status != CBGameStatusWin) ){
		[UIView beginAnimations:ANIMATION_ID_PANEL_HIDE context:nil];
		[UIView setAnimationDelay:DURATION_SHOW_TEXT];
		[UIView setAnimationDuration:DURATION_FADE_PANEL];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:)];			
		
		self.alpha = 0;
		
		[UIView commitAnimations];	
	}
	else if([animationID isEqual:ANIMATION_ID_PANEL_HIDE]){
		[self.superview sendSubviewToBack:self];
	}
}

- (void) fadeOut
{
	[UIView beginAnimations:ANIMATION_ID_PANEL_HIDE context:nil];
	[UIView setAnimationDuration:DURATION_FADE_PANEL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:)];			
	
	self.alpha = 0;
	
	[UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self fadeOut];
}


- (void) dealloc
{
	[statsText release];
	[smallTextAbove release];
	[smallTextBelow release];
	[super dealloc];
}
@end
