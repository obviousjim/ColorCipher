/**
 *  CodeBreaker Beta
 *  This is a simple remake of the MasterMind game from the 1970's
 *  Author: James George
 *  Cocoa Camp Application Competetion entry
 */

#import <UIKit/UIKit.h>

@interface CBPegView : UIImageView {
	UIImageView* colors;
	UIImageView* padding;
	NSUInteger color;
}

@property(nonatomic, readonly) NSUInteger color;
@property(nonatomic, retain) UIImageView* padding;
@property(nonatomic, retain) UIImageView* colors;


- (void) activate;
- (void) deactivate;

- (void) showSingleColor:(NSUInteger)theColor animate:(BOOL)animate;
- (void) showSingleColor:(NSUInteger)theColor;
- (void) displayCurrentColor:(BOOL)animate;

- (void) moveBy:(CGFloat)amount;
- (void) moveBy:(CGFloat)amount animate:(BOOL)animate;
- (void) moveBy:(CGFloat)amount animate:(BOOL)animate duration:(NSTimeInterval)duration;


- (void) finishTouches;
- (void) showNextColor;
- (void) showPreviousColor;

- (void) spin:(BOOL)down;
@end
