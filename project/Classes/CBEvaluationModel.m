//
//  CBEvaluationModel.m
//  ColorCipher
//
//  Created by Jim on 2/5/09.
//  Copyright 2009 University of Washington. All rights reserved.
//

#import "CBEvaluationModel.h"


@implementation CBEvaluationModel
@synthesize red;
@synthesize white;
@synthesize guess;

+ (CBEvaluationModel*) evaluationForGuess:(NSArray*)guess andSolution:(NSArray*)solution
{
	CBEvaluationModel* evaluation = [[CBEvaluationModel alloc] init];
	evaluation.guess = guess;
	BOOL usedGuess[] = { NO, NO, NO, NO };
	BOOL usedSolution[] = { NO, NO, NO, NO };	
	evaluation.white = 0;
	evaluation.red = 0;
	NSUInteger i, j;
	for(i = 0; i < 4; i++){
		if( [[guess objectAtIndex:i] intValue] == [[solution objectAtIndex:i] intValue] ){
			evaluation.red++;
			usedGuess[i] = usedSolution[i] = YES;
		}
	}
	
	for(i = 0; i < 4; i++){
		for(j = 0; j < 4; j++){
			if(!usedGuess[i] && !usedSolution[j] && [[guess objectAtIndex:i] intValue] == [[solution objectAtIndex:j] intValue]){
				evaluation.white++;
				usedGuess[i] = usedSolution[j] = YES;
 				break;
			}
		}
	}
	return [evaluation autorelease];
}
@end
