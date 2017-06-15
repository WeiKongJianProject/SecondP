//
//  ZBLoginViewController.m
//  MiYouProject
//
//  Created by wkj on 2017/6/1.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import "ZBLoginViewController.h"

@interface ZBLoginViewController ()

@end

@implementation ZBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    
    [self.backgroundImg setImageWithURL:[NSURL URLWithString:@"http://api.miyoutv.cc:8080/static/Index/Images/loginbg.png"] placeholder:[UIImage imageNamed:@"zllogin"]];
    
    [self.codeButton border:[UIColor colorWithhex16stringToColor:@"a3a3a3"] width:1.0f CornerRadius:3.0];
    
    [self.timeButtonLabel border:[UIColor lightGrayColor] width:1.0f CornerRadius:3.0];
    // Do any additional setup after loading the view from its nib.
    self.phoneTextField.telePhone = YES;
    self.codeTextField.number = YES;
}

- (IBAction)backButtonAction:(UIButton *)sender {
    
    NSLog(@"返回按钮");
    
}


- (IBAction)codeButtonAction:(id)sender {
    //UIColor clearColor
    [self senderSMSAction];
}

- (IBAction)finishButtonAction:(id)sender {
    
    //    self.phoneTextField.text = @"";
    //    self.codeTextField.text = @"";
    
    [self loginButtonAction];
    
}

//发送短信
- (void)senderSMSAction{
    __weak typeof(self) weakSelf = self;
    
    NSString * str = [NSString stringWithFormat:@"%@?action=sms&type=login&phone=%@",URL_Common_ios,self.phoneTextField.text];
    //去空格
    NSString * temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * codeString = [temp stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"编码前---%@，发送验证码URL：%@",temp,codeString);
    [[ZLSecondAFNetworking sharedInstance] getWithURLString:codeString parameters:nil success:^(id responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"result"] isEqualToString:@"success"]) {
            [weakSelf.codeButton startWithTime:60 title:@"获取验证码" countDownTitle:@"s" mainColor:[UIColor clearColor] countColor:[UIColor whiteColor]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"发送失败");
    }];
}

- (void)loginButtonAction{
    
    [MBManager showLoading];
    
    __weak typeof(self) weakSelf = self;
    
    NSString * str = [NSString stringWithFormat:@"%@?action=login&code=%@&phone=%@",URL_Common_ios,self.codeTextField.text,self.phoneTextField.text];
    //去空格
    NSString * temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * codeString = [temp stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"登录  URL：%@",codeString);
    [[ZLSecondAFNetworking sharedInstance] getWithURLString:codeString parameters:nil success:^(id responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"登录返回的信息：%@",dic);
        if ([dic[@"result"] isEqualToString:@"success"]) {
            [kUserDefaults setObject:dic[@"name"] forKey:ZB_USER_NAME];
            NSString * phoneStr = [weakSelf.phoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            [kUserDefaults setObject:phoneStr forKey:ZB_USER_PHONE];
            [kUserDefaults setObject:dic[@"mid"] forKey:ZB_USER_MID];
            //kUserDefaults setObject:di forKey:<#(nonnull NSString *)#>
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
            
        }
        [MBManager hideAlert];
    } failure:^(NSError *error) {
        NSLog(@"发送失败");
        [MBManager hideAlert];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
