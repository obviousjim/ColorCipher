/**
 *  CodeBreaker Beta
 *  This is a simple remake of the MasterMind game from the 1970's
 *  Author: James George
 *  Cocoa Camp Application Competetion entry
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
