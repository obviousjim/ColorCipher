/**
 *  CodeBreaker Beta
 *  This is a simple remake of the MasterMind game from the 1970's
 *  Author: James George
 *  Cocoa Camp Application Competetion entry
 */


#import <UIKit/UIKit.h>

@class RootViewController, CBGameModel;
@interface ColorCipherAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
	RootViewController *rootViewController;
	CBGameModel* game;
	BOOL gameInProgress;
}

@property (nonatomic, readonly) IBOutlet UIWindow* window;
@property (nonatomic, retain) IBOutlet RootViewController* rootViewController;
@property (nonatomic, retain) CBGameModel* game;
@property (nonatomic, readwrite) BOOL gameInProgress;
@end

