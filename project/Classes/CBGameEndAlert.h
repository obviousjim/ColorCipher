//
//  CBGameEndAlert.h
//  ColorCipher
//
//  Created by Jim on 2/14/09.
//  Copyright 2009 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBGameModel.h"

@class CBStatisticsModel;
@interface CBGameEndAlert : UIView {
@protected	
	UILabel* statsText;
	UILabel* smallTextAbove;
	UILabel* smallTextBelow;

	CBStatisticsModel* stats;
	CBGameStatus status;
}

@property(nonatomic, retain) IBOutlet UILabel* statsText;
@property(nonatomic, retain) IBOutlet UILabel* smallTextAbove;
@property(nonatomic, retain) IBOutlet UILabel* smallTextBelow;

- (void) displayWithStats:(CBStatisticsModel*)gameStats andStatus:(CBGameStatus)gameStatus;
- (void) fadeOut;

@end
