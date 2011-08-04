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

#import "MainViewController.h"
#import "CBPegView.h"
#import "CBEvaluationView.h"
#import "CBTouchResponderView.h"
#import "CBGameConstants.h"
#import "ColorCipherAppDelegate.h"
#import "RootViewController.h"
#import "CBEvaluationModel.h"
#import "CBStatisticsModel.h"
#import "CBGameModel.h"
#import "CBEvaluationModel.h"
#import "CBGameEndAlert.h"
#import "CBIntroViewController.h"

//pixel spacing
#define TOP_OFFSET 124.
#define X_SPACER 20.
#define Y_SPACER 8.
#define ROW_WIDTH 210.
#define OK_OFFSET 128.
#define SOLUTION_TOP 40.

@interface MainViewController (Private)
- (void) evaluateGuess:(NSArray*)guess;
- (void) releaseIntro;
- (void) initInterface;
@end

@implementation MainViewController
@synthesize game;
@synthesize rows;
@synthesize evaluations;
@synthesize solutionRow;
@synthesize touchResponders;
@synthesize okButton;
@synthesize newGameButton;
@synthesize cover;
@synthesize revealer;
@synthesize alertPanel;
@synthesize doubletapHint;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.game = ((ColorCipherAppDelegate*)[UIApplication sharedApplication].delegate).game;
	}
	return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) loadView
{
	[super loadView];
	//self.game = ((ColorCipherAppDelegate*)[UIApplication sharedApplication].delegate).game;
	((ColorCipherAppDelegate*)[UIApplication sharedApplication].delegate).gameInProgress = YES;
	self.rows = [NSMutableArray array];
	self.evaluations = [NSMutableArray array];
	self.touchResponders = [NSMutableArray array];
	
	NSInteger col, row;
	for(row = 0; row < NUM_ROWS; row++){
		UIImageView* pegRow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar.png"]];
		[self.rows insertObject:pegRow atIndex:0];
		[self.view addSubview:pegRow];
		pegRow.center = CGPointMake(self.view.center.x, TOP_OFFSET + row*(PEG_HEIGHT + Y_SPACER));
		pegRow.alpha = .25;
		for(col = 0; col < NUM_COLUMNS; col++){
			CBPegView* pegView = [[CBPegView alloc] init];
			pegView.center = CGPointMake(5 + PEG_WIDTH/2. + PEG_WIDTH*col, PEG_HEIGHT/2. + 2.5);
			[pegRow addSubview:pegView];
			[pegView release];
		}
		[pegRow release];		
	}
	
	//add touch panels
	for(col = 0; col < NUM_COLUMNS; col++){
		CGRect frame = CGRectMake(self.view.center.x + ((col-2) *PEG_WIDTH), TOP_OFFSET-20, PEG_WIDTH, (PEG_HEIGHT+Y_SPACER)*NUM_ROWS+10);
		CBTouchResponderView* responder = [[CBTouchResponderView alloc] initWithFrame:frame]; 
		[self.touchResponders addObject: responder];
		[self.view addSubview:responder];
		[responder release];
	}
	
	//insert solution
	self.solutionRow = [[UIImageView alloc] initWithImage:nil];
	self.solutionRow.center = CGPointMake(self.view.center.x, SOLUTION_TOP);
	for(col = 0; col < NUM_COLUMNS; col++){
		CBPegView* pegView = [[CBPegView alloc] init];
		[pegView activate];
		pegView.center = CGPointMake((2-col)*PEG_WIDTH-PEG_WIDTH/2, 0);
		[self.solutionRow addSubview:pegView];
		[pegView release];
	}
	[self.view insertSubview:self.solutionRow belowSubview:self.cover];
	[self.solutionRow release];	
	
	self.doubletapHint = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 10)];
	self.doubletapHint.text = @"double tap";
	self.doubletapHint.font = [UIFont systemFontOfSize:9.];
	self.doubletapHint.textColor = [UIColor whiteColor];
	self.doubletapHint.alpha = 0;
	self.doubletapHint.backgroundColor = [UIColor clearColor];
	[self.view insertSubview:self.doubletapHint aboveSubview:self.okButton];

}

- (void) viewDidLoad
{
	self.revealer.delegate = self;
	self.newGameButton.alpha = 0;
	self.cover.transform = CGAffineTransformMakeTranslation(0, -self.cover.frame.size.height);
	
	[self initInterface];
	[UIView setAnimationsEnabled: NO];
	[self activateRow];
	[UIView setAnimationsEnabled: YES];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if(![defaults boolForKey:KEY_NOT_FIRST_RUN]){
		[defaults setBool:YES forKey:KEY_NOT_FIRST_RUN];
		introController = [[[CBIntroViewController alloc] initWithNibName:@"Intro" bundle:nil] retain];
		introController.mainView = self;
		introController.view.alpha = 0;
		ColorCipherAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
		[self.view addSubview:introController.view];
		[self.view bringSubviewToFront:introController.view];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.];
		
		introController.view.alpha = 1;
		appDelegate.rootViewController.infoButton.alpha = 0;
		
		[UIView commitAnimations];
	}
	[self restoreFromHistory];
	
}

- (void) disposeIntro
{
	ColorCipherAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(releaseIntro)];
	
	introController.view.alpha = 0;
	appDelegate.rootViewController.infoButton.alpha = 1;
	
	[UIView commitAnimations];
}

- (void) releaseIntro
{
	[introController.view removeFromSuperview];
	[introController release];
}

- (void) initInterface
{
	for(UIImageView* row in self.rows){
		if(row != [self.rows objectAtIndex:0]){
			row.alpha = .25;
			for(CBPegView* peg in row.subviews){
				[peg deactivate];
			}		
		}
	}
	self.cover.alpha = 1;
	self.cover.transform = CGAffineTransformIdentity;
	self.okButton.alpha = 1;
	self.revealer.alpha = 1;
	[self.revealer resetThumb];
	self.newGameButton.alpha = 0;	
}

- (IBAction) newGame 
{
	[self.alertPanel fadeOut];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
	
	[self initInterface];
	
	[UIView commitAnimations];
	
	for(CBEvaluationView* view in self.evaluations){
		[view removeFromSuperview];
	}
	self.evaluations = [NSMutableArray array];	
	NSUInteger i = 0;
	for(CBPegView* peg in self.solutionRow.subviews){
		[peg spin:(i++%2==0)];
	}
	[self.game initGame];
	[self activateRow];
}

- (void) restoreFromHistory
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray* history = [defaults arrayForKey:KEY_GUESS_HISTORY];	
	if(history == nil){
		return;
	}
	CBGameStatus status = [defaults integerForKey:KEY_CURRENT_STATUS];
	BOOL recordStatsPref = self.game.stats.recordStats;
	self.game.stats.recordStats = NO;
	[UIView setAnimationsEnabled: NO];
	
	//relive the past
	for(NSArray* guess in history){
		for(int col = 0; col < 4; col++){
			UIImageView* row = [self.rows objectAtIndex: game.currentRow];
			[[row.subviews objectAtIndex: col] showSingleColor:[[guess objectAtIndex:col] intValue]];
		}
		[self evaluateGuess:guess];
	}	
	if(status == CBGameStatusForfeit){
		[self revealSolution];
	}
	if(status == CBGameStatusPlaying || status ==  CBGameStatusForfeit){
		self.currentGuess = [defaults arrayForKey:KEY_GUESS_CURRENT];
	}
	[UIView setAnimationsEnabled: YES];
	self.game.stats.recordStats = recordStatsPref;
}

- (void) setCurrentGuess:(NSArray*)guess
{
	if(self.game.status == CBGameStatusPlaying){
		UIView* pegRow = [self.rows objectAtIndex: game.currentRow];
		for(NSUInteger i = 0; i < NUM_COLUMNS; i++){\
			CBPegView* peg = [pegRow.subviews objectAtIndex:i];
			[peg showSingleColor: [[guess objectAtIndex:i] intValue] animate:YES];
		}
	}
}

- (NSArray*) currentGuess
{
	//gather the guess
	UIImageView* row = [self.rows objectAtIndex: game.currentRow];
	NSMutableArray* guess = [NSMutableArray array];
	for(NSUInteger i = 0; i < row.subviews.count; i++){
		CBPegView* peg = [row.subviews objectAtIndex:i];
		[guess addObject:[NSNumber numberWithInt:peg.color]];
	}
	return guess;
}

- (void) saveCurrentGuess
{
	if(self.game.status == CBGameStatusPlaying || self.game.status == CBGameStatusForfeit){
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSArray* currentGuess = [self currentGuess];
		[defaults setObject:currentGuess forKey:KEY_GUESS_CURRENT];
	}
}

- (void) sliderDidComplete:(CBRevealSliderView*)slider
{
	[self.game forfeit];
	[self.alertPanel displayWithStats:self.game.stats andStatus:self.game.status];
	[self revealSolution];
}

- (IBAction) singleTouchOK
{
	[self performSelector:@selector(hintDoubleTap) withObject:nil afterDelay:.75];
}

- (void) hintDoubleTap
{
	self.doubletapHint.center = CGPointMake(self.okButton.center.x, self.okButton.center.y - self.doubletapHint.frame.size.height/2);
	self.doubletapHint.alpha = 1;
	self.doubletapHint.transform = CGAffineTransformIdentity;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	
	self.doubletapHint.alpha = 0;
	self.doubletapHint.transform = CGAffineTransformMakeTranslation(0, -30);
	
	[UIView commitAnimations];
}

- (IBAction) confirmGuess
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];	
	[self evaluateGuess:self.currentGuess];
}

- (void) evaluateGuess:(NSArray*)guess
{
	CBEvaluationModel* result = [game confirmGuess:guess];
	CBEvaluationView* evalDisplay = [[CBEvaluationView alloc] initWithEvaluation:result];
	evalDisplay.mainView = self;
	[evaluations addObject:evalDisplay];
	evalDisplay.center = CGPointMake(self.okButton.center.x, self.okButton.center.y); 
	[self.view insertSubview:evalDisplay belowSubview:self.okButton];
	[evalDisplay release];	
	if(game.status == CBGameStatusWin || game.status == CBGameStatusLoss){
		[self revealSolution];
		[self.alertPanel displayWithStats:self.game.stats andStatus:self.game.status];
	}
	else{
		[self activateRow];
	}			
}

- (void) activateRow
{
	UIImageView* pegRow = [self.rows objectAtIndex: game.currentRow];
	for(NSUInteger i = 0; i < NUM_COLUMNS; i++){
		CBPegView* peg = [pegRow.subviews objectAtIndex:i];
		CBTouchResponderView* responder = [self.touchResponders objectAtIndex:i];
		responder.currentPegTarget = peg;
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:.25];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseOut];	
	for(CBPegView* peg in pegRow.subviews){
		[peg activate];
	}
	self.okButton.center = CGPointMake(self.view.center.x + OK_OFFSET, TOP_OFFSET + (NUM_ROWS - game.currentRow - 1)*(PEG_HEIGHT + Y_SPACER));
	self.okButton.alpha = 1.0;
	pegRow.alpha = 1.0;	
	[UIView commitAnimations];
}

#define DURATION_REVEAL 1
#define DURATION_ALERT_FADE 1
#define DURATION_ALERT_SHOW 2
- (void) revealSolution
{
	NSArray* solution = game.solution;
	for(NSInteger i = 0; i < self.solutionRow.subviews.count; i++){
		CBPegView* peg = [self.solutionRow.subviews objectAtIndex:3-i];
		[peg showSingleColor: [[solution objectAtIndex: i] intValue]];
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:DURATION_REVEAL];
	
	self.okButton.alpha = 0;
	self.cover.alpha = 0;
	self.cover.transform = CGAffineTransformMakeTranslation(0, -self.cover.frame.size.height);
	self.solutionRow.hidden = NO;
	self.newGameButton.alpha = 1;
	self.revealer.alpha = 0;

	[UIView commitAnimations];
	
	for(CBTouchResponderView* responder in self.touchResponders){
		responder.currentPegTarget = nil;
	}
}

- (void)didReceiveMemoryWarning 
{
	if(!self.view.superview){
		NSLog(@"memory state received");
		//emergency store state
		[self saveCurrentGuess];
		[self.game saveGameState];
		[self.game reset];
		
		// Release anything that's not essential, such as cached data
		self.rows = nil;
		self.solutionRow = nil;
		self.touchResponders = nil;

		((ColorCipherAppDelegate*)[UIApplication sharedApplication].delegate).gameInProgress = NO;
	}
	[super didReceiveMemoryWarning]; //Releases the view if it doesn't have a superview	
}

- (void)dealloc 
{
	[solutionRow release];
	[rows release];
	[evaluations release];
	[touchResponders release];

	[cover release];
	[okButton release];
	[newGameButton release];
	[revealer release];

	[alertPanel release];	
	[doubletapHint release];
	
	[super dealloc];
}

@end
