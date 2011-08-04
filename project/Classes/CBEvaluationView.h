/**
 *  CodeBreaker Beta
 *  This is a simple remake of the MasterMind game from the 1970's
 *  Author: James George
 *  Cocoa Camp Application Competetion entry
 */

#import <UIKit/UIKit.h>
#import "CBGameModel.h"

@class MainViewController;
@interface CBEvaluationView : UIImageView {
	NSArray* guess;
	MainViewController* mainView;
}

@property(nonatomic, assign) MainViewController* mainView;

- (id)initWithEvaluation:(CBEvaluationModel*) evaluation;

@end
