//
//  ZBUserViewController.h
//  MiYouProject
//
//  Created by wkj on 2017/5/22.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import "ZLBaseViewController.h"

@interface ZBUserViewController : ZLBaseViewController<UITableViewDelegate,UITableViewDataSource>


@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
