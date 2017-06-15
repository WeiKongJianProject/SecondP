//
//  ZBXiaoXiZLModel.h
//  MiYouProject
//
//  Created by wkj on 2017/6/13.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ZBXiaoXiZLModel : MTLModel<MTLJSONSerializing>

@property (strong, nonatomic) NSString * addtime;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * content;

@end
