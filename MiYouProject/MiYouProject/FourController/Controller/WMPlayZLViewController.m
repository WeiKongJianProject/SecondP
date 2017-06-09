//
//  WMPlayZLViewController.m
//  MiYouProject
//
//  Created by wkj on 2017/4/5.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import "WMPlayZLViewController.h"

#define COLLECTION_CELL_WIDTH (SIZE_WIDTH-50)/4.0
#define COLLECTION_CELL_HEIGHT  70.0

@interface WMPlayZLViewController ()<WMPlayerDelegate>{
    
    //WMPlayer  *wmPlayer;
    CGRect     playerFrame;
    BOOL isHiddenStatusBar;//记录状态的隐藏显示
    BOOL _isHaveWeiXin;
    BOOL _isCanToRoom;
    NSString * _zbWeiXin;
    NSString * _zbroom;
    
    NSString * _weixinPrice;
    NSString * _vipPrice;
    NSString * _vipLevel;
    
}

@end

static int _currentPage;

@implementation WMPlayZLViewController


#pragma mark viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    _currentPage = 1;
    
    self.pingLunTableVIew.delegate = self;
    self.pingLunTableVIew.dataSource = self;
    self.pingLunTableVIew.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.pingLunTableVIew.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerShuaXin)];
    [self loadCollectionView];
    
    
    playerFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.width)* 9 / 16);
    [self.XiaZaiButton addTarget:self action:@selector(alertXiaZaiButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.tiJiaoButton addTarget:self action:@selector(tiJiaoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //支付完成后通知
    [self xw_addNotificationForName:ZB_USER_PAY_FINISHED_NF block:^(NSNotification * _Nonnull notification) {
        NSString * str = notification.userInfo[@"result"];
        if ([str isEqualToString:@"1"]) {
            [self startAFNetworkingWithID:self.id];
        }
        NSLog(@"接受到支付成功后的通知");
    }];
    
}

- (void)tiJiaoButtonAction:(UIButton *)sender{
    
    [self.textFieldView resignFirstResponder];
    /*
     AlertViewCustomZL  * alert = [[AlertViewCustomZL alloc]init];
     
     alert.titleName = @"观看完整版才可以评论";
     alert.cancelBtnTitle = @"取消";
     alert.okBtnTitle = @"确定";
     [alert showCustomAlertView];
     [alert cancelBlockAction:^(BOOL success) {
     //_isKuaiJinAction = 0;
     [alert hideCustomeAlertView];
     }];
     [alert okButtonBlockAction:^(BOOL success) {
     //_isKuaiJinAction = 0;
     [alert hideCustomeAlertView];
     //        [weakSelf.navigationController popViewControllerAnimated:NO];
     //        [weakSelf xw_postNotificationWithName:KAITONG_VIP_NOTIFICATION userInfo:nil];
     [self.textFieldView resignFirstResponder];
     }];
     [self.view addSubview:alert];
     */
    
    [self startFaBuAFNetWorkingWithid:[self.id intValue]];
    
}

- (void)startFaBuAFNetWorkingWithid:(NSInteger )ids{
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary * memInfo = [[NSUserDefaults standardUserDefaults] objectForKey:MEMBER_INFO_DIC];
    NSString * mid = [memInfo objectForKey:@"id"];
    
    NSString * url = [NSString stringWithFormat:@"%@?action=zhubo&zid=%ld&mid=%d&content=%@&behavior=comment",URL_Common_ios,ids,1,self.textFieldView.text];
    //NSString * url02 = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"发布评论的链接为：%@",url02);
    NSString * codeString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"发布评论的链接为：%@",codeString);
    [[ZLSecondAFNetworking sharedInstance] getWithURLString:codeString parameters:nil success:^(id responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"result"] isEqualToString:@"success"]) {
            
            [MBManager showBriefAlert:dic[@"message"]];
            weakSelf.textFieldView.text = @"";
            
        }
        else{
            [MBManager showBriefAlert:dic[@"message"]];
        }
        
        
    } failure:^(NSError *error) {
        [MBManager showBriefAlert:@"评论失败"];
    }];
    
    
}

#pragma mark zl添加 START
- (void)footerShuaXin{
    _currentPage++;
    [self startPingLunAFNetworkingWithID:self.id withPage:_currentPage];
}


#pragma mark 网络请求

//播放页请求 视频数据
- (void)startAFNetworkingWithID:(NSString *)keyID{
    [MBManager showLoadingInView:self.view];
    NSString * urlstr = nil;
    
    if ([ZBALLModel isLogined]) {
        NSString * midStr = [kUserDefaults objectForKey:ZB_USER_MID];
        urlstr = [NSString stringWithFormat:@"%@?action=zhubo&zid=%@&mid=%@",URL_Common_ios,keyID,midStr];
    }
    else{
        urlstr = [NSString stringWithFormat:@"%@?action=zhubo&zid=%@",URL_Common_ios,keyID];
    }
    __weak typeof(self) weakSelf = self;
    //play
    
    NSLog(@"播放页请求的链接为：%@",urlstr);
    [[ZLSecondAFNetworking sharedInstance]getWithURLString:urlstr parameters:nil success:^(id responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //[MTLJSONAdapter modelOfClass:[PlayVideoMTLModel class] fromJSONDictionary:dic error:nil];
        if ([dic[@"result"] isEqualToString:@"success"]) {
            weakSelf.currentZBModel = (ZBMeiNvMTLModel *)[MTLJSONAdapter modelOfClass:[ZBMeiNvMTLModel class] fromJSONDictionary:dic[@"zhubo"] error:nil];
            _isHaveWeiXin = [dic[@"showWeixin"] boolValue];
            _isCanToRoom = [dic[@"showRoom"] boolValue];
            _zbWeiXin = dic[@"zhubo"][@"weixin"];
            _weixinPrice = dic[@"zhubo"][@"price"];
            _vipPrice = dic[@"vip"][@"price"];
            _vipLevel = [NSString stringWithFormat:@"%d",[dic[@"vip"][@"level"] intValue]];
            _zbroom = dic[@"room"];
            weakSelf.collectionARR = [MTLJSONAdapter modelsOfClass:[ZBVideoCellModel class] fromJSONArray:dic[@"video"] error:nil];
            [weakSelf.collectionView reloadData];
            //weakSelf.playMemberModel = [MTLJSONAdapter modelOfClass:[PlayMemberMTLModel class] fromJSONDictionary:dic[@"member"] error:nil];
            //NSString * str = [dic objectForKey:@"actor"];
            //NSLog(@"播放页请求的结果为：%@++++全部结果为：%@",weakSelf.playModel.pic,dic);
            //[weakSelf settingPlayer];//加载播放器
            [MBManager hideAlert];
            //[weakSelf.tableView reloadData];
            [weakSelf PlayBoFangVideo];
        }
        else{
            [MBManager showBriefMessage:@"数据加载失败" InView:self.view];
        }
        
    } failure:^(NSError *error) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:@"请求失败"];
    }];
    
}

- (void)PlayBoFangVideo{
    
    self.boFangNumLabel.text = [NSString stringWithFormat:@"%d",[self.currentZBModel.hot intValue]];
    
    self.videoTitleLabel.text = self.currentZBModel.nickname;
    self.wmPlayer.URLString = self.currentZBModel.video;
    //@"http://www.w3cschool.cc/try/demo_source/mov_bbb.mp4";
    [self.wmPlayer play];
}

//播放页 请求评论
- (void)startPingLunAFNetworkingWithID:(NSString *)keyID withPage:(int)page{
    //[MBManager showLoadingInView:self.view];
    
    NSDictionary * userInfoDic = [[NSUserDefaults standardUserDefaults]objectForKey:MEMBER_INFO_DIC];
    NSString * userID = userInfoDic[@"id"];
    __weak typeof(self) weakSelf = self;
    //play
    NSString * urlstr = [NSString stringWithFormat:@"%@?action=zhubo&zid=%@&page=%d",URL_Common_ios,keyID,page];
    NSLog(@"评论的链接为：%@",urlstr);
    [[ZLSecondAFNetworking sharedInstance]getWithURLString:urlstr parameters:nil success:^(id responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //[MTLJSONAdapter modelOfClass:[PlayVideoMTLModel class] fromJSONDictionary:dic error:nil];
        if ([dic[@"result"] isEqualToString:@"success"]) {
            NSArray * arr01 = dic[@"comment"];
            if (!zlArrayIsEmpty(arr01)) {
                [self.tableViewARR addObjectsFromArray:[MTLJSONAdapter modelsOfClass:[PingLunMTLModel class] fromJSONArray:dic[@"comment"] error:nil]];
                [weakSelf.pingLunTableVIew reloadData];
            }
            [MBManager hideAlert];
        }
        else{
            [MBManager showBriefMessage:@"评论数据加载失败" InView:self.view];
        }
        
        [self.pingLunTableVIew.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self.pingLunTableVIew.mj_footer endRefreshing];
        [MBManager hideAlert];
        [MBManager showBriefAlert:@"评论请求失败"];
    }];
    
}


#pragma mark TableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableViewARR.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"PingLunCellID";
    PingLunTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = (PingLunTableViewCell *)[[NSBundle mainBundle] loadNibNamed:@"PingLunTableViewCell" owner:self options:nil][0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PingLunMTLModel * model = self.tableViewARR[indexPath.row];
    
    
    //[cell.headImageVIew sd_setImageWithURL:[NSURL URLWithString:model.avator] placeholderImage:PLACEHOLDER_IMAGE];
    [cell.headImageVIew setImage:[UIImage imageNamed:@"icon_default2"]];
    cell.nameLabel.text = model.mname;
    cell.contentLabel.text = model.content;
    
    //时间 时间戳设置
    //    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.time intValue]];
    //    //NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[confromTimesp timeIntervalSince1970]];
    //    //NSDate *date = [NSDate date];
    //    //创建一个时间格式化对象
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    //按照什么样的格式来格式化时间
    //    //formatter.dateFormat = @"yyyy年MM月dd日 HH时mm分ss秒 Z";
    //    formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    //    //formatter.dateFormat = @"MM-dd-yyyy HH-mm-ss";
    //    NSString *res = [formatter stringFromDate:confromTimesp];
    cell.timeLabel.text = model.addtime;
    //NSLog(@"评论的时间为：%@",res);
    return cell;
    
    
    
}

#pragma end mark
#pragma end mark  zl 添加结束

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(BOOL)prefersStatusBarHidden{
    if (isHiddenStatusBar) {//隐藏
        return YES;
    }
    return NO;
}
//视图控制器实现的方法
-(BOOL)shouldAutorotate{       //iOS6.0之后,要想让状态条可以旋转,必须设置视图不能自动旋转
    return NO;
}
// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
///播放器事件
-(void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn{
    if (wmplayer.isFullscreen) {
        [self toOrientation:UIInterfaceOrientationPortrait];
        self.wmPlayer.isFullscreen = NO;
        self.enablePanGesture = YES;
        
    }else{
        [self releaseWMPlayer];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
///播放暂停
-(void)wmplayer:(WMPlayer *)wmplayer clickedPlayOrPauseButton:(UIButton *)playOrPauseBtn{
    NSLog(@"clickedPlayOrPauseButton");
}
///全屏按钮
-(void)wmplayer:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn{
    if (self.wmPlayer.isFullscreen==YES) {//全屏
        [self toOrientation:UIInterfaceOrientationPortrait];
        self.wmPlayer.isFullscreen = NO;
        self.enablePanGesture = YES;
        
    }else{//非全屏
        [self toOrientation:UIInterfaceOrientationLandscapeRight];
        self.wmPlayer.isFullscreen = YES;
        self.enablePanGesture = NO;
    }
}
///单击播放器
-(void)wmplayer:(WMPlayer *)wmplayer singleTaped:(UITapGestureRecognizer *)singleTap{
    NSLog(@"didSingleTaped");
    //    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"测试" message:@"测试旋转屏" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    //    [alertView show];
    
    //    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"测试" message:@"测试旋转屏" preferredStyle:UIAlertControllerStyleAlert];
    //    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    //
    //    }]];
    //    [self presentViewController:alertVC animated:YES completion:^{
    //    }];
}
///双击播放器
-(void)wmplayer:(WMPlayer *)wmplayer doubleTaped:(UITapGestureRecognizer *)doubleTap{
    NSLog(@"didDoubleTaped");
}
///播放状态
-(void)wmplayerFailedPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    NSLog(@"wmplayerDidFailedPlay");
}
-(void)wmplayerReadyToPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    //    NSLog(@"wmplayerDidReadyToPlay");
}
-(void)wmplayerFinishedPlay:(WMPlayer *)wmplayer{
    NSLog(@"wmplayerDidFinishedPlay播放完成");
    if (self.wmPlayer.isFullscreen==YES) {//全屏
        [self toOrientation:UIInterfaceOrientationPortrait];
        self.wmPlayer.isFullscreen = NO;
        self.enablePanGesture = YES;
        
    }
    //    else{//非全屏
    //        [self toOrientation:UIInterfaceOrientationLandscapeRight];
    //        self.wmPlayer.isFullscreen = YES;
    //        self.enablePanGesture = NO;
    //    }
    if (![ZBALLModel isLogined]) {
        [ZBALLModel pushToLoginViewControllerFromVC:self];
    }
    else if(![ZBALLModel isZBVIP]){
        [self alertViewShow];
    }
    
}
//操作栏隐藏或者显示都会调用此方法
-(void)wmplayer:(WMPlayer *)wmplayer isHiddenTopAndBottomView:(BOOL)isHidden{
    isHiddenStatusBar = isHidden;
    [self setNeedsStatusBarAppearanceUpdate];
}
/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange:(NSNotification *)notification{
    if (self.wmPlayer==nil||self.wmPlayer.superview==nil){
        return;
    }
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
            self.wmPlayer.isFullscreen = NO;
            self.enablePanGesture = NO;
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            [self toOrientation:UIInterfaceOrientationPortrait];
            self.wmPlayer.isFullscreen = NO;
            self.enablePanGesture = YES;
            
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
            [self toOrientation:UIInterfaceOrientationLandscapeLeft];
            self.wmPlayer.isFullscreen = YES;
            self.enablePanGesture = NO;
            
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            [self toOrientation:UIInterfaceOrientationLandscapeRight];
            self.wmPlayer.isFullscreen = YES;
            self.enablePanGesture = NO;
        }
            break;
        default:
            break;
    }
}

//点击进入,退出全屏,或者监测到屏幕旋转去调用的方法
-(void)toOrientation:(UIInterfaceOrientation)orientation{
    //获取到当前状态条的方向
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    //判断如果当前方向和要旋转的方向一致,那么不做任何操作
    if (currentOrientation == orientation) {
        return;
    }
    
    //根据要旋转的方向,使用Masonry重新修改限制
    if (orientation ==UIInterfaceOrientationPortrait) {//
        [self.wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(0);
            make.left.equalTo(self.view).with.offset(0);
            make.right.equalTo(self.view).with.offset(0);
            make.height.equalTo(@(playerFrame.size.height));
        }];
    }else{
        //这个地方加判断是为了从全屏的一侧,直接到全屏的另一侧不用修改限制,否则会出错;
        if (currentOrientation ==UIInterfaceOrientationPortrait) {
            [self.wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@([UIScreen mainScreen].bounds.size.height));
                make.height.equalTo(@([UIScreen mainScreen].bounds.size.width));
                make.center.equalTo(self.wmPlayer.superview);
            }];
        }
    }
    //iOS6.0之后,设置状态条的方法能使用的前提是shouldAutorotate为NO,也就是说这个视图控制器内,旋转要关掉;
    //也就是说在实现这个方法的时候-(BOOL)shouldAutorotate返回值要为NO
    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
    //获取旋转状态条需要的时间:
    [UIView beginAnimations:nil context:nil];
    //更改了状态条的方向,但是设备方向UIInterfaceOrientation还是正方向的,这就要设置给你播放视频的视图的方向设置旋转
    //给你的播放视频的view视图设置旋转
    self.wmPlayer.transform = CGAffineTransformIdentity;
    self.wmPlayer.transform = [WMPlayer getCurrentDeviceOrientation];
    [UIView setAnimationDuration:2.0];
    //开始旋转
    [UIView commitAnimations];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置播放器
    self.wmPlayer = [[WMPlayer alloc]init];
    //wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame];
    
    self.wmPlayer.delegate = self;
    //self.wmPlayer.URLString = self.URLString;
    NSLog(@"视频的地址为：%@",self.URLString);
    self.wmPlayer.titleLabel.text = self.title;
    self.wmPlayer.closeBtn.hidden = NO;
    self.wmPlayer.enableFastForwardGesture = YES;
    self.wmPlayer.enableVolumeGesture = YES;
    self.wmPlayer.dragEnable = NO;
    [self.view addSubview:self.wmPlayer];
    //[self.wmPlayer play];
    [self.wmPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.height.equalTo(@(playerFrame.size.height));
    }];
    
    
    //获取设备旋转方向的通知,即使关闭了自动旋转,一样可以监测到设备的旋转方向
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    self.navigationController.navigationBarHidden = YES;
    
    [self startAFNetworkingWithID:self.id];
    [self startPingLunAFNetworkingWithID:self.id withPage:_currentPage];
}
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    //self.navigationController.navigationBarHidden = NO;
    [self releaseWMPlayer];
}
#pragma mark


- (void)alertXiaZaiButtonAction:(UIButton *)sender{
    __weak typeof(self) weakSelf = self;
    
    AlertViewCustomZL  * alert = [[AlertViewCustomZL alloc]init];
    alert.titleName = @"下载视频需要开通VIP";
    alert.cancelBtnTitle = @"取消";
    alert.okBtnTitle = @"开通";
    [alert showCustomAlertView];
    [alert cancelBlockAction:^(BOOL success) {
        //_isKuaiJinAction = 0;
        [alert hideCustomeAlertView];
    }];
    [alert okButtonBlockAction:^(BOOL success) {
        //_isKuaiJinAction = 0;
        [alert hideCustomeAlertView];
        [weakSelf.navigationController popViewControllerAnimated:NO];
        [weakSelf xw_postNotificationWithName:KAITONG_VIP_NOTIFICATION userInfo:nil];
    }];
    [self.view addSubview:alert];
}


- (void)releaseWMPlayer
{
    //堵塞主线程
    //[wmPlayer.player.currentItem cancelPendingSeeks];
    //[wmPlayer.player.currentItem.asset cancelLoading];
    [self.wmPlayer pause];
    [self.wmPlayer removeFromSuperview];
    [self.wmPlayer.playerLayer removeFromSuperlayer];
    [self.wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
    self.wmPlayer.player = nil;
    self.wmPlayer.currentItem = nil;
    //释放定时器，否侧不会调用WMPlayer中的dealloc方法
    [self.wmPlayer.autoDismissTimer invalidate];
    self.wmPlayer.autoDismissTimer = nil;
    self.wmPlayer.playOrPauseBtn = nil;
    self.wmPlayer.playerLayer = nil;
    self.wmPlayer = nil;
}
- (void)dealloc
{
    [self releaseWMPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"播放页销毁-----DetailViewController deallco");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)tableViewARR{
    
    if (!_tableViewARR) {
        _tableViewARR = [[NSMutableArray alloc]init];
    }
    return _tableViewARR;
}
//自定义 弹出按钮

- (void)alertViewShow{
    
   // __weak typeof(self) weakSelf = self;
    AlertViewCustomZL  * alert = [[AlertViewCustomZL alloc]init];
    alert.titleName = @"开通VIP进入直播间";
    alert.cancelBtnTitle = @"取消";
    alert.okBtnTitle = @"开通";
    [alert showCustomAlertView];
    [alert cancelBlockAction:^(BOOL success) {
        //_isKuaiJinAction = 0;
        [alert hideCustomeAlertView];
    }];
    [alert okButtonBlockAction:^(BOOL success) {
        //_isKuaiJinAction = 0;
        [alert hideCustomeAlertView];
        [self alertZhiFuViewWithType:0];
    }];
    [self.view addSubview:alert];
}

//开通VIP按钮执行方法
- (IBAction)kaiTongVIPButtongAction:(UIButton *)sender {
    
    ChongZhiViewController * vc = [[ChongZhiViewController alloc]init];
    vc.UB_or_VIP = UB_ChongZhi;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 进入直播间
- (IBAction)jinruZhiBoAction:(UIButton *)sender {
    
    if ([ZBALLModel isLogined]) {
        if (_isCanToRoom == YES) {
            NSLog(@"进入直播间");
            NSString * strIdentifier = _zbroom;
            BOOL isExsit = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strIdentifier]];
            if(isExsit) {
                //NSLog(@"App %@ installed", strIdentifier);
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strIdentifier]];
            }
        }
        else{
            [self alertZhiFuViewWithType:0];
        }
    }
    else{
        [ZBALLModel pushToLoginViewControllerFromVC:self];
    }
    
}



#pragma end
#pragma mark 加主播微信
- (IBAction)addWeiXinButtonAction:(UIButton *)sender {
    
    if ([ZBALLModel isLogined]) {
        if (_isHaveWeiXin == YES) {
            NSLog(@"加主播微信");
            AlertViewCustomZL  * alert = [[AlertViewCustomZL alloc]init];
            
            alert.titleName = [NSString stringWithFormat:@"微信号：%@",_zbWeiXin];
            alert.cancelBtnTitle = @"取消";
            alert.okBtnTitle = @"开通";
            [alert showCustomAlertView];
            [alert cancelBlockAction:^(BOOL success) {
                //_isKuaiJinAction = 0;
                [alert hideCustomeAlertView];
            }];
            [alert okButtonBlockAction:^(BOOL success) {
                //_isKuaiJinAction = 0;
                [alert hideCustomeAlertView];
                
            }];
            [self.view addSubview:alert];
        }
        else{
            [self alertZhiFuViewWithType:1];
        }
    }
    else{
        [ZBALLModel pushToLoginViewControllerFromVC:self];
    }
    
}

- (void)alertZhiFuViewWithType:(NSInteger)type{
    if (type == 0) {
        __weak typeof(self) weakSelf = self;
        ZhuBoBuyVIPAlertView * alertView = [[ZhuBoBuyVIPAlertView alloc]init];
        alertView.currentPayType = ZHIFUBAOPAY_TYPE;
        [alertView showCustomAlertView];
        
        alertView.demoview.rightLabel.text = [NSString stringWithFormat:@"￥%@",_vipPrice];
        alertView.demoview.weiXinRightLabel.text = [NSString stringWithFormat:@"￥%@",_weixinPrice];
        [alertView.demoview.headerImageView setImageWithURL:[NSURL URLWithString:self.currentZBModel.thumb] placeholder:[UIImage imageNamed:@"icon_default2"]];
        
        __weak typeof(alertView) weakAlertView = alertView;
        [alertView setPlayActionTypeBlockAction:^(BOOL success, NSInteger Paytype, NSInteger CommodityType) {
            //paytype  支付方式  commodityType  商品类型
            [weakAlertView hideCustomeAlertView];
            if (Paytype == 0) {
                if (CommodityType == 1) {
                    NSLog(@"成为VIP微信支付");
                    [[ZBBuyVIPModel shareBuyVIPModel] loadDingDanInfoWithFirstType:@"wechat" withZBID:nil withVIPorWeiXin:VIP_TYPE_ENUM withJINE:_vipPrice withVC:self];
                    
                }
                else{
                    NSLog(@"加主播微信微信支付");
                    [[ZBBuyVIPModel shareBuyVIPModel] loadDingDanInfoWithFirstType:@"wechat" withZBID:self.id withVIPorWeiXin:WEIXIN_TYPE_ENUM withJINE:_weixinPrice withVC:self];
                }
            }
            else{
                if (CommodityType == 1) {
                    NSLog(@"成为VIP支付宝支付");
                    [[ZBBuyVIPModel shareBuyVIPModel] loadDingDanInfoWithFirstType:@"alipay" withZBID:nil withVIPorWeiXin:VIP_TYPE_ENUM withJINE:_vipPrice withVC:self];
                    
                }
                else{
                    NSLog(@"加主播微信支付宝支付");
                    [[ZBBuyVIPModel shareBuyVIPModel] loadDingDanInfoWithFirstType:@"alipay" withZBID:self.id  withVIPorWeiXin:WEIXIN_TYPE_ENUM withJINE:_weixinPrice withVC:self];
                }
            }
        }];
        [self.view addSubview:alertView];
    }
    else{
        
        __weak typeof(self) weakSelf = self;
        
        ZhuBoBuyVIPAlertView * alertView = [[ZhuBoBuyVIPAlertView alloc]init];
        alertView.currentPayType = WEIXINPAY_TYPE;
        [alertView showCustomAlertView];
        alertView.demoview.rightLabel.text = [NSString stringWithFormat:@"￥%@",_vipPrice];
        alertView.demoview.weiXinRightLabel.text = [NSString stringWithFormat:@"￥%@",_weixinPrice];
        [alertView.demoview.headerImageView setImageWithURL:[NSURL URLWithString:self.currentZBModel.thumb] placeholder:[UIImage imageNamed:@"icon_default2"]];
        
        __weak typeof(alertView) weakAlertView = alertView;
        [alertView setPlayActionTypeBlockAction:^(BOOL success, NSInteger Paytype, NSInteger CommodityType) {
            //paytype  支付方式  commodityType  商品类型
            
            [weakAlertView hideCustomeAlertView];
            if (Paytype == 0) {
                if (CommodityType == 1) {
                    NSLog(@"成为VIP微信支付");
                    [[ZBBuyVIPModel shareBuyVIPModel] loadDingDanInfoWithFirstType:@"wechat" withZBID:nil withVIPorWeiXin:VIP_TYPE_ENUM withJINE:_vipPrice withVC:self];
                }
                else{
                    NSLog(@"加主播微信微信支付");
                    [[ZBBuyVIPModel shareBuyVIPModel] loadDingDanInfoWithFirstType:@"wechat" withZBID:self.id withVIPorWeiXin:WEIXIN_TYPE_ENUM withJINE:_weixinPrice withVC:self];
                }
            }
            else{
                if (CommodityType == 1) {
                    NSLog(@"成为VIP支付宝支付");
                    [[ZBBuyVIPModel shareBuyVIPModel] loadDingDanInfoWithFirstType:@"alipay" withZBID:nil withVIPorWeiXin:VIP_TYPE_ENUM withJINE:_vipPrice withVC:self];
                }
                else{
                    NSLog(@"加主播微信支付宝支付");
                    [[ZBBuyVIPModel shareBuyVIPModel] loadDingDanInfoWithFirstType:@"alipay" withZBID:self.id  withVIPorWeiXin:WEIXIN_TYPE_ENUM withJINE:_weixinPrice withVC:self];
                    
                }
            }
        }];
        
        [self.view addSubview:alertView];
        
        
        //        __weak typeof(self) weakSelf = self;
        //        AlertViewCustomZL  * alert = [[AlertViewCustomZL alloc]init];
        //        alert.titleName = @"观看完整版,需要开通VIP";
        //        alert.cancelBtnTitle = @"取消";
        //        alert.okBtnTitle = @"开通";
        //        [alert showCustomAlertView];
        //        [alert cancelBlockAction:^(BOOL success) {
        //            //_isKuaiJinAction = 0;
        //            [alert hideCustomeAlertView];
        //        }];
        //        [alert okButtonBlockAction:^(BOOL success) {
        //            //_isKuaiJinAction = 0;
        //            [alert hideCustomeAlertView];
        //            [weakSelf.navigationController popViewControllerAnimated:NO];
        //            [weakSelf xw_postNotificationWithName:KAITONG_VIP_NOTIFICATION userInfo:nil];
        //        }];
        //        [self.view addSubview:alert];
    }
}

#pragma end
#pragma mark CollectionView代理方法  START
- (void)loadCollectionView{
    
    //创建一个Layout布局
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小为
    //layout.itemSize = CGSizeMake(Collection_item_Width, Collection_item_Height);
    //item距离四周的位置（上左下右）
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    //item 行与行的距离
    layout.minimumLineSpacing = 10;
    //item 列与列的距离
    layout.minimumInteritemSpacing = 10;
    
    UICollectionViewFlowLayout * layout2 = [[UICollectionViewFlowLayout alloc]init];
    layout2.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout2.itemSize = CGSizeMake(COLLECTION_CELL_WIDTH, COLLECTION_CELL_HEIGHT);
    layout2.sectionInset = UIEdgeInsetsMake(5, 10, 5, 0);
    layout2.minimumLineSpacing = 10;
    layout2.minimumInteritemSpacing = 0;
    
    [self.collectionView setCollectionViewLayout:layout2];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZBVideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ZBVideoCVID"];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionARR.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"ZBVideoCVID";
    ZBVideoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    ZBVideoCellModel * model = [self.collectionARR objectAtIndex:indexPath.row];
    [cell.videoImageView setImageWithURL:[NSURL URLWithString:model.pic] placeholder:[UIImage imageNamed:PlaceholderImage_Name]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([ZBALLModel isLogined]) {
        if (_isCanToRoom == YES) {
            ZBVideoCellModel * model = [self.collectionARR objectAtIndex:indexPath.row];
            SiFangPlayController * vc = [[SiFangPlayController alloc]init];
            vc.zaiXianUrl = [NSURL URLWithString:model.video];
            vc.zaiXianName = @"更多视频";
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            [self alertZhiFuViewWithType:0];
        }
    }
    else{
        [ZBALLModel pushToLoginViewControllerFromVC:self];
    }
}






#pragma end mark CollectionView代理方发  end
- (NSMutableArray *)collectionARR{
    if (!_collectionARR) {
        _collectionARR = [[NSMutableArray alloc]init];
    }
    return _collectionARR;
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
