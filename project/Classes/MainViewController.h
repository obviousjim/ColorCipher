/**
 *  CodeBreaker Beta
 *  This is a simple remake of the MasterMind game from the 1970's
 *  Author: James George
 *  Cocoa Camp Application Competetion entry
 */

#import <UIKit/UIKit.h>
#import "CBRevealSliderView.h"

@class CBGameModel, CBEvaluationModel, CBGameEndAlert, CBIntroViewController;
@interface MainViewController : UIViewController <CBSliderDelegate>{
@protected
	CBGameModel* game;
	NSMutableArray* rows;
	NSMutableArray* evaluations;
	NSMutableArray* touchResponders;
	
	UIImageView* solutionRow;
	UIImageView* cover;	
	UIButton* okButton;
	UILabel* doubletapHint;
	UIButton* newGameButton;
	CBRevealSliderView* revealer;
	
	CBGameEndAlert* alertPanel;
	
	CBIntroViewController* introController;
}

@property(nonatomic, assign) CBGameModel* game;
@property(nonatomic, retain) UIImageView* solutionRow;
@property(nonatomic, retain) NSMutableArray* rows;
@property(nonatomic, retain) NSMutableArray* evaluations;
@property(nonatomic, retain) NSMutableArray* touchResponders;

@property(nonatomic, retain) IBOutlet UIImageView* cover;
@property(nonatomic, retain) IBOutlet UIButton* okButton;
@property(nonatomic, retain) UILabel* doubletapHint;

@property(nonatomic, retain) IBOutlet UIButton* newGameButton;
@property(nonatomic, retain) IBOutlet CBRevealSliderView* revealer;

@property(nonatomic, retain) IBOutlet CBGameEndAlert* alertPanel;
@property(nonatomic, assign) NSArray* currentGuess;


- (void) activateRow;
- (void) revealSolution;
- (IBAction) singleTouchOK;
- (IBAction) confirmGuess;
- (IBAction) newGame;
- (void) restoreFromHistory;
- (void) saveCurrentGuess;
- (void) disposeIntro;
- (void) hintDoubleTap; 

@end
