//
//  ZhuBoBuyVIPAlertView.h
//  MiYouProject
//
//  Created by wkj on 2017/5/27.
//  Copyright © 2017年 junhong. All rights reserved.
//

typedef NS_ENUM(NSUInteger, PayType_ENUM) {
    WEIXINPAY_TYPE,
    ZHIFUBAOPAY_TYPE
};

#import <UIKit/UIKit.h>
#import "ZLAlertVIew02.h"

typedef void(^PayActionTypeBlock)(BOOL success, NSInteger Paytype,NSInteger CommodityType);



@interface ZhuBoBuyVIPAlertView : UIView<CustomIOSAlertViewDelegate>

@property (copy, nonatomic) PayActionTypeBlock typeBlock;
@property (strong, nonatomic)CustomIOSAlertView * alertView;
@property (strong, nonatomic) ZLAlertVIew02 * demoview;
@property (assign, nonatomic) PayType_ENUM currentPayType;

- (void)setPlayActionTypeBlockAction:(PayActionTypeBlock )block;

- (void)showCustomAlertView;
- (void)hideCustomeAlertView;


@end
