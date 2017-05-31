//
//  ZBQianYueViewControdller.m
//  MiYouProject
//
//  Created by wkj on 2017/5/31.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import "ZBQianYueViewControdller.h"

@interface ZBQianYueViewControdller (){

    BOOL _isMan;
    
}

@end

@implementation ZBQianYueViewControdller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabBarImageAndTextColor];//设置Tabbar 文字和颜色
     [self.manButton setImage:[UIImage imageNamed:@"renzhengnannvtubiao"] forState:UIControlStateSelected];
    [self.womanButton setImage:[UIImage imageNamed:@"renzhengnannvtubiao"] forState:UIControlStateSelected];
    // Do any additional setup after loading the view.
}
- (IBAction)manButtonAction:(UIButton *)sender {
    _isMan = YES;
    self.manButton.selected = YES;
    self.womanButton.selected = NO;
    
}
- (IBAction)womanButtonAction:(id)sender {
    _isMan = NO;
    self.manButton.selected = NO;
    self.womanButton.selected = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)finishedButtonAction:(id)sender {
    [MBManager showBriefAlert:@"提交成功！"];
    self.nameTextField.text = @"";
    self.ageTextField.text = @"";
    self.weixinTextField.text = @"";
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
