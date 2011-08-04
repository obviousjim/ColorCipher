//
//  CBAboutViewController.h
//  ColorCipher
//
//  Created by James George on 2/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBAboutViewController : UIViewController {
	UIButton* sendFeedback;
	UIButton* visitSite;
}

- (IBAction) sendFeedback;
- (IBAction) visitSite;

@end
