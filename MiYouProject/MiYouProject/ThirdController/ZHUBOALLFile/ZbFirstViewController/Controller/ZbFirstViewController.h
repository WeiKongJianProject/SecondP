//
//  ZbFirstViewController.h
//  MiYouProject
//
//  Created by wkj on 2017/5/17.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import "ZLBaseViewController.h"

#import "DianYingCollectionViewCell.h"

#import "HOmeBannerMTLModel.h"
#import "VideoListMTLModel.h"

#import "ZLSecondAFNetworking.h"
#import "ReMenView.h"
#import "WMPlayZLViewController.h"


#import "ZBHomeModel.h"


@class FirstSubViewViewController;


static int _currentPage;



@interface ZbFirstViewController : ZLBaseViewController<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIView * lunXianBackgroundView;
@property (strong, nonatomic) UIScrollView * lunXianScrollView;
@property (strong, nonatomic) UIPageControl * lunXianPageControl;
@property (strong, nonatomic) NSMutableArray * lunXianImageARR;
@property (strong, nonatomic) NSMutableArray * dianYingCollectionARR;
@property (strong, nonatomic) UICollectionView * dianYingCollectionView;
@property (strong, nonatomic) UITableView * tableview;


@property (assign, nonatomic) int id;
@property (strong, nonatomic) NSString * name;

@property (assign, nonatomic) int  isFirstIndex;



@end
