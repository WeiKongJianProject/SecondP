//
//  AppDelegate+ZLAPPDelegate.m
//  MiYouProject
//
//  Created by wkj on 2017/6/14.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import "AppDelegate+ZLAPPDelegate.h"

@implementation AppDelegate (ZLAPPDelegate)

#pragma mark ===================第一次安装==================
- (void)firstDownLoadStartAFNetworking{
    NSString * url = [NSString stringWithFormat:@"%@?action=install&channel=%@",URL_Common_ios,CHANNEL_ID];
    NSLog(@"首次按安装：%@",url);
    [[ZLSecondAFNetworking sharedInstance] getWithURLString:url parameters:nil success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}


@end
