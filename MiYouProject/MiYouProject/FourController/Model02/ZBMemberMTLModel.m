//
//  ZBMemberMTLModel.m
//  MiYouProject
//
//  Created by wkj on 2017/5/19.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import "ZBMemberMTLModel.h"

@implementation ZBMemberMTLModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return @{
             @"amount":@"amount",
             @"id":@"id",
             @"name":@"name",
             @"vip":@"vip",
             @"vipName":@"vipName",
             @"messageNum":@"messageNum",
             @"result":@"result",
             @"avator":@"avator"
             };

}

@end
