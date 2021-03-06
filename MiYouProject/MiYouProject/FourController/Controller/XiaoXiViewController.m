//
//  XiaoXiViewController.m
//  MiYouProject
//
//  Created by wkj on 2017/3/15.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import "XiaoXiViewController.h"

@interface XiaoXiViewController (){

    int _currentPage;
}

@end

@implementation XiaoXiViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 1;
    self.view.backgroundColor = [UIColor colorWithhex16stringToColor:Main_grayBackgroundColor];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SIZE_WIDTH, SIZE_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithhex16stringToColor:Main_grayBackgroundColor];
    //self.tableView.bounces = NO;
    //self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    /*==========ZL注释start===========
     *1.MJRefresh 添加
     *2.使用方法
     *3.
     *4.
     ===========ZL注释end==========*/
    //下拉刷新设置
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(xiaLaShuaXin)];
    //自动改变 透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    //上拉刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(shangLaShuaXin)];
    //[self.xiaoXiARR addObjectsFromArray:@[@"1"]];
    
}

- (void)xiaLaShuaXin{

    _currentPage = 1;
    [self startAFNetWorkingWithPage:_currentPage];
    
}
- (void)shangLaShuaXin{
    _currentPage++;
    [self startAFNetWorkingWithPage:_currentPage];
}

- (void)startAFNetWorkingWithPage:(int)page{

    NSString * mid = [kUserDefaults objectForKey:ZB_USER_MID];
    NSString * url = [NSString stringWithFormat:@"%@?action=message&mid=%@&page=%d",URL_Common_ios,mid,page];
    NSLog(@"请求消息URL：%@",url);
    [[ZLSecondAFNetworking sharedInstance] getWithURLString:url parameters:nil success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"消息返回：%@",dic);
        NSArray * arr = dic[@"msg"];
        if (_currentPage == 1) {
            [self.xiaoXiARR removeAllObjects];
        }
        if (arr.count > 0) {
            [self.xiaoXiARR addObjectsFromArray:[MTLJSONAdapter modelsOfClass:[ZBXiaoXiZLModel class] fromJSONArray:dic[@"msg"] error:nil]];
        }
        else{
            
        }

        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    

}
- (NSMutableArray *)xiaoXiARR{
    
    if (!_xiaoXiARR) {
        _xiaoXiARR = [[NSMutableArray alloc]init];
    }
    return _xiaoXiARR;
}

#pragma mark TableViewDelegate代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.xiaoXiARR.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0f;
    if (indexPath.row == 0) {
        height = 75.0f;
    }
    else{
        height = 50.0f;
    }
    return 100.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //firstTouXiangID  NormolID
    static NSString * cellID1 = @"xiaoXiCellID";
    XiaoXiTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID1];
    if (!cell) {
        cell = (XiaoXiTableViewCell *)[[NSBundle mainBundle] loadNibNamed:@"XiaoXiTableViewCell" owner:self options:nil][0];
    }
    
//    //清除所有视图，避免显示混乱
//    for (UIView * view in cell.contentView.subviews) {
//        [view removeFromSuperview];
//    }
    ZBXiaoXiZLModel * model = [self.xiaoXiARR objectAtIndex:indexPath.row];
    cell.xiaoXiSubTitleLabel.text = model.content;
    cell.timeLabel.text = model.addtime;
    cell.biaoTiLabel.text = model.title;
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了cell");
    
}

#pragma end mark

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"系统消息";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
