/*
 *  ColorCipher
 *
 * by James George
 * Copyright (C) 2008-2011
 *
 **********************************************************
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 *
 * ----------------------
 *
 * ColorCipher is a version of the popular game MasterMind for the iPhone
 */

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
