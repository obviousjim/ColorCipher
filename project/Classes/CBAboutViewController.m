//
//  CBAboutViewController.m
//  ColorCipher
//
//  Created by James George on 2/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CBAboutViewController.h"


@implementation CBAboutViewController

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"About";
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
/*
- (void)viewDidLoad {
    [super viewDidLoad];
	
}
*/

- (IBAction) sendFeedback
{
	NSURL *url = [[NSURL alloc] initWithString:@"mailto:backsmith@gmail.com"];
	[[UIApplication sharedApplication] openURL:url];
	
}

- (IBAction) visitSite
{
	NSURL *url = [[NSURL alloc] initWithString:@"http://www.colorcipher.com"];
	[[UIApplication sharedApplication] openURL:url];	
}


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
