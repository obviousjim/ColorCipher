//
//  CBStatisticsModel.h
//  ColorCipher
//
//  Created by James George on 2/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBStatisticsModel : NSObject {
@private
	NSUInteger totalWins;
	NSUInteger totalLosses;
	NSUInteger totalGuesses;
	NSUInteger totalForfeit;
	BOOL recordStats;
}

- (void) tallyForfeit;
- (void) tallyWin:(NSUInteger)numGuesses;
- (void) tallyLoss;

- (void) saveStatistics;
- (void) clearStatistics;

@property(nonatomic, readonly) NSUInteger totalWins;
@property(nonatomic, readonly) NSUInteger totalLosses;
@property(nonatomic, readonly) NSUInteger totalForfeit;
@property(nonatomic, readonly) float percentWon;
@property(nonatomic, readonly) float averageGuessesToWin;
@property(nonatomic, readwrite) BOOL recordStats;


@end
