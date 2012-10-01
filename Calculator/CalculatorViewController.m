//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Dan Zhang on 9/28/12.
//  Copyright (c) 2012 Dan Zhang. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringAnExpression;
@property (nonatomic) BOOL userJustEnteredAnOperator;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display;
@synthesize userIsInTheMiddleOfEnteringAnExpression;
@synthesize userJustEnteredAnOperator;
@synthesize brain = _brain;

- (CalculatorBrain *) brain{
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    if (userIsInTheMiddleOfEnteringAnExpression) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    }
    else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringAnExpression = YES;
    }
    self.userJustEnteredAnOperator = NO;
}
- (IBAction)enterPressed {
    double total = 0;
    NSArray *tokens = [self.display.text componentsSeparatedByString:@" "];
    if((![[tokens objectAtIndex:0] isEqualToString:@"+"] &&
       ![[tokens objectAtIndex:0] isEqualToString:@"-"] &&
       ![[tokens objectAtIndex:0] isEqualToString:@"*"] &&
       ![[tokens objectAtIndex:0] isEqualToString:@"/"]) ||
       (![[tokens objectAtIndex:(tokens.count - 1)] isEqualToString:@"+"] &&
       ![[tokens objectAtIndex:(tokens.count - 1)] isEqualToString:@"-"] &&
       ![[tokens objectAtIndex:(tokens.count - 1)] isEqualToString:@"*"] &&
       ![[tokens objectAtIndex:(tokens.count - 1)] isEqualToString:@"/"])){
        total = [self.brain solveExpression:tokens];
        self.display.text = [NSString stringWithFormat:@"%f", total];
        self.userIsInTheMiddleOfEnteringAnExpression = NO;
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    if(!self.userJustEnteredAnOperator){
        NSString *operator = [sender currentTitle];
        NSString *space = @" ";
        if(userIsInTheMiddleOfEnteringAnExpression) {
            //tagging on operators 
            self.display.text = [self.display.text stringByAppendingString:space];
            self.display.text = [self.display.text stringByAppendingString:operator];
            self.display.text = [self.display.text stringByAppendingString:space];
        }
        self.userJustEnteredAnOperator = YES;
    }
}
- (IBAction)clearPressed {
    self.display.text = @"0";
    self.userIsInTheMiddleOfEnteringAnExpression = NO;
    self.userJustEnteredAnOperator = NO;
}


- (IBAction)backspacePressed {
    if(!self.display.text.length != 1){
        //if whitespace is found we know we need to remove an operator
        //needs to reset all the permission booleans
        NSString *operatorCheck = [self.display.text substringWithRange:NSMakeRange(self.display.text.length - 1, 1)];
        if([operatorCheck isEqualToString:@" "]){
            self.display.text = [self.display.text substringToIndex:(self.display.text.length - 3)];
            self.userJustEnteredAnOperator = NO;
        }
        else{
            self.display.text = [self.display.text substringToIndex:(self.display.text.length - 1)];
        }
        
        if(self.display.text.length == 0){
            self.display.text = @"0";
            self.userIsInTheMiddleOfEnteringAnExpression = NO;
            self.userJustEnteredAnOperator = NO;
        }
    }
    else{
        self.display.text = @"0";
        self.userIsInTheMiddleOfEnteringAnExpression = NO;
        self.userJustEnteredAnOperator = NO;
    }
}
@end
