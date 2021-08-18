//
//  ViewController.m
//  JSPatch_demo
//
//  Created by zhang_rongwu on 15/12/10.
//  Copyright © 2015年 zhang_rongwu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc] init];
    [self.view addSubview:button];
    button.frame = CGRectMake(50, 200, self.view.frame.size.width - 100, 100);
    [button setTitle:@"进入界面" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
}
/** 
 
 按钮本来输出sss的
 但是通过JSPatch替换了这个方法
 直接查看index.js文件
 */
- (void)buttonAction:(UIButton *)sender {
    NSLog(@"sss");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


















@end
