//
//  PingLunMTLModel.m
//  MiYouProject
//
//  Created by wkj on 2017/3/31.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import "PingLunMTLModel.h"

@implementation PingLunMTLModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{

    return @{
             @"cid":@"cid",
             @"content":@"content",
             @"zid":@"zid",
             @"mid":@"mid",
             @"mname":@"mname",
             @"addtime":@"addtime"
             };
    
}

@end
