//
//  ZLAlertVIew02.h
//  MiYouProject
//
//  Created by wkj on 2017/5/27.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLAlertVIew02 : UIView

@property (strong, nonatomic) IBOutlet UIButton *closeButton;



@property (strong, nonatomic) IBOutlet UIControl *beVIPButton;
@property (strong, nonatomic) IBOutlet UIImageView *vipLeftImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightLabel;

@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;


@property (strong, nonatomic) IBOutlet UIControl *beWeiXinButton;

@property (strong, nonatomic) IBOutlet UIImageView *weiXinLabelImage;

@property (strong, nonatomic) IBOutlet UILabel *weiXinTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *weiXinSubTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *weiXinRightLabel;


@property (strong, nonatomic) IBOutlet UIButton *weiXinTypeButton;
@property (strong, nonatomic) IBOutlet UIButton *zhiFuBaoTypeButton;



@end
