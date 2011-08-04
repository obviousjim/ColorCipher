//
//  CBStatsViewController.m
//  ColorCipher
//
//  Created by Jim on 2/1/09.
//  Copyright 2009 University of Washington. All rights reserved.
//

#import "CBStatsViewController.h"
#import "ColorCipherAppDelegate.h"
#import "CBGameModel.h"
#import "CBStatisticsModel.h"

@interface CBStatsViewController (Private)
- (void) clearComplete;
@end

#define DURATION_SHOW_PANEL .25
#define DURATION_STAT_FADE .5

#define SCORE_FONT_LARGE 44.0
#define SCORE_FONT_SMALL 28.0

@implementation CBStatsViewController
@synthesize percentWon;
@synthesize averageGuesses;
@synthesize totalWins;
@synthesize totalLosses;
@synthesize totalForfeit;
@synthesize stats;
@synthesize confirmClearView;
@synthesize record;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"Statistics";
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	if(!self.stats){
		self.stats = ((ColorCipherAppDelegate*)[UIApplication sharedApplication].delegate).game.stats;
	}
	percentWon.font = averageGuesses.font = [UIFont systemFontOfSize: SCORE_FONT_LARGE];
	totalWins.font = totalLosses.font = totalForfeit.font = [UIFont systemFontOfSize: SCORE_FONT_SMALL];
	self.record.on = self.stats.recordStats;
	[self updateStatDisplay];
}

- (void) updateStatDisplay
{
	percentWon.text = [NSString stringWithFormat:@"%.1f%%", 100*stats.percentWon];
	averageGuesses.text = [NSString stringWithFormat:@"%.2f", stats.averageGuessesToWin];
	
	totalWins.text = [NSString stringWithFormat:@"%d", stats.totalWins];
	totalLosses.text = [NSString stringWithFormat:@"%d", stats.totalLosses];
	totalForfeit.text = [NSString stringWithFormat:@"%d", stats.totalForfeit];		
}

- (IBAction) toggleKeepStats:(UISwitch*)toggle
{
	self.stats.recordStats = toggle.isOn;
}

- (IBAction) clearStatistics
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:DURATION_SHOW_PANEL];
	[UIView setAnimationDelegate:self];
	
	self.confirmClearView.transform = CGAffineTransformMakeTranslation(0, -self.confirmClearView.frame.size.height);

	[UIView commitAnimations];
}

- (IBAction) reallyClear
{
	[self hideConfirmPanel];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelay:DURATION_SHOW_PANEL];
	[UIView setAnimationDuration:DURATION_STAT_FADE];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(clearComplete)];
	
	[self.stats clearStatistics];
	percentWon.alpha = averageGuesses.alpha = totalWins.alpha = totalLosses.alpha = totalForfeit.alpha = 0;
	
	[UIView commitAnimations];	
}

- (void) clearComplete
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:DURATION_STAT_FADE];
	
	percentWon.alpha = averageGuesses.alpha = totalWins.alpha = totalLosses.alpha = totalForfeit.alpha = 1;
	[self updateStatDisplay];
	
	[UIView commitAnimations];
}

- (IBAction) hideConfirmPanel
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:DURATION_SHOW_PANEL];
	[UIView setAnimationDelegate:self];
	
	self.confirmClearView.transform = CGAffineTransformIdentity;
	
	[UIView commitAnimations];
}


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc 
{
    [super dealloc];
}


@end
