//
//  CBTouchResponderView.h
//  ColorCipher
//
//  Created by Jim on 1/29/09.
//  Copyright 2009 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBPegView;
@interface CBTouchResponderView : UIView {
@public
	CBPegView* currentPegTarget;
@protected
	double totalDisplacement;
}

@property (nonatomic, assign) CBPegView* currentPegTarget;

@end
