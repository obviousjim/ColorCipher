//
//  CBRulesViewController.h
//  ColorCipher
//
//  Created by Jim on 2/1/09.
//  Copyright 2009 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBRulesViewController : UIViewController {
	UIWebView* rulesView;
}

@property (nonatomic, retain) IBOutlet UIWebView* rulesView;

@end
