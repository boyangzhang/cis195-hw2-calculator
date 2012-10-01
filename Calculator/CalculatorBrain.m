//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Dan Zhang on 10/1/12.
//  Copyright (c) 2012 Dan Zhang. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
//Data structures needed to convert infix to postfix for easy operation
@property (nonatomic, strong) NSMutableArray *valueStack;
@property (nonatomic, strong) NSMutableArray *operatorStack;
@property (nonatomic, strong) NSMutableArray *resultQueue;
@end

@implementation CalculatorBrain

@synthesize valueStack = _valueStack;
@synthesize operatorStack = _operatorStack;
@synthesize resultQueue = _resultQueue;

- (NSMutableArray *) valueStack{
    if(!_valueStack) {
        _valueStack = [[NSMutableArray alloc] init];
    }
    return _valueStack;
}

- (NSMutableArray *) operatorStack{
    if(!_operatorStack){
        _operatorStack = [[NSMutableArray alloc] init];
    }
    return _operatorStack;
}

- (NSMutableArray *) resultQueue{
    if(!_resultQueue){
        _resultQueue = [[NSMutableArray alloc] init];
    }
    return _resultQueue;
}

//push onto value stack
- (void)pushValue:(double)value {
    NSNumber *valueObject = [NSNumber numberWithDouble:value];
    [self.valueStack addObject:valueObject];
}

//returns nil if there are no more objects on the stack to remove
- (double)popValue{
    NSNumber *valueObject = [self.valueStack lastObject];
    if(valueObject) [self.valueStack removeLastObject];
    return [valueObject doubleValue];
}

- (void) pushOperator:(NSString *)operator {
    [self.operatorStack addObject:operator];
}

-(NSString *) popOperator{
    NSString *operator = [self.operatorStack lastObject];
    if(operator) [self.operatorStack removeLastObject];
    return operator;
    
}

- (void) enqueueItem:(id)item{
    [self.resultQueue addObject:item];
}

-(id) dequeueItem{
    id item = [self.resultQueue objectAtIndex:0];
    if(item) [self.resultQueue removeObjectAtIndex:0];
    return item;
}

//Does the mathematical calculations
- (double)performOperation:(NSString *)operation{
    double result = 0;
    
    if([operation isEqualToString:@"+"]){
        result = [self popValue] + [self popValue];
        NSLog(@"Addition Operation Performed, result:%f", result);
    }
    else if([operation isEqualToString:@"-"]){
        double subtract = [self popValue];
        result = [self popValue] - subtract;
        NSLog(@"Subtraction Operation Performed, result:%f", result);
    }
    else if([operation isEqualToString:@"*"]){
        result = [self popValue] * [self popValue];
        NSLog(@"Multiplication Operation Performed, result:%f", result);
    }
    else if([operation isEqualToString:@"/"]){

        double divisor = [self popValue];
        double dividend = [self popValue];
        if(!divisor){
            NSLog(@"Divide by zero. Oh shi...");
            return 0;//return 0 if there's divide by zero.  Not trying to handle stupid errors with NaNs
        }
        else{
            result = dividend / divisor;
            NSLog(@"Division Operation Performed, result:%f", result);
        }
    }
    NSLog(@"Pushing result back to valueStack:%f", result);
    [self pushValue:result];
    
    return result;
}

//uses algorithm to convert infix to postfix and calculate
-(double)solveExpression:(NSArray *)expressionTokens{
    //figure out precedence
    NSDictionary *operatorPrecedence = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        [NSNumber numberWithInt:1], @"+", [NSNumber numberWithInt:1], @"-",
                                        [NSNumber numberWithInt:3], @"*", [NSNumber numberWithInt:3], @"/", nil];
    double result = 0;
    NSLog(@"Size of expression: %d", expressionTokens.count);
    
    //convert expression from infix to prefix order
    for(int i = 0; i < expressionTokens.count; i++){
        if(![[expressionTokens objectAtIndex:i] isEqualToString:@"+"] &&
           ![[expressionTokens objectAtIndex:i] isEqualToString:@"-"] &&
           ![[expressionTokens objectAtIndex:i] isEqualToString:@"*"] &&
           ![[expressionTokens objectAtIndex:i] isEqualToString:@"/"]){
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber * myNumber = [f numberFromString:[expressionTokens objectAtIndex:i]];
            //enqueues all numbers
            NSLog(@"Enqueuing number: %f", [myNumber doubleValue]);
            [self enqueueItem:myNumber];
            	
        }
        else{
            if(self.operatorStack.count == 0){
                //if operaterstack is empty enqueue operator
                NSLog(@"Operator Stack is empty, pushing %@", [expressionTokens objectAtIndex:i]);
                [self pushOperator:[expressionTokens objectAtIndex:i]];
            }
            else if([[operatorPrecedence objectForKey:[expressionTokens objectAtIndex:i]] intValue] > [[operatorPrecedence objectForKey:[self.operatorStack lastObject]] intValue]){
                //if the operator has greater precedence push onto stack
                NSLog(@"Pushing %@ to operator stack", [expressionTokens objectAtIndex:i]);
                [self pushOperator:[expressionTokens objectAtIndex:i]];
            }
            else{
                //if operator has <= precedence pop from stack all greater operators and enqueue them
                //then push current operator onto stack
                while([[operatorPrecedence objectForKey:[expressionTokens objectAtIndex:i]] intValue] <= [[operatorPrecedence objectForKey:[self.operatorStack lastObject]] intValue] && self.operatorStack.count > 0){
                    NSLog(@"Moving operator %@ to queue", [self.operatorStack lastObject]);
                    [self enqueueItem:[self popOperator]];
                }
                [self pushOperator:[expressionTokens objectAtIndex:i]];
            }
        }
    }
    //enqueue all remaining operators on stack
    while(self.operatorStack.count > 0){
       [self enqueueItem:[self popOperator]]; 
    }

    
    //run prefix operations
    while(self.resultQueue.count > 0){
        id item = [self dequeueItem];
        if([item isKindOfClass:[NSNumber class]]){
            NSLog(@"Pushing number to value stack: %f", [item doubleValue]);
            [self pushValue:[item doubleValue]];
        }
        else{
            [self performOperation:item];
        }
    }
    result = [self popValue];
    return result;
}
                     
@end
