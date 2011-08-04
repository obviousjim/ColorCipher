//
//  CBIntroViewController.h
//  ColorCipher
//
//  Created by James George on 2/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;
@interface CBIntroViewController : UIViewController {
	MainViewController* mainView;	
	UILabel* briefIntro;
}

@property (nonatomic, assign) MainViewController* mainView;
@property (nonatomic, assign) IBOutlet UILabel* briefIntro;

- (IBAction) showRules;
- (IBAction) play;


@end
