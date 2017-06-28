//
//  WxpaySdk.h
//  WxpaySdk
//
//  Created by Guo on 17/6/15.
//  Copyright © 2017年 shifutong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WxpaySdk : NSObject
{
    
}


+ (void) Pay:(long ) aid
        cent:(int) cent
        oid:(NSString *) oid
        itemname:(NSString *) itemname
        orderdesc:(NSString *) orderdesc
        scburl:(NSString *) scburl
        ccburl:(NSString *) ccburl
        appkey:(NSString *) appkey
        ext:(NSString *) ext;

+ (NSString*) GetSign:(long ) aid
                 cent:(int) cent
                  oid:(NSString *) oid
             itemname:(NSString *) itemname
            orderdesc:(NSString *) orderdesc
               scburl:(NSString *) scburl
               ccburl:(NSString *) ccburl
               appkey:(NSString *) appkey;

+ (NSString *) MD5:(NSString *)str;
@end
