/**
 *  CodeBreaker Beta
 *  This is a simple remake of the MasterMind game from the 1970's
 *  Author: James George
 *  Cocoa Camp Application Competetion entry
 */

#import "ColorCipherAppDelegate.h"
#import "RootViewController.h"
#import "CBGameConstants.h"
#import "MainViewController.h"

@implementation ColorCipherAppDelegate
@synthesize window;
@synthesize rootViewController;
@synthesize game;
@synthesize gameInProgress;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	[window addSubview:[rootViewController view]];
	[window makeKeyAndVisible]; 
}

- (void) applicationWillTerminate:(UIApplication *)application
{
	if(self.gameInProgress){
		[self.game saveGameState];
		[rootViewController.mainViewController saveCurrentGuess];
	}
}

- (CBGameModel*) game
{
	if(!game){
		game = [[[CBGameModel alloc] init] retain];
	}
	return game;
}

- (void) dealloc 
{
	[rootViewController release];
	[game release];
	[window release];
	[super dealloc];
}

@end
