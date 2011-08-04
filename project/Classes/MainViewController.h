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
