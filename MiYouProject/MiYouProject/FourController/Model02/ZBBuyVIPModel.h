//
//  ZBBuyVIPModel.h
//  MiYouProject
//
//  Created by wkj on 2017/6/2.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, VipORWeiXin_ENUM) {
    VIP_TYPE_ENUM,
    WEIXIN_TYPE_ENUM,
};

@interface ZBBuyVIPModel : NSObject

@property (assign, nonatomic)VipORWeiXin_ENUM currentTypeEnum;


+ (instancetype)shareBuyVIPModel;
- (void)loadDingDanInfoWithFirstType:(NSString *)type withZBID:(NSString *)zid withVIPorWeiXin:(VipORWeiXin_ENUM) vipOrWxEnum;
- (void)getPayResultWithOorderNum:(NSString *)orderNum withBlock:(void (^)(BOOL result))resultBlock;

@end
