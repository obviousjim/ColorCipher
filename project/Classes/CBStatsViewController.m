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
