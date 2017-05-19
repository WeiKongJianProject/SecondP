//
//  PingLunMTLModel.h
//  MiYouProject
//
//  Created by wkj on 2017/3/31.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface PingLunMTLModel : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString * cid;
@property (strong, nonatomic) NSString * content;
@property (strong, nonatomic) NSString * zid;
@property (strong, nonatomic) NSString * mid;
@property (strong, nonatomic) NSString * mname;
@property (strong, nonatomic) NSString * addtime;

@end
