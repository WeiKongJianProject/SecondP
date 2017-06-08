//
//  PersonInfoViewController.h
//  MiYouProject
//
//  Created by wkj on 2017/3/14.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import "ZLBaseViewController.h"
#import "PersonTableViewCell.h"
#import "KZPhotoManager.h"
#import "XiuGaiViewController.h"

@interface PersonInfoViewController : ZLBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIImageView * headImageView;
@end
