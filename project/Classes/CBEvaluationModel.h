//
//  CBEvaluationModel.h
//  ColorCipher
//
//  Created by Jim on 2/5/09.
//  Copyright 2009 University of Washington. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBEvaluationModel : NSObject {
	NSUInteger red;
	NSUInteger white;
	NSArray* guess;
}

@property (nonatomic, assign) NSUInteger red;
@property (nonatomic, assign) NSUInteger white;
@property (nonatomic, assign) NSArray* guess;

+ (CBEvaluationModel*) evaluationForGuess:(NSArray*) guess andSolution:(NSArray*)solution; 

@end
