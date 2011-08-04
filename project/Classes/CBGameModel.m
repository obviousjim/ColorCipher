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

#import "CBGameModel.h"
#import "CBGameConstants.h"
#import "CBEvaluationModel.h"
#import "CBStatisticsModel.h"

@implementation CBGameModel

@synthesize status;
@synthesize currentRow;
@synthesize solution;
@synthesize history;
@synthesize stats;

- (id) init
{
	if(self = [super init]){
		currentRow = 0;
		status = CBGameStatusPlaying;
		self.stats = [[CBStatisticsModel alloc] init];
		srand([[NSDate date] timeIntervalSince1970]);		
		self.history = [NSMutableArray array];
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		self.solution = [defaults arrayForKey:KEY_SOLUTION];
		if(self.solution == nil){
			[self initGame];
		}
	}
	return self;
}

- (void) saveGameState
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:self.history forKey:KEY_GUESS_HISTORY];
	[defaults setObject:self.solution forKey:KEY_SOLUTION];
	[defaults setInteger:self.status forKey:KEY_CURRENT_STATUS];
	[self.stats saveStatistics];
}

- (void) initGame
{
	[self reset];

	if(self.solution != nil){
		self.solution = nil;
	}
	self.solution = [NSArray arrayWithObjects:
			[NSNumber numberWithInt:(NSUInteger)floor( (rand()%NUM_COLORS) )],
			[NSNumber numberWithInt:(NSUInteger)floor( (rand()%NUM_COLORS) )],
			[NSNumber numberWithInt:(NSUInteger)floor( (rand()%NUM_COLORS) )],
			[NSNumber numberWithInt:(NSUInteger)floor( (rand()%NUM_COLORS) )],
		nil];
}

- (void) reset
{
	[self.history removeAllObjects];
	currentRow = 0;
	status = CBGameStatusPlaying;
}

- (CBEvaluationModel*) confirmGuess:(NSArray*)guess
{
	currentRow++;
	CBEvaluationModel* eval = [CBEvaluationModel evaluationForGuess:guess andSolution:self.solution];
	if(eval.red == 4){
		status = CBGameStatusWin;
		[self.stats tallyWin:currentRow];
	}
	else if(currentRow == 10){
		status = CBGameStatusLoss;
		[self.stats tallyLoss];
	}
	[self.history addObject:guess];
	return eval;
}

- (void) forfeit
{
	if(self.status == CBGameStatusPlaying){
		[self.stats tallyForfeit];
		status = CBGameStatusForfeit;
	}
}

- (void) dealloc
{
	[solution release];
	[stats release];
	[history release];
	[super dealloc];
}

@end
