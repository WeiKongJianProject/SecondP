//
//  ZBLoginViewController.h
//  MiYouProject
//
//  Created by wkj on 2017/6/1.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import "ZLBaseViewController.h"
#import "WTTextField.h"
@interface ZBLoginViewController : ZLBaseViewController

@property (strong, nonatomic) IBOutlet WTTextField *phoneTextField;
@property (strong, nonatomic) IBOutlet WTTextField *codeTextField;
@property (strong, nonatomic) IBOutlet UIButton *codeButton;

@property (strong, nonatomic) IBOutlet UIButton *timeButtonLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (strong, nonatomic) IBOutlet UIButton *backButton;




@end
