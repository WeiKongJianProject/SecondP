//
//  ZBALLModel.h
//  MiYouProject
//
//  Created by wkj on 2017/6/1.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBALLModel : NSObject

//创建单利

/**
 创建单例

 @return 
 */
+ (instancetype )shareALLModel;

//判断是否是VIP
+ (BOOL)isZBVIP;
//判断是否登录
+ (BOOL)isLogined;

+ (void)pushToLoginViewControllerFromVC:(UIViewController *)viewController;



@end
