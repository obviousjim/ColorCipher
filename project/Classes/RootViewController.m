/**
 *  CodeBreaker Beta
 *  This is a simple remake of the MasterMind game from the 1970's
 *  Author: James George
 *  Cocoa Camp Application Competetion entry
 */

#import "RootViewController.h"
#import "MainViewController.h"
#import "CBStatsViewController.h"
#import "CBRulesViewController.h"
#import "CBAboutViewController.h"

@implementation RootViewController

@synthesize infoButton;
@synthesize flipsideNavigationBar;
@synthesize mainViewController;
@synthesize flipsideViewController;

- (void)viewDidLoad
{	
	MainViewController *viewController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = viewController;
	[viewController release];
	
	[self.view insertSubview:self.mainViewController.view belowSubview:infoButton];
}

- (void)loadFlipsideViewController 
{	
	self.flipsideViewController = [[UITabBarController alloc] init];
	//for some reason there is exaclty 20 pixels off... can't track this down for the life of me.
	self.flipsideViewController.view.transform = CGAffineTransformMakeTranslation(0, -20);
	
	UINavigationController* statsNavCtrl = [[UINavigationController alloc] init];
	UIViewController* statsController = [[CBStatsViewController alloc] initWithNibName:@"Statistics" bundle:nil];
	UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toggleView)];
	statsController.navigationItem.rightBarButtonItem = buttonItem;
	[statsNavCtrl pushViewController:statsController animated:NO];
	statsNavCtrl.title = @"Statistics";
	statsNavCtrl.tabBarItem.image = [UIImage imageNamed:@"scoreboard_icon.png"];
	
	UINavigationController* rulesNavCtrl = [[UINavigationController alloc] init];
	UIViewController* rulesController = [[CBRulesViewController alloc] initWithNibName:@"Rules" bundle:nil];
	rulesController.navigationItem.rightBarButtonItem = buttonItem;
	[rulesNavCtrl pushViewController:rulesController animated:NO];
	rulesNavCtrl.title = @"Instructions";
	rulesNavCtrl.tabBarItem.image = [UIImage imageNamed:@"rules_icon.png"];
	
	UINavigationController* aboutNavCtrl = [[UINavigationController alloc] init];
	UIViewController* aboutController = [[CBAboutViewController alloc] initWithNibName:@"About" bundle:nil];
	aboutController.navigationItem.rightBarButtonItem = buttonItem;
	[aboutNavCtrl pushViewController:aboutController animated:NO];
	aboutNavCtrl.title = @"About";
	aboutNavCtrl.tabBarItem.image = [UIImage imageNamed:@"icon_about.png"];
	
	statsNavCtrl.navigationBar.barStyle = rulesNavCtrl.navigationBar.barStyle = aboutNavCtrl.navigationBar.barStyle = UIBarStyleBlackOpaque;

	//[self.flipsideViewController setViewControllers:[NSArray arrayWithObjects: statsController, rulesController, aboutController, nil] animated: NO];
	[self.flipsideViewController setViewControllers:[NSArray arrayWithObjects: statsNavCtrl, rulesNavCtrl, aboutNavCtrl, nil] animated: NO];
	[statsController release];
	[rulesController release];
	[aboutController release];
	[statsNavCtrl release];
	[rulesNavCtrl release];
	[aboutNavCtrl release];
	
	// Set up the navigation bar
	UINavigationBar *aNavigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
	aNavigationBar.barStyle = UIBarStyleBlackOpaque;
	[aNavigationBar release];
	buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toggleView)];
	UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"ColorCipher"];
	navigationItem.rightBarButtonItem = buttonItem;	

	[navigationItem release];
	[buttonItem release];
}

- (IBAction)toggleView 
{	
	/*
	 This method is called when the info or Done button is pressed.
	 It flips the displayed view from the main view to the flipside view and vice-versa.
	 */
	if (flipsideViewController == nil) {
		[self loadFlipsideViewController];
	}

	[(CBStatsViewController*)[[self.flipsideViewController.viewControllers objectAtIndex:0] topViewController] updateStatDisplay];
	
	UIView *mainView = mainViewController.view;
	UIView *flipsideView = flipsideViewController.view;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition:([mainView superview] ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft) forView:self.view cache:YES];
	
	if ([mainView superview] != nil) {
		[flipsideViewController viewWillAppear:YES];
		[mainViewController viewWillDisappear:YES];
		[mainView removeFromSuperview];
        [infoButton removeFromSuperview];
		[self.view addSubview:flipsideView];
		[self.view insertSubview:flipsideNavigationBar aboveSubview:flipsideView];
		[mainViewController viewDidDisappear:YES];
		[flipsideViewController viewDidAppear:YES];
	}
	else {
		[mainViewController viewWillAppear:YES];
		[flipsideViewController viewWillDisappear:YES];
		[flipsideView removeFromSuperview];
		[flipsideNavigationBar removeFromSuperview];
		[self.view addSubview:mainView];
		[self.view insertSubview:infoButton aboveSubview:mainViewController.view];
		[flipsideViewController viewDidDisappear:YES];
		[mainViewController viewDidAppear:YES];
	}
	[UIView commitAnimations];
}

- (void) toggleViewToRules
{
	if (flipsideViewController == nil) {
		[self loadFlipsideViewController];
	}
	//select the rule view
	flipsideViewController.selectedViewController = [flipsideViewController.viewControllers objectAtIndex:1];
	[self toggleView];	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc
{
	[infoButton release];
	[flipsideNavigationBar release];
	[mainViewController release];
	[flipsideViewController release];
	[super dealloc];
}


@end
