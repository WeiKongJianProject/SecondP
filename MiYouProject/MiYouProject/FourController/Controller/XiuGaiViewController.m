//
//  XiuGaiViewController.m
//  MiYouProject
//
//  Created by wkj on 2017/6/7.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import "XiuGaiViewController.h"

@interface XiuGaiViewController ()

@end

@implementation XiuGaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改用户名";
    self.nameField.text = self.name;
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)finishButtonAction:(UIButton *)sender {
    
    if (self.nameField.text != nil && ![self.nameField.text isEqualToString:@""]) {
        [self startAFNetworkingWithName:self.nameField.text];
    }
    
}

- (void)startAFNetworkingWithName:(NSString *)name{
    __weak typeof(self) weakSelf = self;
    NSString * mid = [kUserDefaults objectForKey:ZB_USER_MID];
    NSString * str = [NSString stringWithFormat:@"%@?action=changename&mid=%@&name=%@",URL_Common_ios,mid,name];
    //NSLog(@"修改头像：%@",str);
    [[ZLSecondAFNetworking sharedInstance] getWithURLString:str parameters:nil success:^(id responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"result"] isEqualToString:@"success"]) {
            [kUserDefaults setObject:name forKey:ZB_USER_NAME];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
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
