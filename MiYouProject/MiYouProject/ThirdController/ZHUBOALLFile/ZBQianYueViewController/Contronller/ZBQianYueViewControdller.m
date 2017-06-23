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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.topItem.title=@"签约";
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

    if ([ZBALLModel isLogined]) {
        
        if ([self isCanFinish]) {
            [MBManager showBriefAlert:@"提交成功！"];

            [self startAFNetworking];
            self.nameTextField.text = @"";
            self.ageTextField.text = @"";
            self.weixinTextField.text = @"";
        }
        else{
            [MBManager showBriefAlert:@"请完善信息"];
        }

    }
    else{
        [ZBALLModel pushToLoginViewControllerFromVC:self];
    }
}

- (BOOL)isCanFinish{

    BOOL result;
    if (![self.nameTextField.text isEqualToString:@""] && ![self.ageTextField.text isEqualToString:@""] && ![self.weixinTextField.text isEqualToString:@""]) {
        if (self.manButton.isSelected==YES || self.womanButton.isSelected == YES) {
            result = YES;
        }
        else{
            result = NO;
        }
    }else{
        result = NO;
    }
    
    return result;
}

- (void)startAFNetworking{
    NSString * sex = _isMan?@"1":@"2";
    //__weak typeof(self) weakSelf = self;
    NSString * url = [NSString stringWithFormat:@"%@?action=sign&nickname=%@&age=%@&weixin=%@&sex=%@",URL_Common_ios,self.nameTextField.text,self.ageTextField.text,self.weixinTextField.text,sex];
    NSLog(@"提交签约：%@",url);
    [[ZLSecondAFNetworking sharedInstance] getWithURLString:url parameters:nil success:^(id responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"result"] isEqualToString:@"success"]) {

        }
    } failure:^(NSError *error) {
        
    }];
    
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
