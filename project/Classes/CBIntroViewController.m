//
//  CBIntroViewController.m
//  ColorCipher
//
//  Created by James George on 2/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CBIntroViewController.h"
#import "ColorCipherAppDelegate.h"
#import "RootViewController.h"
#import "MainViewController.h"

#define LABEL_BRIEF @"Thanks for downloading ColorCipher. Can you decipher the hidden color sequence?  If you have ever played MasterMind or Bulls & Cows then you already know how to play.  Ready to start?"

@implementation CBIntroViewController
@synthesize mainView;
@synthesize briefIntro;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.briefIntro.text = LABEL_BRIEF;	
	self.briefIntro.font = [UIFont systemFontOfSize:15.5];
}

- (IBAction) showRules
{
	ColorCipherAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
	[appDelegate.rootViewController toggleViewToRules];
	[self.mainView disposeIntro];
}

- (IBAction) play
{
	[self.mainView disposeIntro];	
}


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
