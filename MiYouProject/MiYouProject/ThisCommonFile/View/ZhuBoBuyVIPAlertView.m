//
//  ZhuBoBuyVIPAlertView.m
//  MiYouProject
//
//  Created by wkj on 2017/5/27.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import "ZhuBoBuyVIPAlertView.h"

@implementation ZhuBoBuyVIPAlertView{

    
    NSInteger  _currentCtype;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)showCustomAlertView{
    
    
    self.alertView = [[CustomIOSAlertView alloc] init];
    
    // Add some custom content to the alert view
    [self.alertView setContainerView:[self createDemoView]];
    
    // Modify the parameters
    //[self.alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Close1", @"Close2", @"Close3", nil]];
    [self.alertView setButtonTitles:nil];
    [self.alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [self.alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    
    [self.alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [self.alertView show];
    
}

- (void)hideCustomeAlertView{
    [self.alertView close];
    
}

#pragma mark 自定义AlertController 代理方法
//自定义弹出框
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    [alertView close];
}

- (UIView *)createDemoView
{
    self.demoview = (ZLAlertVIew02 *)[[NSBundle mainBundle]loadNibNamed:@"ZLAlertView02" owner:self options:nil][0];

    [self.demoview.beWeiXinButton addTarget:self action:@selector(beWeiXinButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.demoview.beVIPButton addTarget:self action:@selector(beVIPButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.demoview.weiXinTypeButton addTarget:self action:@selector(weixinType:) forControlEvents:UIControlEventTouchUpInside];
    [self.demoview.zhiFuBaoTypeButton addTarget:self action:@selector(zhifubaoType:) forControlEvents:UIControlEventTouchUpInside];
    [self.demoview.closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.demoview.beWeiXinButton.layer.cornerRadius = 5.0f;
    self.demoview.beWeiXinButton.layer.masksToBounds = YES;//设置边框可见
    self.demoview.beWeiXinButton.layer.borderWidth = 1.0f;
    self.demoview.beWeiXinButton.layer.borderColor = [UIColor colorWithhex16stringToColor:Main_BackgroundColor].CGColor;
    
    self.demoview.beVIPButton.layer.cornerRadius = 5.0f;
    self.demoview.beVIPButton.layer.masksToBounds = YES;//设置边框可见
    self.demoview.beVIPButton.layer.borderWidth = 1.0f;
    self.demoview.beVIPButton.layer.borderColor = [UIColor colorWithhex16stringToColor:Main_BackgroundColor].CGColor;
    
    if (self.currentPayType == WEIXINPAY_TYPE) {
        self.demoview.weiXinTitleLabel.textColor = [UIColor colorWithhex16stringToColor:Main_BackgroundColor];
        self.demoview.weiXinSubTitleLabel.textColor = [UIColor colorWithhex16stringToColor:Main_BackgroundColor];
        self.demoview.weiXinRightLabel.textColor = [UIColor colorWithhex16stringToColor:Main_BackgroundColor];
        [self.demoview.weiXinLabelImage setImage:[UIImage imageNamed:@"+zhuboweix"]];
        
        [self.demoview.vipLeftImage setImage:[UIImage imageNamed:@"chengweiVIPbuliang"]];
        self.demoview.titleLabel.textColor = [UIColor colorWithhex16stringToColor:Main_grayBackgroundColor];
        self.demoview.subTitleLabel.textColor = [UIColor colorWithhex16stringToColor:Main_grayBackgroundColor];
        self.demoview.rightLabel.textColor = [UIColor colorWithhex16stringToColor:Main_grayBackgroundColor];
    }
    else{
        [self.demoview.vipLeftImage setImage:[UIImage imageNamed:@"jinluzhibojian"]];
        self.demoview.titleLabel.textColor = [UIColor colorWithhex16stringToColor:Main_BackgroundColor];
        self.demoview.subTitleLabel.textColor = [UIColor colorWithhex16stringToColor:Main_BackgroundColor];
        self.demoview.rightLabel.textColor = [UIColor colorWithhex16stringToColor:Main_BackgroundColor];
        
        
        self.demoview.weiXinTitleLabel.textColor = [UIColor colorWithhex16stringToColor:Main_grayBackgroundColor];
        self.demoview.weiXinSubTitleLabel.textColor = [UIColor colorWithhex16stringToColor:Main_grayBackgroundColor];
        self.demoview.weiXinRightLabel.textColor = [UIColor colorWithhex16stringToColor:Main_grayBackgroundColor];
        [self.demoview.weiXinLabelImage setImage:[UIImage imageNamed:@"jiazhuboweixbuliang"]];
        
    }
    
    
    return self.demoview;
}


- (void)closeButtonAction:(UIButton *)sender{
    
    [self.alertView close];

}

- (void)beWeiXinButtonAction:(UIControl *)sender{
    
    if (sender.isSelected == NO) {
        self.demoview.weiXinTitleLabel.textColor = [UIColor colorWithhex16stringToColor:Main_BackgroundColor];
        self.demoview.weiXinSubTitleLabel.textColor = [UIColor colorWithhex16stringToColor:Main_BackgroundColor];
        self.demoview.weiXinRightLabel.textColor = [UIColor colorWithhex16stringToColor:Main_BackgroundColor];
        [self.demoview.weiXinLabelImage setImage:[UIImage imageNamed:@"+zhuboweix"]];
        
        [self.demoview.vipLeftImage setImage:[UIImage imageNamed:@"chengweiVIPbuliang"]];
        self.demoview.titleLabel.textColor = [UIColor colorWithhex16stringToColor:Main_grayBackgroundColor];
        self.demoview.subTitleLabel.textColor = [UIColor colorWithhex16stringToColor:Main_grayBackgroundColor];
        self.demoview.rightLabel.textColor = [UIColor colorWithhex16stringToColor:Main_grayBackgroundColor];
        
        
        _currentCtype = 2;
    }else{

        
    
    }
    
}

- (void)beVIPButtonAction:(UIControl *)sender{
    
    if (sender.isSelected == NO) {
        
        [self.demoview.vipLeftImage setImage:[UIImage imageNamed:@"jinluzhibojian"]];
        self.demoview.titleLabel.textColor = [UIColor colorWithhex16stringToColor:Main_BackgroundColor];
        self.demoview.subTitleLabel.textColor = [UIColor colorWithhex16stringToColor:Main_BackgroundColor];
        self.demoview.rightLabel.textColor = [UIColor colorWithhex16stringToColor:Main_BackgroundColor];
        
        
        self.demoview.weiXinTitleLabel.textColor = [UIColor colorWithhex16stringToColor:Main_grayBackgroundColor];
        self.demoview.weiXinSubTitleLabel.textColor = [UIColor colorWithhex16stringToColor:Main_grayBackgroundColor];
        self.demoview.weiXinRightLabel.textColor = [UIColor colorWithhex16stringToColor:Main_grayBackgroundColor];
        [self.demoview.weiXinLabelImage setImage:[UIImage imageNamed:@"jiazhuboweixbuliang"]];
        
        _currentCtype = 1;
        
    }else{
        
        
    }
    
    
}


- (void)changerVIPColorWith:(UIControl *)sender{

}


- (void)weixinType:(id)sender{
    self.typeBlock(YES, 0, _currentCtype);
}

- (void)zhifubaoType:(id)sender{

    self.typeBlock(YES, 1, _currentCtype);

}



- (void)setPlayActionTypeBlockAction:(PayActionTypeBlock)block{
    self.typeBlock = block;
}

@end
