//
//  CBStatsViewController.m
//  ColorCipher
//
//  Created by Jim on 2/1/09.
//  Copyright 2009 University of Washington. All rights reserved.
//

#import "CBRulesViewController.h"
#define SEGINDEX_RULES 0
#define SEGINDEX_EXAMPLES 1
#define SEGINDEX_TIPS 2

@interface CBRulesViewController (Private)
- (void) selectedTab:(UISegmentedControl*)segments;
- (void) selectedTabIndex:(NSUInteger)tabIndex;
@end


@implementation CBRulesViewController
@synthesize rulesView;		

 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		 UISegmentedControl* segments = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Rules", @"Examples", @"Tips", nil]];
		 segments.segmentedControlStyle = UISegmentedControlStyleBar;
		 segments.selectedSegmentIndex = 0;
		 self.navigationItem.titleView = segments;
		 [segments addTarget:self 
					  action:@selector(selectedTab:)
			forControlEvents:UIControlEventValueChanged];
		 [segments release];
	 }
	 return self;
 }


/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

- (void) selectedTab:(UISegmentedControl*)segments
{
	[self selectedTabIndex:segments.selectedSegmentIndex];
}

- (void) selectedTabIndex:(NSUInteger)tabIndex
{
	NSString *imagePath = [[NSBundle mainBundle] resourcePath];
	imagePath = [imagePath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
	imagePath = [imagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	NSString* htmlFileName;
	switch (tabIndex) {
		case SEGINDEX_RULES:
			htmlFileName = @"rules";
			break;
		case SEGINDEX_EXAMPLES:
			htmlFileName = @"examples";
			break;
		case SEGINDEX_TIPS:
			htmlFileName = @"tips";
			break;
	}
	NSString *htmlFile = [[NSBundle mainBundle] pathForResource:htmlFileName ofType:@"html"];	 
	NSData *htmlData = [NSData dataWithContentsOfFile:htmlFile];
	[self.rulesView loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:[NSString stringWithFormat:@"file:/%@//",imagePath]]];  
}

 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad 
{
	/*
	 NSString *imagePath = [[NSBundle mainBundle] resourcePath];
	 imagePath = [imagePath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
	 imagePath = [imagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	 NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"rules" ofType:@"html"];	 
	 NSData *htmlData = [NSData dataWithContentsOfFile:htmlFile];
	 [self.rulesView loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:[NSString stringWithFormat:@"file:/%@//",imagePath]]];  
	 */
	[self selectedTabIndex:0];
 }

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc
{
	[rulesView release];
    [super dealloc];
}


@end
