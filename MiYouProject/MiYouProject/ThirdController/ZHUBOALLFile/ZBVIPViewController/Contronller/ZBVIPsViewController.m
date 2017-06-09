//
//  ZBVIPsViewController.m
//  MiYouProject
//
//  Created by wkj on 2017/5/31.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import "ZBVIPsViewController.h"

@interface ZBVIPsViewController (){

    NSString * _currentJINE;
}

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
    [self startAFNetworking];
}



- (IBAction)weiXinButtonAction:(UIButton *)sender {
    if ([ZBALLModel isLogined]) {
        if (![ZBALLModel isZBVIP]) {
            
            [[ZBBuyVIPModel shareBuyVIPModel] loadDingDanInfoWithFirstType:@"wechat" withZBID:nil withVIPorWeiXin:VIP_TYPE_ENUM withJINE:_currentJINE withVC:self];
            
        }
    }
    else{
        
        [ZBALLModel pushToLoginViewControllerFromVC:self];
    
    }
    
}


- (IBAction)zhiFuBaoButtonAction:(UIButton *)sender {
    if ([ZBALLModel isLogined]) {
        if (![ZBALLModel isZBVIP]) {
            [MBManager showLoading];
             [[ZBBuyVIPModel shareBuyVIPModel] loadDingDanInfoWithFirstType:@"alipay" withZBID:nil withVIPorWeiXin:VIP_TYPE_ENUM withJINE:_currentJINE withVC:self];
            
        }
    }
    else{
        
        [ZBALLModel pushToLoginViewControllerFromVC:self];
        
    }
}

- (void)startAFNetworking{
    
    __weak typeof(self) weakSelf = self;
    NSString * url = [NSString stringWithFormat:@"%@?action=vip",URL_Common_ios];
    NSLog(@"请求VIP：%@",url);
    [[ZLSecondAFNetworking sharedInstance] getWithURLString:url parameters:nil success:^(id responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"result"] isEqualToString:@"success"]) {
            weakSelf.priceLabel.text = [NSString stringWithFormat:@"￥%@",dic[@"price"]];
            _currentJINE = dic[@"price"];
        }
    } failure:^(NSError *error) {
        
    }];

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
