//
//  SignHelper.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/8/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SignHelper.h"
#import "EncryptHelper.h"

@implementation SignHelper

//对 字典里的所有key=value 进行签名 如果有sig的话 后面拼接上
+ (NSString *)partnerSignOrder:(NSDictionary *)paramDic sig:(NSString *)sig {
    
    NSArray *keyArray=[paramDic allKeys];
    
    //参数按顺序按首字母升序排列,值为空的不参与签名,MD5的key值放在最后
    NSArray *resultArray=[keyArray sortedArrayUsingComparator:^NSComparisonResult(NSString *key1, NSString *key2) {
        return [key1 compare:key2];
    }];
    
    NSMutableString *paramString=[NSMutableString stringWithString:@""];
    
    //拼接成 A=B&X=Y
    for (NSString *key in resultArray) {
        if ([paramDic[key] length]!=0) {
            [paramString appendFormat:@"&%@=%@",key,paramDic[key]];
        }
    }
    
    //删除第一个&字符
    if ([paramString length]>1) {
        [paramString deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    
    //如果是md5加密 给paramString后面添加 MD5 key
    if (sig) {
        NSString *pay_md5_key=[NSString stringWithFormat:@"%@",sig];
        [paramString appendFormat:@"&key=%@",pay_md5_key];
    }
    
    DLog(@"加密前===%@",paramString);
    
    //md5 加密
    NSString  *signString=[EncryptHelper MD5String:paramString];
    return signString;
}

@end
