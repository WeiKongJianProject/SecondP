//
//  ZBVIPsViewController.h
//  MiYouProject
//
//  Created by wkj on 2017/5/31.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import "ZLBaseViewController.h"
#import "ZBBuyVIPModel.h"
#import "FWInterface.h"

@interface ZBVIPsViewController : ZLBaseViewController<FWInterfaceDelegate>
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@end
