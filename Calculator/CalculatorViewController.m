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
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display;
@synthesize userIsInTheMiddleOfEnteringAnExpression;
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
    NSString *operator = [sender currentTitle];
    NSString *space = @" ";
    if(userIsInTheMiddleOfEnteringAnExpression) {
        //tagging on operators 
        self.display.text = [self.display.text stringByAppendingString:space];
        self.display.text = [self.display.text stringByAppendingString:operator];
        self.display.text = [self.display.text stringByAppendingString:space];
    }
}
@end
