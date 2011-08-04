//
//  CBRevealSliderView.h
//  ColorCipher
//
//  Created by Jim on 2/5/09.
//  Copyright 2009 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBRevealSliderView;
@protocol CBSliderDelegate
- (void) sliderDidComplete:(CBRevealSliderView*)slider;
@end

@interface CBRevealSliderView : UIImageView {
@protected
	UIImageView* thumb;
	UILabel* text;
@private
	double touchX;
	BOOL fingerOn;
	BOOL slideComplete;
	id<CBSliderDelegate> delegate;
}

@property (nonatomic, assign) IBOutlet UIImageView* thumb;
@property (nonatomic, assign) IBOutlet UILabel* text;
@property (nonatomic, assign) id delegate;

- (void) resetThumb;

@end

