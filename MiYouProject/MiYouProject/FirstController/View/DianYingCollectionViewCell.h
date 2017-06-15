//
//  DianYingCollectionViewCell.h
//  MiYouProject
//
//  Created by wkj on 2017/3/10.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DianYingCollectionViewCell : UICollectionViewCell


@property (strong, nonatomic) IBOutlet UIImageView *minImageView;
@property (strong, nonatomic) IBOutlet UILabel *dianYingNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *boFangBtn;
@property (strong, nonatomic) IBOutlet UILabel *zuoShangLabel;
@property (strong, nonatomic) IBOutlet UIImageView *zuoShangImage;
@property (strong, nonatomic) IBOutlet UILabel *hotNumLabel;


@end
