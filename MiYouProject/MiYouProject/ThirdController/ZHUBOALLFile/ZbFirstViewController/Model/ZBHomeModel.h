//
//  ZBHomeModel.h
//  MiYouProject
//
//  Created by wkj on 2017/5/18.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ZBHomeModel : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString * zid;
@property (strong, nonatomic) NSString * nickname;
@property (strong, nonatomic) NSString * hot;
@property (strong, nonatomic) NSString * thumb;

@end

@interface ZBHomeBannerModel : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString * pic;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * nickname;
@property (strong, nonatomic) NSString * zid;

@end

@interface ZBMeiNvMTLModel : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString * weixin;
@property (strong, nonatomic) NSString * nickname;
@property (strong, nonatomic) NSString * avator;
@property (strong, nonatomic) NSString * thumb;
@property (strong, nonatomic) NSString * hot;
@property (strong, nonatomic) NSString * video;
@property (strong, nonatomic) NSString * zid;
@property (strong, nonatomic) NSString * price;


@end

@interface ZBVideoCellModel : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString * nid;
@property (strong, nonatomic) NSString * video;
@property (strong, nonatomic) NSString * pic;
@property (strong, nonatomic) NSNumber * price;

@end
