//
//  URLZLHeader.h
//  MiYouProject
//
//  Created by wkj on 2017/3/22.
//  Copyright © 2017年 junhong. All rights reserved.
//

#ifndef URLZLHeader_h
#define URLZLHeader_h

#define IS_FIRST_OPEN @"is_first_open"
#define MEMBER_INFO_DIC @"member_info_dic"
#define MEMBER_VIP_LEVEL @"is_member_vip"
#define MEMBER_POINTS_NUM  @"member_points_num"
#define IS_RENZHENG_TIJIAO @"is_renzheng_tijiao"
#define HEAD_IMAGEVIEW_UPDATA_NOTIFICATION @"head_imageView_updata_notification"

#define KAITONG_VIP_NOTIFICATION @"kaitong_vip_notification"

#define CHANNEL_ID  Channel_id_function()?Channel_id_function():@"4"

static inline NSString * Channel_id_function() {
    //资源包路径
    NSString *bunPath = [[NSBundle mainBundle]bundlePath];
    //获取资源包下所有文件的子路径
    NSArray *pathArray = [[NSFileManager defaultManager]subpathsAtPath:bunPath];
    //拼接CodeResources路径
    NSString *codePath = [bunPath stringByAppendingPathComponent:@"_CodeSignature/Channel"];
    //数据读取
    //NSData *data = [NSData dataWithContentsOfFile:codePath];
    NSString * str = [NSString stringWithContentsOfFile:codePath encoding:NSUTF8StringEncoding error:nil];
    return str;
}


#define LOADDOWN_SHARE_URL @"LOADDOWN_URL_SHARE"

#define ZB_USER_NAME @"zb_user_name"
#define ZB_USER_PHONE @"zb_user_phone"
#define ZB_USER_IS_VIP @"zb_user_is_vip"
#define ZB_USER_MID @"zb_user_mid"
#define ZB_USER_HEADERIMAGE_URL @"zb_user_headimage_url"
#define ZB_USER_PAY_FINISHED_NF @"zb_user_pay_finished_nf"



//友盟APPID 58db47df07fe657cca0001b1
#define YOUMENG_APP_ID_ZL @"58db47df07fe657cca0001b1"
#define ALIPAY_APP_ID_ZL @"2015110400687059"


#define URL_Common_ios @"http://back.miyoutv.cc:8080/ios"//@"http://api4.cn360du.com:88/index.php?m=api-ios"//http://back.miyoutv.cc:8080//http://api.miyoutv.cc:8080
#define NewBanBen_URL  @"http://www.baidu.com"
#define XinBanBenImage @"http://api.miyoutv.cc:8088/static/Index/Images/ios_dld.jpg"

//ae835d ffda46  f9bf34
#define Main_BackgroundColor            @"ffda46"
#define Main_BackgroundGreen_Color      @"1cd39b"
//bab6b7  e6e6e6   f0eff5  a09993
#define Main_grayBackgroundColor        @"ffffff"
#define Main_darkGrayBackgroundColor    @"a09993"



#endif /* URLZLHeader_h */
