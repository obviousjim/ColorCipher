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

#import "CBStatisticsModel.h"
#import "CBGameConstants.h"

@implementation CBStatisticsModel
@synthesize totalWins, totalLosses, totalForfeit;
@synthesize recordStats;

-(id) init
{
	if(self = [super init]){
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		totalWins		= [defaults integerForKey:STAT_NUM_WINS];	
		totalLosses		= [defaults integerForKey:STAT_NUM_LOSS];
		totalForfeit	= [defaults integerForKey:STAT_NUM_FORFEIT];
		totalGuesses	= [defaults integerForKey:STAT_NUM_GUESSES];
		recordStats		= [defaults boolForKey:PREF_RECORD_STATS] || ![defaults boolForKey:DEFAULT_SAVE_STATS_ON];
	}
	return self;
}

- (void) tallyForfeit
{
	if(!recordStats) return;
	totalForfeit++;
}

- (void) tallyWin:(NSUInteger)numGuesses;
{
	if(!recordStats) return;
	totalWins++;
	totalGuesses += numGuesses;
}

- (void) tallyLoss;
{
	if(!recordStats) return;
	totalLosses++;
}

- (float) percentWon
{
	NSInteger totalGames = totalWins+totalLosses+totalForfeit;
	return (totalGames == 0) ? 0.0 : 1.0*totalWins/totalGames;
}

- (float) averageGuessesToWin
{	
	return (totalWins == 0) ? 0.0 : 1.0*totalGuesses/totalWins;
}

- (void) saveStatistics
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:totalWins forKey:STAT_NUM_WINS];	
	[defaults setInteger:totalLosses forKey:STAT_NUM_LOSS];
	[defaults setInteger:totalForfeit forKey:STAT_NUM_FORFEIT];
	[defaults setInteger:totalGuesses forKey:STAT_NUM_GUESSES];
	[defaults setBool:recordStats forKey:PREF_RECORD_STATS];
	[defaults setBool:YES forKey:DEFAULT_SAVE_STATS_ON];	
}

- (void) clearStatistics
{
	totalWins = totalLosses = totalForfeit = totalGuesses = 0;
}

@end
