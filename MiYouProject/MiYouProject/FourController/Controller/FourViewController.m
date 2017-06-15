//
//  FourViewController.m
//  MiYouProject
//
//  Created by wkj on 2017/3/8.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import "FourViewController.h"


@interface FourViewController (){

    
    CGFloat _index_0_height;//295.0/675.0
    CGFloat _index_1_height;
    CGFloat _index_2_height;

}

@end

static int jd;

@implementation FourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabBarImageAndTextColor];//设置Tabbar 文字和颜色
    
    //NSDictionary * memDic = [[NSUserDefaults standardUserDefaults] objectForKey:MEMBER_INFO_DIC];
    //self.userInfoModel = [MTLJSONAdapter modelOfClass:[UserInfoMTLModel class] fromJSONDictionary:memDic error:nil];
    
    _index_0_height = SIZE_WIDTH*(295.0/675.0);
    _index_1_height = SIZE_WIDTH*(50.0/325.0);
    [self loadTableview];
    
    __weak typeof(self) weakSelf = self;
    [self xw_addNotificationForName:HEAD_IMAGEVIEW_UPDATA_NOTIFICATION block:^(NSNotification * _Nonnull notification) {
        [weakSelf.headImageView setImage:notification.userInfo[@"head"]];
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    jd = 1;//加载会员图片 时判断
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    if ([ZBALLModel isLogined]) {
        [self startAFNetworking];
    }
    else{
        [self.tableView reloadData];
    }

}

- (void)startAFNetworking{
    //&action=memberCenter&id=1
    [MBManager showLoadingInView:self.view];
    /*
     "member":{
     "id":1,
     "name":"\u5f20\u4e09",
     "password":"123456",
     “group”:0,
     }
     */
    __weak typeof(self) weakSelf = self;
    NSString * urlstring = [NSString stringWithFormat:@"%@?action=memberCenter&id=%@",URL_Common_ios,[kUserDefaults objectForKey:ZB_USER_MID]];//,self.userInfoModel.id];
    NSLog(@"用户中心请求的链接为：%@",urlstring);
    [[ZLSecondAFNetworking sharedInstance] getWithURLString:urlstring parameters:nil success:^(id responseObject) {
        NSDictionary *  dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"用户中心请求的数据为：%@",dic);
        if ([dic[@"result"] isEqualToString:@"success"]) {
            weakSelf.currentZBMemberModel = [MTLJSONAdapter modelOfClass:[ZBMemberMTLModel class] fromJSONDictionary:dic error:nil];
            [kUserDefaults setObject:dic[@"avator"] forKey:ZB_USER_HEADERIMAGE_URL];
//            [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"amount"] forKey:MEMBER_POINTS_NUM];
//            [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"vip"] forKey:MEMBER_VIP_LEVEL];
            if (!zlObjectIsEmpty(dic[@"vip"])) {
                [kUserDefaults setObject:dic[@"vip"] forKey:ZB_USER_IS_VIP];
            }    
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
           [weakSelf.tableView reloadData];
        });
        [MBManager hideAlert];
        [MBManager hideAlert];
        [MBManager hideAlert];
    } failure:^(NSError *error){
        [MBManager hideAlert];
         [MBManager showBriefAlert:@"加载失败"];
    }];
   
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
}
- (void)loadTableview{

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT-49.0) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor colorWithhex16stringToColor:Main_grayBackgroundColor];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZBFourTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZBFoursCellID"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonHederTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HeadCellID"];
    
}
#pragma mark TableviewDelegate方法
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1.0f;

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num;
    if (section == 0) {
        num = 6;
    }
    else{
        num = 0;
    }
    return num;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0f;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            height = _index_0_height;
        }
        else if (indexPath.row == 1){
            height = 66.0f;
        }
        else{
            height = 66.0f;
        }
    }
    else{
        
        height = 80.0f;
    }

    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell;
    if (indexPath.section == 0) {
        static NSString * cellID = @"PersonCenterCellID";
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.backgroundColor = [UIColor redColor];
        if (indexPath.row == 0) {
            static NSString * headerCellID = @"HeadCellID";
            PersonHederTableViewCell* hcell = (PersonHederTableViewCell *)[tableView dequeueReusableCellWithIdentifier:headerCellID];
            if (!hcell) {
                hcell = (PersonHederTableViewCell *)[[NSBundle mainBundle] loadNibNamed:@"PersonHederTableViewCell" owner:self options:nil][0];
            }
            if ([ZBALLModel isLogined]) {
                hcell.userNameLabel.text = self.currentZBMemberModel.name;
                [hcell.headerImageVIew setImageWithURL:[NSURL URLWithString:[kUserDefaults objectForKey:ZB_USER_HEADERIMAGE_URL]] placeholder:[UIImage imageNamed:@"touxiang"]];
//                UIImage * image = [self readHeadImageFromUserDefault];
//                if (!zlObjectIsEmpty(image)) {
//                    [hcell.headerImageVIew setImage:image];
//                }
            }
            else{
                hcell.userNameLabel.text = @"登录";
                [hcell.headerImageVIew setImage:[UIImage imageNamed:@"touxiang"]];
            }
            
            //hcell.UBiNumLabel.text = [NSString stringWithFormat:@"%d",[self.currentZBMemberModel.amount intValue]];

            
            //        //设置圆角
            //        cellhead.headerImageVIew.layer.cornerRadius = cellhead.imageView.frame.size.width / 2;
            //        //将多余的部分切掉
            //        cellhead.headerImageVIew.layer.masksToBounds = YES;
            self.headImageView = hcell.headerImageVIew;
            
            if ([ZBALLModel isLogined] && [ZBALLModel isZBVIP]) {
                hcell.kaiTongVIPButton.hidden = YES;
            }

            
            [hcell.kaiTongVIPButton addTarget:self action:@selector(kaitongVIPButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            cell = hcell;
        }
        else if (indexPath.row == 1){
            //  325/50  ButtonsCellID
            
            static NSString * cellID1 = @"ZBFoursCellID";
            ZBFourTableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:cellID1];
            if (!cell1) {
                cell1 = [[NSBundle mainBundle]loadNibNamed:@"ZBFourTableViewCell" owner:self options:nil][0];
            }
            
            cell = cell1;
        }
        else if (indexPath.row == 2){
            
            static NSString * cellID1 = @"ZBFoursCellID";
            ZBFourTableViewCell * cell1 = [tableView dequeueReusableCellWithIdentifier:cellID1];
            if (!cell1) {
                cell1 = [[NSBundle mainBundle]loadNibNamed:@"ZBFourTableViewCell" owner:self options:nil][0];
            }
            
            cell1.biaoTiLabel.text = @"清空缓存";
            [cell1.leftImageView setImage:[UIImage imageNamed:@"qingkonghuancun"]];
            float tmpSize = [[SDImageCache sharedImageCache] getSize] / 1024.0 /1024.0;
            NSLog(@"缓存的大小：%ld",[[SDImageCache sharedImageCache] getSize]);
            cell1.rightLabel.text = [NSString stringWithFormat:@"%.2fM",tmpSize];
            if (tmpSize > 0) {
                cell1.rightLabel.hidden = NO;
            }
            else{
                cell1.rightLabel.hidden = YES;
            }
            
            cell = cell1;
            
        }
        else if (indexPath.row == 3){
            static NSString * buttonCellID = @"ZBFoursCellID";
            ZBFourTableViewCell * fcell = (ZBFourTableViewCell *)[tableView dequeueReusableCellWithIdentifier:buttonCellID];
            if (!fcell) {
                fcell = (ZBFourTableViewCell *)[[NSBundle mainBundle] loadNibNamed:@"ZBFourTableViewCell" owner:self options:nil][0];
            }
            
            [fcell.leftImageView setImage:[UIImage imageNamed:@"yijianfankui-1"]];
            fcell.biaoTiLabel.text = @"意见反馈";
            
            
            cell = fcell;
        }
        else if (indexPath.row == 4){
            static NSString * buttonCellID = @"ZBFoursCellID";
            ZBFourTableViewCell * fcell = (ZBFourTableViewCell *)[tableView dequeueReusableCellWithIdentifier:buttonCellID];
            if (!fcell) {
                fcell = (ZBFourTableViewCell *)[[NSBundle mainBundle] loadNibNamed:@"ZBFourTableViewCell" owner:self options:nil][0];
            }
            
            [fcell.leftImageView setImage:[UIImage imageNamed:@"guanyuwomen"]];
            fcell.biaoTiLabel.text = @"关于我们";
            
            
            cell = fcell;
        }
        else if (indexPath.row == 5){
            static NSString * buttonCellID = @"ZBFoursCellID";
            ZBFourTableViewCell * fcell = (ZBFourTableViewCell *)[tableView dequeueReusableCellWithIdentifier:buttonCellID];
            if (!fcell) {
                fcell = (ZBFourTableViewCell *)[[NSBundle mainBundle] loadNibNamed:@"ZBFourTableViewCell" owner:self options:nil][0];
            }
            
            [fcell.leftImageView setImage:[UIImage imageNamed:@"mianzeshengming-1"]];
            fcell.biaoTiLabel.text = @"免责声明";
            
            
            cell = fcell;
        }
   
    }
    else{
        static NSString * groupID = @"groupCellID2";
        cell = [tableView dequeueReusableCellWithIdentifier:groupID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:groupID];
        }
        UIImageView * imageView = [UIImageView new];
    
        [imageView setImageWithURL:[NSURL URLWithString:@""] placeholder:[UIImage imageNamed:@"icon_default2"]];
        
        [cell.contentView addSubview:imageView];
     
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.with.right.with.top.with.bottom.equalTo(cell.contentView);
            
        }];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了");
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            YiJianViewController * vc = [[YiJianViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 1) {
            if (![ZBALLModel isLogined]) {
                [ZBALLModel pushToLoginViewControllerFromVC:self];
            }
            else{
                
                XiaoXiViewController * vc = [[XiaoXiViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }

        }
        if (indexPath.row == 2) {
            [self clearTmpPics];
        }
        if (indexPath.row == 0) {
            if (![ZBALLModel isLogined]) {
                [ZBALLModel pushToLoginViewControllerFromVC:self];
            }
            else{
                PersonInfoViewController * vc = [[PersonInfoViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }

        }
        if (indexPath.row == 4) {
            GuanYuUSViewController * vc = [[GuanYuUSViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 5) {
            AboutUSViewController * vc = [[AboutUSViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else{
        
    }


    
}

#pragma end mark
//三个按钮组的执行方法
- (void)firstButtonAction:(UIControl *)sender{
    NSLog(@"执行了消息按钮");
   
    
}
- (void)secondButtonAction:(UIControl *)sender{
    NSLog(@"执行了充值UB按钮");
    ChongZhiViewController * VC = [[ChongZhiViewController alloc]init];
    VC.UB_or_VIP = UB_ChongZhi;
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)thirdButtonAction:(UIControl *)sender{
    NSLog(@"执行了VIP按钮");
    ChongZhiViewController * VC = [[ChongZhiViewController alloc]init];
    VC.UB_or_VIP = VIP_ChongZhi;
    [self.navigationController pushViewController:VC animated:YES];
}
//读取本地 图片
- (UIImage *)readHeadImageFromUserDefault{
    UIImage *image;
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserHeaderImage"];
    image = [UIImage imageWithData:data];
    return  image;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//清除缓存
- (void)clearTmpPics
{
    
    //NSString *clearCacheSizeStr = tmpSize >= 1 ? [NSString stringWithFormat:@"清理缓存(%.2fM)",tmpSize] : [NSString stringWithFormat:@"清理缓存(%.2fK)",tmpSize * 1024];
    
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        NSLog(@"硬盘清理成功");
    }];
    [self.tableView reloadData];
    [MBManager showBriefAlert:@"清除成功！"];

}
//开通VIP
- (void)kaitongVIPButtonAction:(UIButton *)sender{
    
    [self.tabBarController setSelectedIndex:1];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
