//
//  ZBALLModel.m
//  MiYouProject
//
//  Created by wkj on 2017/6/1.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import "ZBALLModel.h"

@implementation ZBALLModel
//单例 写
static ZBALLModel * _instance = nil;
+ (instancetype)shareALLModel{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc] init];
        
    });
    
    return _instance;
}

//判断是否是VIP
+ (BOOL)isZBVIP{
    
    NSNumber * isVIP = [[NSUserDefaults standardUserDefaults]objectForKey:ZB_USER_IS_VIP];
    if ([isVIP intValue] == 1) {
        return YES;
    }
    else{
    
        return NO;
    }
    
    
}
//判断是否 登录
+ (BOOL)isLogined{
    
    NSString * isLogin = [[NSUserDefaults standardUserDefaults]objectForKey:ZB_USER_NAME];
    NSString * isID = [[NSUserDefaults standardUserDefaults] objectForKey:ZB_USER_MID];
    if (![isLogin isEqualToString:@""] && isLogin != nil && ![isID isEqualToString:@""] && isID != nil) {
        return YES;
    }
    else{
        
        return NO;
    }
    
}
//跳转到 登录控制器
+ (void)pushToLoginViewControllerFromVC:(UIViewController *)viewController{
    
    ZBLoginViewController * vc = [[ZBLoginViewController alloc]init];
    
    [viewController.navigationController pushViewController:vc animated:YES];

}


@end
