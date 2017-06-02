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
    
    self.backView.layer.cornerRadius = 5.0f;
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.borderWidth = 1.0f;
    self.backView.layer.borderColor = [UIColor colorWithhex16stringToColor:Main_BackgroundColor].CGColor;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.topItem.title=@"VIP";
}

- (IBAction)weiXinButtonAction:(UIButton *)sender {
    if ([ZBALLModel isLogined]) {
        if (![ZBALLModel isZBVIP]) {
            
            [[ZBBuyVIPModel shareBuyVIPModel] loadDingDanInfoWithFirstType:@"wechat" withZBID:nil withVIPorWeiXin:VIP_TYPE_ENUM];
            
        }
    }
    else{
        
        [ZBALLModel pushToLoginViewControllerFromVC:self];
    
    }
    
}


- (IBAction)zhiFuBaoButtonAction:(UIButton *)sender {
    if ([ZBALLModel isLogined]) {
        if (![ZBALLModel isZBVIP]) {
            
             [[ZBBuyVIPModel shareBuyVIPModel] loadDingDanInfoWithFirstType:@"alipay" withZBID:nil withVIPorWeiXin:VIP_TYPE_ENUM];
            
        }
    }
    else{
        
        [ZBALLModel pushToLoginViewControllerFromVC:self];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self setTabBarImageAndTextColor];//设置Tabbar 文字和颜色

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
