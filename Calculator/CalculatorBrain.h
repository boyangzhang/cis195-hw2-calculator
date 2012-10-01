//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Dan Zhang on 10/1/12.
//  Copyright (c) 2012 Dan Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushValue:(double)value;
- (double)popValue;
- (void)pushOperator:(NSString *) operator;
- (NSString *)popOperator;
- (double)performOperation:(NSString *)operation;
- (double)solveExpression:(NSArray *)expressionTokens;

@end
