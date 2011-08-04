/**
 *  CodeBreaker Beta
 *  This is a simple remake of the MasterMind game from the 1970's
 *  Author: James George
 *  Cocoa Camp Application Competetion entry
 */

#import <UIKit/UIKit.h>

typedef enum {
	CBGameStatusLoss		= 0,
	CBGameStatusWin			= 1,
	CBGameStatusPlaying		= 2,
	CBGameStatusForfeit		= 4,
	CBGameStatusPaused		= 5
} CBGameStatus;

@class CBStatisticsModel, CBEvaluationModel;
@interface CBGameModel : NSObject {
	NSUInteger currentRow;
	CBGameStatus status;
	NSArray* solution;
	NSMutableArray* history;
	CBStatisticsModel* stats;
@private
	BOOL inMemoryWarning;
}

@property(nonatomic, readonly) CBGameStatus status;
@property(nonatomic, retain) CBStatisticsModel* stats;

@property(nonatomic, readonly) NSUInteger currentRow;
@property(nonatomic, retain) NSArray* solution;
@property(nonatomic, retain) NSMutableArray* history;

- (void) initGame;
- (CBEvaluationModel*) confirmGuess:(NSArray*) guess;
- (void) saveGameState;
- (void) forfeit;
- (void) reset;

@end
