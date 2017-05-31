//
//  ZBVIPsViewController.m
//  MiYouProject
//
//  Created by wkj on 2017/5/31.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import "ZBVIPsViewController.h"

@interface ZBVIPsViewController ()

@end

@implementation ZBVIPsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabBarImageAndTextColor];
    // Do any additional setup after loading the view.
}

- (IBAction)weiXinButtonAction:(UIButton *)sender {
}


- (IBAction)zhiFuBaoButtonAction:(UIButton *)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self setTabBarImageAndTextColor];//设置Tabbar 文字和颜色
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
