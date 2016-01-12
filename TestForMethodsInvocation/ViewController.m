//
//  ViewController.m
//  TestForMethodsInvocation
//
//  Created by Marcin Krzych on 05/01/16.
//  Copyright © 2016 Marcin Krzych. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSMutableString* stringForMethodInvocation;
    NSMutableString* stringForTests;
    SEL selectorForMethod;
    IMP impForMethod;
    
    long amountOfOperations;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    stringForTests = [NSMutableString stringWithFormat:@"firstString"];
    
    amountOfOperations = 10000000;
    selectorForMethod = NSSelectorFromString(@"uppercaseString");
    impForMethod = [stringForTests methodForSelector:selectorForMethod];
    
    NSLog(@"------------------------------------------------");
    NSLog(@"------------- METHODS INVOCATION ---------------");
    NSLog(@"------------------------------------------------");
    
    NSLog(@"CASE 1");
    [self executeTestTimeMeasure:NSStringFromSelector(@selector(runMethodDirectly))];
    
    
    NSLog(@"CASE 2");
    [self executeTestTimeMeasure:NSStringFromSelector(@selector(runMethodWithObjCMsgSend))];
    
    
    NSLog(@"CASE 3");
    [self executeTestTimeMeasure:NSStringFromSelector(@selector(runMethodWithPerformSelector))];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)runMethodDirectly {
    for (long i=0; i<amountOfOperations; i++) {
        [stringForTests setString:@"testString"];
    }
}

- (void)runMethodWithObjCMsgSend {
    for (long i=0; i<amountOfOperations; i++) {
        objc_msgSend(stringForTests, selectorForMethod);
    }
}

- (void)runMethodWithPerformSelector {
    for (long i=0; i<amountOfOperations; i++) {
        [stringForTests performSelector:selectorForMethod withObject:stringForTests];
    }
}

- (NSTimeInterval)executeTestTimeMeasure:(NSString*)methodName {
    NSDate* start = [NSDate date];
    
    SEL selector = NSSelectorFromString(methodName);
    IMP imp = [self methodForSelector:selector];
    void (*func)(id, SEL) = (void *)imp;
    
    func(self, selector);
    
    NSDate* end = [NSDate date];
    NSTimeInterval executionTime = [end timeIntervalSinceDate:start];
    NSLog(@"%@ execution time: %f", methodName, executionTime);
    
    return executionTime;
}

@end
