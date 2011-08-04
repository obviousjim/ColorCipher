//
//  CBStatsViewController.h
//  ColorCipher
//
//  Created by Jim on 2/1/09.
//  Copyright 2009 University of Washington. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBStatisticsModel;
@interface CBStatsViewController : UIViewController {
	UILabel* totalWins;
	UILabel* totalLosses;
	UILabel* totalForfeit;
	
	UILabel* percentWon;
	UILabel* averageGuesses;
	
	UISwitch* record;
	UIView* confirmClearView;
	
	CBStatisticsModel* stats;
}

@property (nonatomic, retain) IBOutlet UILabel* totalWins;
@property (nonatomic, retain) IBOutlet UILabel* totalLosses;
@property (nonatomic, retain) IBOutlet UILabel* totalForfeit;

@property (nonatomic, retain) IBOutlet UILabel* percentWon;
@property (nonatomic, retain) IBOutlet UILabel* averageGuesses;

@property (nonatomic, retain) IBOutlet UISwitch* record;
@property (nonatomic, retain) IBOutlet UIView* confirmClearView;

@property (nonatomic, assign) CBStatisticsModel* stats;

- (void) updateStatDisplay;
- (IBAction) clearStatistics;
- (IBAction) toggleKeepStats:(UISwitch*)toggleKeepStats;
- (IBAction) reallyClear;
- (IBAction) hideConfirmPanel;

@end
