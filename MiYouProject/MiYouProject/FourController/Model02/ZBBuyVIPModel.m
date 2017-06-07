//
//  ZBBuyVIPModel.m
//  MiYouProject
//
//  Created by wkj on 2017/6/2.
//  Copyright © 2017年 junhong. All rights reserved.
//

#import "ZBBuyVIPModel.h"

@implementation ZBBuyVIPModel{

    int _currentJINE;
    NSString * _currentOrderNUM;
}

static ZBBuyVIPModel * _instance = nil;
+ (instancetype)shareBuyVIPModel{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ZBBuyVIPModel alloc]init];
    });
    
    return _instance;
}



#pragma mark 支付宝  微信支付  接口调用  START

- (void)loadDingDanInfoWithFirstType:(NSString *)type withZBID:(NSString *)zid withVIPorWeiXin:(VipORWeiXin_ENUM) vipOrWxEnum {
    
    //用户信息
    NSString * UID = [kUserDefaults objectForKey:ZB_USER_MID];
    NSLog(@"生成订单：用户的ID：%@,支付宝支付:金额为：%d",UID,_currentJINE);
    
    NSString * url = nil;
    if (vipOrWxEnum == VIP_TYPE_ENUM) {
        self.currentTypeEnum = VIP_TYPE_ENUM;
        //wechat
        url = [NSString stringWithFormat:@"%@?action=buyvip&mid=%@&vip=%d&type=%@&channel=%@",URL_Common_ios,UID,1,type,CHANNEL_ID];
    }
    else{
        self.currentTypeEnum = WEIXIN_TYPE_ENUM;
        url = [NSString stringWithFormat:@"%@?action=buyweixin&mid=%@&zid=%@&type=%@&channel=%@",URL_Common_ios,UID,zid,type,CHANNEL_ID];
    }
    
    
    NSLog(@"支付宝充值VIP页面链接：%@",url);
    [[ZLSecondAFNetworking sharedInstance] getWithURLString:url parameters:nil success:^(id responseObject) {
        
        // 1.判断当前对象是否能够转换成JSON数据.
        // YES if obj can be converted to JSON data, otherwise NO
        //BOOL isYes = [NSJSONSerialization isValidJSONObject:responseObject];
        //NSString *str = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
        //NSData* xmlData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary * dic = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        // BOOL isYes = [NSJSONSerialization isValidJSONObject:responseObject];
        NSLog(@"支付宝充值VIP页面请求返回的数据为：%@----是否可以解析：",dic);
        if (!zlDictIsEmpty(dic)) {
            NSString * result = dic[@"result"];
            if ([result isEqualToString:@"success"]) {
                if ([dic[@"pay"] isEqualToString:@"jubaopay"]) {
                    [weak_self(self) juBaoYunZhiFuWithType:type withOrderDic:dic];
                }
                else if([dic[@"pay"] isEqualToString:@"openepay"]){
                    [weak_self(self) firstZhiFuWithType:type withOrderDic:dic];
                }
                else if ([dic[@"pay"] isEqualToString:@"cloudpay"]){
                    [weak_self(self) thirdZhiFuAction:type withDingDanInfo:dic];
                }
                else if ([dic[@"pay"] isEqualToString:@"stpay"]){
                
                    [weak_self(self) stPayZhiFuWithType:type withOrderDic:dic];
                
                }
                
            }
            else{
                [MBManager showBriefAlert:@"生成订单失败"];
            }
            
        }else{
            [MBManager showBriefAlert:@"生成订单失败"];
        }
    } failure:^(NSError *error) {
        [MBManager showBriefAlert:@"生成订单失败"];
    }];
    
    
    
}

// 过滤HTML的标签
- (NSString *)removeHTML:(NSString *)html {
    /*
     NSScanner *theScanner = [NSScanner scannerWithString:html];
     
     NSString *text = nil;
     
     while ([theScanner isAtEnd] == NO) {
     
     // 找到标签的起始位置
     
     [theScanner scanUpToString:@"<" intoString:nil] ;
     
     // 找到标签的结束位置
     
     [theScanner scanUpToString:@">" intoString:&text] ;
     
     // 替换字符
     
     //(you can filter multi-spaces out later if you wish)
     
     html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@" "];
     }
     */
    /*
     iOS中对字符串进行UTF-8编码：输出str字符串的UTF-8格式
     [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     
     解码：把str字符串以UTF-8规则进行解码
     [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     */
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[(NSString *)html dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    html = [html stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString * CustomString = nil;
    CustomString = [attrStr.string stringByReplacingOccurrencesOfString:@"<p>" withString:@"·"];
    CustomString = [CustomString stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
    return CustomString;
    
}


#pragma mark 支付接口 1  网页跳转 START

- (void)firstZhiFuWithType:(NSString *)type withOrderDic:(NSDictionary *)dic{
    __weak typeof(self) weakSelf = self;
    if (self.currentTypeEnum == VIP_TYPE_ENUM) {
        //UB充值
        if ([type isEqualToString:@"alipay"]) {
            _currentOrderNUM = dic[@"payid"];
            //@"https://qr.alipay.com/bax00225fwvaxotgyqcj602a"
            NSString * strIdentifier = dic[@"url"];
            BOOL isExsit = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strIdentifier]];
            if(isExsit) {
                //NSLog(@"App %@ installed", strIdentifier);
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strIdentifier]];
                AlertViewCustomZL * alertZL = [[AlertViewCustomZL alloc]init];
                alertZL.titleName = @"支付结果";
                alertZL.cancelBtnTitle = @"支付失败";
                alertZL.okBtnTitle = @"支付完成";
                [alertZL cancelBlockAction:^(BOOL success) {
                    [alertZL hideCustomeAlertView];

                }];
                [alertZL okButtonBlockAction:^(BOOL success) {
                    [alertZL hideCustomeAlertView];

                    NSLog(@"点击了去支付按钮");
                }];
                [alertZL showCustomAlertView];
            }
        }
        else{
            NSLog(@"微信支付！");
        }
        
    }
    else{
        //VIP会员购买
        if ([type isEqualToString:@"alipay"]) {
            _currentOrderNUM = dic[@"orderNo"];
            NSLog(@"当前的订单号为：%@",_currentOrderNUM);
            //@"https://qr.alipay.com/bax00225fwvaxotgyqcj602a"
            NSString * strIdentifier = dic[@"url"];
            BOOL isExsit = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strIdentifier]];
            if(isExsit) {
                //NSLog(@"App %@ installed", strIdentifier);
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strIdentifier]];
                AlertViewCustomZL * alertZL = [[AlertViewCustomZL alloc]init];
                alertZL.titleName = @"支付结果";
                alertZL.cancelBtnTitle = @"支付失败";
                alertZL.okBtnTitle = @"支付完成";
                [alertZL cancelBlockAction:^(BOOL success) {
                    [alertZL hideCustomeAlertView];

                }];
                [alertZL okButtonBlockAction:^(BOOL success) {
                    [alertZL hideCustomeAlertView];

                    NSLog(@"点击了去支付按钮");
                }];
                [alertZL showCustomAlertView];
            }
            
        }
        else{
            
            NSLog(@"微信支付！");
        }
        
        
    }
    
    
    
    
}
- (void)zhifushibaiActionWithType:(NSString *)type{
    __weak typeof(self) weakSelf = self;
    
    //wechat
    NSString * url  = nil;
    
    if ([type isEqualToString:@"VIP"]) {
        
        url = [NSString stringWithFormat:@"%@?action=doBuyVip&orderNo=%@",URL_Common_ios,_currentOrderNUM];
    }else{
        
        url = [NSString stringWithFormat:@"%@?action=doRecharge&orderNo=%@",URL_Common_ios,_currentOrderNUM];
    }
    
    
    NSLog(@"获取充值结果URL：%@",url);
    [[ZLSecondAFNetworking sharedInstance] getWithURLString:url parameters:nil success:^(id responseObject) {
        
        // 1.判断当前对象是否能够转换成JSON数据.
        // YES if obj can be converted to JSON data, otherwise NO
        //BOOL isYes = [NSJSONSerialization isValidJSONObject:responseObject];
        //NSString *str = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
        //NSData* xmlData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary * dic = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        // BOOL isYes = [NSJSONSerialization isValidJSONObject:responseObject];
        //NSLog(@"支付宝充值VIP页面请求返回的数据为：%@----是否可以解析：",dic);
        if (!zlDictIsEmpty(dic)) {
            NSString * result = dic[@"result"];
            if ([result isEqualToString:@"success"]) {
                [MBManager showBriefAlert:@"支付成功"];

            }
            else{
                [MBManager showBriefAlert:@"支付失败"];
            }
        }else{
            [MBManager showBriefAlert:@"支付失败"];
        }
    } failure:^(NSError *error) {
        [MBManager showBriefAlert:@"服务器连接失败"];
    }];
    
    [GlobalQueue executeAsyncTask:^{
        [self reloadMemberInfoAFNetworking];
    }];
    
}


#pragma end mark 支付接口 1  网页跳转 END

#pragma mark 支付接口 2 聚宝云 START

- (void)juBaoYunZhiFuWithType:(NSString *)type withOrderDic:(NSDictionary *)dic{
    //用户信息
    NSDictionary * userDic = [[NSUserDefaults standardUserDefaults] objectForKey:MEMBER_INFO_DIC];
    NSString * UID = userDic[@"id"];
    __weak typeof(self) weakSelf = self;
    if (self.currentTypeEnum == VIP_TYPE_ENUM) {
        //UB充值
        if ([type isEqualToString:@"alipay"]) {
            _currentOrderNUM = dic[@"payid"];
            //@"https://qr.alipay.com/bax00225fwvaxotgyqcj602a"
            
            
        }
        else{
            _currentOrderNUM = dic[@"payid"];
            
            
        }
        
    }
    else{
        //VIP会员购买
        if ([type isEqualToString:@"alipay"]) {
            //支付宝支付
            _currentOrderNUM = dic[@"payid"];
            float jiaGeStr = [dic[@"price"] floatValue];
            NSLog(@"当前的订单号为：%@",_currentOrderNUM);
            
            
        }
        else{
            
            _currentOrderNUM = dic[@"payid"];
            float jiaGeStr = [dic[@"price"] floatValue];
            NSLog(@"当前的订单号为：%@",_currentOrderNUM);
            
            
        }
        
        
    }
    
}

// 聚宝云支付结果通知：
- (void)receiveResult:(NSString*)payid result:(BOOL)success message:(NSString*)message
{
    NSLog(@"支付回调信息：%@----%d",message,success);
    if ( success == YES )
    {
        //        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"支付成功" message:message preferredStyle:UIAlertControllerStyleAlert];
        //        [controller addAction:[UIAlertAction actionWithTitle:@"知道啦" style:UIAlertActionStyleCancel handler:nil]];
        //        [self presentViewController:controller animated:true completion:nil];
        
        [GlobalQueue executeAsyncTask:^{
            [self reloadMemberInfoAFNetworking];
        }];
        
        
        __weak typeof(self) weakSelf = self;
        AlertViewCustomZL * alertZL = [[AlertViewCustomZL alloc]init];
        alertZL.titleName = @"支付成功";
        alertZL.cancelBtnTitle = @"取消";
        alertZL.okBtnTitle = @"确定";
        [alertZL cancelBlockAction:^(BOOL success) {
            [alertZL hideCustomeAlertView];
            //[weakSelf xw_postNotificationWithName:ZHIFU_NOTIFICATION_RESUALT userInfo:@{@"type":@"VIP"}];
        }];
        [alertZL okButtonBlockAction:^(BOOL success) {
            [alertZL hideCustomeAlertView];

            NSLog(@"点击了去支付按钮");
        }];
        [alertZL showCustomAlertView];
        
        
        
        
    }
    else
    {
        //        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"支付失败" message:message preferredStyle:UIAlertControllerStyleAlert];
        //        [controller addAction:[UIAlertAction actionWithTitle:@"知道啦" style:UIAlertActionStyleCancel handler:nil]];
        //        [self presentViewController:controller animated:true completion:nil];
        __weak typeof(self) weakSelf = self;
        AlertViewCustomZL * alertZL = [[AlertViewCustomZL alloc]init];
        alertZL.titleName = @"支付失败";
        alertZL.cancelBtnTitle = @"取消";
        alertZL.okBtnTitle = @"再试一次";
        [alertZL cancelBlockAction:^(BOOL success) {
            [alertZL hideCustomeAlertView];
            //[weakSelf xw_postNotificationWithName:ZHIFU_NOTIFICATION_RESUALT userInfo:@{@"type":@"VIP"}];
        }];
        [alertZL okButtonBlockAction:^(BOOL success) {
            [alertZL hideCustomeAlertView];
            //[weakSelf.navigationController popViewControllerAnimated:YES];
            NSLog(@"点击了去支付按钮");
        }];
        [alertZL showCustomAlertView];
    }
}

#pragma END MARK 支付接口 2 聚宝云集成 END
#pragma mark 支付接口 3 START

- (void)thirdZhiFuAction:(NSString *)type withDingDanInfo:(NSDictionary *)dic{
    
    NSLog(@"第三种支付方法");
    
}


#pragma end mark  支付接口 3 END

//支付完成后 请求用户信息 刷新
- (void)reloadMemberInfoAFNetworking{
    //&action=memberCenter&id=1
    /*
     "member":{
     "id":1,
     "name":"\u5f20\u4e09",
     "password":"123456",
     “group”:0,
     }
     */
    //__weak typeof(self) weakSelf = self;
    NSString * urlstring = [NSString stringWithFormat:@"%@?action=memberCenter&id=%@",URL_Common_ios,@""];
    NSLog(@"用户中心请求的链接为：%@",urlstring);
    [[ZLSecondAFNetworking sharedInstance] getWithURLString:urlstring parameters:nil success:^(id responseObject) {
        NSDictionary *  dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"用户中心请求的数据为：%@",dic);
        if ([dic[@"result"] isEqualToString:@"success"]) {
            //weakSelf.userMessageModel = [MTLJSONAdapter modelOfClass:[UserMessageMTLModel class] fromJSONDictionary:dic error:nil];
            [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"points"] forKey:MEMBER_POINTS_NUM];
            [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"vip"] forKey:MEMBER_VIP_LEVEL];
        }
        
    } failure:^(NSError *error){
        NSLog(@"支付完成后，请求用户信息 失败");
    }];
    
}


#pragma mark 4 支付方法  STPay  START
- (void)stPayZhiFuWithType:(NSString *)type withOrderDic:(NSDictionary *)dic{
    __weak typeof(self) weakSelf = self;
    if (self.currentTypeEnum == VIP_TYPE_ENUM) {
        //UB充值
        if ([type isEqualToString:@"alipay"]) {
            _currentOrderNUM = dic[@"payid"];
            //@"https://qr.alipay.com/bax00225fwvaxotgyqcj602a"
            NSString * strIdentifier = dic[@"url"];
            BOOL isExsit = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strIdentifier]];
            if(isExsit) {
                //NSLog(@"App %@ installed", strIdentifier);
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strIdentifier]];
                AlertViewCustomZL * alertZL = [[AlertViewCustomZL alloc]init];
                alertZL.titleName = @"支付结果";
                alertZL.cancelBtnTitle = @"支付失败";
                alertZL.okBtnTitle = @"支付完成";
                [alertZL cancelBlockAction:^(BOOL success) {
                    [alertZL hideCustomeAlertView];

                }];
                [alertZL okButtonBlockAction:^(BOOL success) {
                    [alertZL hideCustomeAlertView];

                    NSLog(@"点击了去支付按钮");
                }];
                [alertZL showCustomAlertView];
            }
        }
        else{
            NSLog(@"微信支付！");
        }
        
    }
    else{
        //VIP会员购买
        if ([type isEqualToString:@"alipay"]) {
            _currentOrderNUM = dic[@"orderNo"];
            NSLog(@"当前的订单号为：%@",_currentOrderNUM);
            //@"https://qr.alipay.com/bax00225fwvaxotgyqcj602a"
            NSString * strIdentifier = dic[@"url"];
            BOOL isExsit = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strIdentifier]];
            if(isExsit) {
                //NSLog(@"App %@ installed", strIdentifier);
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strIdentifier]];
                AlertViewCustomZL * alertZL = [[AlertViewCustomZL alloc]init];
                alertZL.titleName = @"支付结果";
                alertZL.cancelBtnTitle = @"支付失败";
                alertZL.okBtnTitle = @"支付完成";
                [alertZL cancelBlockAction:^(BOOL success) {
                    [alertZL hideCustomeAlertView];

                }];
                [alertZL okButtonBlockAction:^(BOOL success) {
                    [alertZL hideCustomeAlertView];

                    NSLog(@"点击了去支付按钮");
                }];
                [alertZL showCustomAlertView];
            }
            
        }
        else{
            
            NSLog(@"微信支付！");
        }
        
        
    }
    
    
    
    
}
- (void)stPayzhifushibaiActionWithType:(NSString *)type{
    __weak typeof(self) weakSelf = self;
    
    //wechat
    NSString * url  = nil;
    
    if ([type isEqualToString:@"VIP"]) {
        
        url = [NSString stringWithFormat:@"%@?action=doBuyVip&orderNo=%@",URL_Common_ios,_currentOrderNUM];
    }else{
        
        url = [NSString stringWithFormat:@"%@?action=doRecharge&orderNo=%@",URL_Common_ios,_currentOrderNUM];
    }
    
    
    NSLog(@"获取充值结果URL：%@",url);
    [[ZLSecondAFNetworking sharedInstance] getWithURLString:url parameters:nil success:^(id responseObject) {
        
        // 1.判断当前对象是否能够转换成JSON数据.
        // YES if obj can be converted to JSON data, otherwise NO
        //BOOL isYes = [NSJSONSerialization isValidJSONObject:responseObject];
        //NSString *str = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
        //NSData* xmlData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary * dic = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        // BOOL isYes = [NSJSONSerialization isValidJSONObject:responseObject];
        //NSLog(@"支付宝充值VIP页面请求返回的数据为：%@----是否可以解析：",dic);
        if (!zlDictIsEmpty(dic)) {
            NSString * result = dic[@"result"];
            if ([result isEqualToString:@"success"]) {
                [MBManager showBriefAlert:@"支付成功"];

            }
            else{
                [MBManager showBriefAlert:@"支付失败"];
            }
        }else{
            [MBManager showBriefAlert:@"支付失败"];
        }
    } failure:^(NSError *error) {
        [MBManager showBriefAlert:@"服务器连接失败"];
    }];
    
    [GlobalQueue executeAsyncTask:^{
        [self reloadMemberInfoAFNetworking];
    }];
    
}



#pragma end mark END



@end
