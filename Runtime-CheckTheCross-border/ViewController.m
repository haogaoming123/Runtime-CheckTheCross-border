//
//  ViewController.m
//  Runtime-CheckTheCross-border
//
//  Created by haogaoming on 2017/2/21.
//  Copyright © 2017年 郝高明. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str = nil;
    
    NSArray *array = @[@"1",@"2",@"3"];
    NSLog(@"第4个值为：%@",[array objectAtIndex:3]);
    
    NSMutableArray *mut = [NSMutableArray array];
    [mut addObject:@"1"];
    [mut addObject:@"2"];
    [mut addObject:str];
    NSLog(@"mut第4个值为：%@",[mut objectAtIndex:3]);

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:str forKey:@"3"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
