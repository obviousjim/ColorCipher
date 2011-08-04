//
//  CBStatisticsModel.m
//  ColorCipher
//
//  Created by James George on 2/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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
