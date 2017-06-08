//
//  ZBHomeModel.m
//  MiYouProject
//
//  Created by wkj on 2017/5/18.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import "ZBHomeModel.h"

@implementation ZBHomeModel

+ (NSDictionary * )JSONKeyPathsByPropertyKey{
    
    return @{
             @"zid":@"zid",
             @"nickname":@"nickname",
             @"thumb":@"thumb",
             @"hot":@"hot"
             };

}

@end

@implementation ZBHomeBannerModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"pic":@"pic",
             @"title":@"title",
             @"nickname":@"nickname",
             @"zid":@"zid"
             };

}

@end

@implementation ZBMeiNvMTLModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"weixin":@"weixin",
             @"nickname":@"nickname",
             @"avator":@"avator",
             @"thumb":@"thumb",
             @"hot":@"hot",
             @"video":@"video",
             @"zid":@"zid",
             @"price":@"price"
             };

}

@end

@implementation ZBVideoCellModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"nid":@"nid",
             @"video":@"video",
             @"pic":@"pic",
             @"price":@"price"
             };
}

@end


