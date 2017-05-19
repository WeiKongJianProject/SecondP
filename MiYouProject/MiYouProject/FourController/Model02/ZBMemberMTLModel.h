//
//  ZBMemberMTLModel.h
//  MiYouProject
//
//  Created by wkj on 2017/5/19.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ZBMemberMTLModel : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSNumber * amount;
@property (strong, nonatomic) NSString * id;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * vip;
@property (strong, nonatomic) NSString * vipName;
@property (strong, nonatomic) NSNumber * messageNum;
@property (strong, nonatomic) NSString * result;


@end
