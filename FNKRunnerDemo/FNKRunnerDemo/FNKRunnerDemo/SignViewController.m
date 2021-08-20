//
//  SignViewController.m
//  FNKRunnerDemo
//
//  Created by LWW on 2021/8/19.
//  Copyright © 2021 SilverFruity. All rights reserved.
//

#import "SignViewController.h"
#import "SignHandler.h"

@interface SignViewController ()

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, ([UIScreen mainScreen].bounds.size.height-40)/2-30, [UIScreen mainScreen].bounds.size.width-20, 40)];
    label.text = @"正在为您准备安装新版本包!";
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = 1;
    [self.view addSubview:label];
    
    UILabel *bot = [[UILabel alloc] initWithFrame:CGRectMake(10, ([UIScreen mainScreen].bounds.size.height-40)/2+20, [UIScreen mainScreen].bounds.size.width-20, 60)];
    bot.text = @"点击安装后可返回桌面查看进度\n取消可重新打开app再次更新\n安装成功后建议卸载老版本";
    bot.font = [UIFont systemFontOfSize:16];
    bot.numberOfLines = 0;
    bot.textAlignment = 1;
    [self.view addSubview:bot];
    
    UILabel *install = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-75, CGRectGetHeight(bot.bounds)+([UIScreen mainScreen].bounds.size.height-40)/2+50, 150, 40)];
    install.text = @"打开早游戏";
    install.font = [UIFont systemFontOfSize:15];
    install.textColor = [UIColor whiteColor];
    install.numberOfLines = 0;
    install.textAlignment = 1;
    install.backgroundColor = [UIColor redColor];
    [self.view addSubview:install];
    
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self click];
}

- (void)click{
    [SignHandler testData];
    NSLog(@"点击个狗子");
}

@end
