/**
 *  CodeBreaker Beta
 *  This is a simple remake of the MasterMind game from the 1970's
 *  Author: James George
 *  Cocoa Camp Application Competetion entry
 */


#import <UIKit/UIKit.h>
#import "CBGameModel.h"

@class MainViewController;
@interface RootViewController : UIViewController {
	UIButton *infoButton;
	MainViewController *mainViewController;
	UITabBarController *flipsideViewController;
	UINavigationBar *flipsideNavigationBar;
}

@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) MainViewController *mainViewController;
@property (nonatomic, retain) UINavigationBar *flipsideNavigationBar;
@property (nonatomic, retain) UITabBarController *flipsideViewController;

- (IBAction) toggleView;
- (void) toggleViewToRules;

@end
