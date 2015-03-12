//
//  ViewController.m
//  demo
//
//  Created by zhaoxiao on 15/3/12.
//  Copyright (c) 2015年 shaw. All rights reserved.
//

#import "ViewController.h"
#import "ZSDGridFilterView.h"

@interface ViewController ()<ZSDGridFilterViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(100, 100, 100, 50)];
    [btn setTitle:@"show" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showGird:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)showGird:(UIButton *)sender
{
    ZSDGridFilterView *gridFilter = [[ZSDGridFilterView alloc]initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, self.view.bounds.size.height)];
    gridFilter.maxIssueNum = 100;
    gridFilter.delegate = self;
    [gridFilter showInView:self.view];
}

-(void)gridView:(ZSDGridFilterView *)gridView didSelectedIssue:(NSInteger)issue
{
    NSLog(@"issueNO: %ld",issue);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
