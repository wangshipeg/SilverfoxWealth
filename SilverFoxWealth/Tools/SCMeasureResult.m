//
//  SCMeasureResult.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/7/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SCMeasureResult.h"
#import "DateHelper.h"
#import "EncryptHelper.h"


static  BOOL _isRightSignStr(NSString *keyStr,NSString *signStr) {
    
    BOOL isResult=NO;
    NSMutableString *mtStr=[NSMutableString string];
    [mtStr appendString:@"com.cn.silverfox"];
    [mtStr appendString:keyStr];
    [mtStr appendString:[DateHelper conversionCurrentTimeForLineFormat]];
    NSString *md5Str=[EncryptHelper MD5String:mtStr];
    
    if ([md5Str isEqualToString:signStr]) {
        isResult = YES;
    }
    return isResult;
}


static SCMeasureResult_t *scMeasureResult_t = NULL;


@implementation SCMeasureResult

+ (SCMeasureResult_t *)shareSCMeasureResult {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scMeasureResult_t  = malloc(sizeof(SCMeasureResult_t));
        scMeasureResult_t -> isRightSignStr = _isRightSignStr;
    });
    return scMeasureResult_t;
}





@end
