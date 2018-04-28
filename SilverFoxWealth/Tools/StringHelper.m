//
//  StringHelper.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/5/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "StringHelper.h"

@implementation StringHelper

//渲染年化收益
+ (NSAttributedString *)renderYearIncomeWithValue:(NSString *)value valueFont:(float)valueFont percentFont:(float)percentFont {
    
    NSMutableAttributedString *resultString=[[NSMutableAttributedString alloc] init];
    UIColor *redColor=[UIColor zheJiangBusinessRedColor];
    NSMutableAttributedString *temStr=nil;
    
//    NSString *yearStr=[NSString stringWithFormat:@"%d",value];
    {
        temStr=[[NSMutableAttributedString alloc] initWithString:value attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:valueFont],NSFontAttributeName, nil]];
        [resultString appendAttributedString:temStr];
        
        temStr=[[NSMutableAttributedString alloc] initWithString:@"%" attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:percentFont],NSFontAttributeName, nil]];
        [resultString appendAttributedString:temStr];
    }
    
    return resultString;
}

+ (NSAttributedString *)renderLowsMoneyAndTimeWithValue:(int)value LabelStr:(NSString*)str valueFont:(float)valueFont percentFont:(float)percentFont
{
    NSMutableAttributedString *resultString=[[NSMutableAttributedString alloc] init];
    UIColor *redColor=[UIColor characterBlackColor];
    NSMutableAttributedString *temStr=nil;
    
    NSString *yearStr=[NSString stringWithFormat:@"%d",value];
    {
        temStr=[[NSMutableAttributedString alloc] initWithString:yearStr attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:valueFont],NSFontAttributeName, nil]];
        [resultString appendAttributedString:temStr];
        
        temStr=[[NSMutableAttributedString alloc] initWithString:str attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:percentFont],NSFontAttributeName, nil]];
        [resultString appendAttributedString:temStr];
    }
    
    return resultString;
}
/**
 *渲染定期产品详情页年化收益 value:百分比的值 valueFont:百分比的字体大小 percentFont:百分号%的字体大小
 */
+ (NSAttributedString *)renderDetailYearIncomeWithValue:(NSString *)value valueFont:(float)valueFont percentFont:(float)percentFont
{
    NSMutableAttributedString *resultString=[[NSMutableAttributedString alloc] init];
    UIColor *redColor=[UIColor whiteColor];
    NSMutableAttributedString *temStr=nil;
    
//    NSString *yearStr=[NSString stringWithFormat:@"%d",value];
    {
        temStr=[[NSMutableAttributedString alloc] initWithString:value attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:valueFont],NSFontAttributeName, nil]];
        [resultString appendAttributedString:temStr];
        
        temStr=[[NSMutableAttributedString alloc] initWithString:@"%" attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:percentFont],NSFontAttributeName, nil]];
        [resultString appendAttributedString:temStr];
    }
    return resultString;
}



//渲染年化收益
+ (NSAttributedString *)renderBYearIncomeWithValue:(NSString *)value valueFont:(float)valueFont percentFont:(float)percentFont {
    
    NSMutableAttributedString *resultString=[[NSMutableAttributedString alloc] init];
    UIColor *redColor=[UIColor whiteColor];
    NSMutableAttributedString *temStr=nil;
    
    {
        temStr=[[NSMutableAttributedString alloc] initWithString:value attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:valueFont],NSFontAttributeName, nil]];
        [resultString appendAttributedString:temStr];
        
        temStr=[[NSMutableAttributedString alloc] initWithString:@"%" attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:percentFont],NSFontAttributeName, nil]];
        [resultString appendAttributedString:temStr];
        
        temStr=[[NSMutableAttributedString alloc] initWithString:@"起" attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:20],NSFontAttributeName, nil]];
        [resultString appendAttributedString:temStr];
    }
    
    return resultString;
}


//前部分和后部分字体不同 渲染我的资产里标题
+ (NSAttributedString *)renderFrontAndAfterDifferentFontWithValue:(NSString *)frontStr frontFont:(CGFloat)frontFont frontColor:(UIColor *)frontColor  afterStr:(NSString *)afterStr afterFont:(CGFloat)afterFont afterColor:(UIColor *)afterColor {
    
    NSMutableAttributedString *resultString=[[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *temStr=nil;
    
    {
        temStr=[[NSMutableAttributedString alloc] initWithString:frontStr attributes:[NSDictionary dictionaryWithObjectsAndKeys:frontColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:frontFont],NSFontAttributeName, nil]];
        [resultString appendAttributedString:temStr];
        
        temStr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",afterStr] attributes:[NSDictionary dictionaryWithObjectsAndKeys:afterColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:afterFont],NSFontAttributeName, nil]];
        
        [resultString appendAttributedString:temStr];
    }
    return resultString;
}

+ (NSAttributedString *)renderFrontAndAfterDifferentFontWithValue:(NSString *)frontStr frontFont:(CGFloat)frontFont frontColor:(UIColor *)frontColor  afterStr:(NSString *)afterStr afterFont:(CGFloat)afterFont afterColor:(UIColor *)afterColor  lastStr:(NSString *)lastStr lastFont:(CGFloat)lastFont lastColor:(UIColor *)lastColor
{
    NSMutableAttributedString *resultString=[[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *temStr=nil;
    {
        temStr=[[NSMutableAttributedString alloc] initWithString:frontStr attributes:[NSDictionary dictionaryWithObjectsAndKeys:frontColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:frontFont],NSFontAttributeName, nil]];
        [resultString appendAttributedString:temStr];
        
        temStr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",afterStr] attributes:[NSDictionary dictionaryWithObjectsAndKeys:afterColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:afterFont],NSFontAttributeName, nil]];
        
        [resultString appendAttributedString:temStr];
        
        temStr=[[NSMutableAttributedString alloc] initWithString:lastStr attributes:[NSDictionary dictionaryWithObjectsAndKeys:lastColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:lastFont],NSFontAttributeName, nil]];
        
        [resultString appendAttributedString:temStr];
    }
    return resultString;
}

//渲染
+ (NSAttributedString *)renderPurchaseFrequencyWith:(NSString *)text {
    
    UIColor *blackColor=[UIColor depictBorderGrayColor];
    UIColor *redColor=[UIColor characterBlackColor];
    NSMutableAttributedString *sortNumberString=[[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString *sortNumberTem=[[NSMutableAttributedString alloc] init];
    {
        NSString *sortStr=text;
        
        sortNumberTem=[[NSMutableAttributedString alloc] initWithString:@"剩余可投金额  " attributes:[NSDictionary dictionaryWithObjectsAndKeys:blackColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:13],NSFontAttributeName, nil]];
        [sortNumberString appendAttributedString:sortNumberTem];
        
        sortNumberTem=[[NSMutableAttributedString alloc] initWithString:sortStr attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:14],NSFontAttributeName, nil]];
        [sortNumberString appendAttributedString:sortNumberTem];
        
        sortNumberTem=[[NSMutableAttributedString alloc] initWithString:@"元" attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:14],NSFontAttributeName, nil]];
        [sortNumberString appendAttributedString:sortNumberTem];
    }
    return sortNumberString;
}

+ (NSAttributedString *)renderMyBonusPageWith:(NSString *)text content:(NSString *)content
{
    UIColor *blackColor=[UIColor characterBlackColor];
    NSMutableAttributedString *sortNumberString=[[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *sortNumberTem=[[NSMutableAttributedString alloc] init];
    {
        NSString *sortStr=text;
        sortNumberTem=[[NSMutableAttributedString alloc] initWithString:sortStr attributes:[NSDictionary dictionaryWithObjectsAndKeys:blackColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:12],NSFontAttributeName, nil]];
        [sortNumberString appendAttributedString:sortNumberTem];
        
        sortNumberTem=[[NSMutableAttributedString alloc] initWithString:content attributes:[NSDictionary dictionaryWithObjectsAndKeys:blackColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:12],NSFontAttributeName, nil]];
        [sortNumberString appendAttributedString:sortNumberTem];
    }
    return sortNumberString;
}


//渲染购买次数
+ (NSAttributedString *)renderPurchaseFrequencyWithBabyPage:(NSString *)text {
    
    UIColor *blackColor=[UIColor characterBlackColor];
    UIColor *redColor=[UIColor zheJiangBusinessRedColor];
    NSMutableAttributedString *sortNumberString=[[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString *sortNumberTem=[[NSMutableAttributedString alloc] init];
    {
        NSString *sortStr=text;
        
//        sortNumberTem=[[NSMutableAttributedString alloc] initWithString:@"已购人数\n" attributes:[NSDictionary dictionaryWithObjectsAndKeys:blackColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:16],NSFontAttributeName, nil]];
//        [sortNumberString appendAttributedString:sortNumberTem];
        
        sortNumberTem=[[NSMutableAttributedString alloc] initWithString:sortStr attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:16],NSFontAttributeName, nil]];
        [sortNumberString appendAttributedString:sortNumberTem];
        
        sortNumberTem=[[NSMutableAttributedString alloc] initWithString:@"人" attributes:[NSDictionary dictionaryWithObjectsAndKeys:blackColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:16],NSFontAttributeName, nil]];
        [sortNumberString appendAttributedString:sortNumberTem];
    }
    
    return sortNumberString;
}




//渲染我的红包上面的数值
+ (NSAttributedString *)renderRebateAmountWith:(NSString *)text valueFont:(CGFloat)valueFont yuanFont:(CGFloat)yuanFont  {
    
    UIColor *redColor=[UIColor zheJiangBusinessRedColor];
    NSMutableAttributedString *sortNumberString=[[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString *sortNumberTem=[[NSMutableAttributedString alloc] init];
    {
        NSString *sortStr=text;
        sortNumberTem=[[NSMutableAttributedString alloc] initWithString:@"¥ " attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:yuanFont],NSFontAttributeName, nil]];
        [sortNumberString appendAttributedString:sortNumberTem];

        sortNumberTem=[[NSMutableAttributedString alloc] initWithString:sortStr attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:valueFont],NSFontAttributeName, nil]];
        [sortNumberString appendAttributedString:sortNumberTem];
            }
    return sortNumberString;
}

//渲染我的加息券上面的数值
+ (NSAttributedString *)renderCouponAmountWith:(NSString *)text valueFont:(CGFloat)valueFont yuanFont:(CGFloat)yuanFont  {
    
    UIColor *redColor=[UIColor zheJiangBusinessRedColor];
    NSMutableAttributedString *sortNumberString=[[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString *sortNumberTem=[[NSMutableAttributedString alloc] init];
    {
        NSString *sortStr=text;
        sortNumberTem=[[NSMutableAttributedString alloc] initWithString:sortStr attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:valueFont],NSFontAttributeName, nil]];
        [sortNumberString appendAttributedString:sortNumberTem];
        
        sortNumberTem=[[NSMutableAttributedString alloc] initWithString:@"%" attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:yuanFont],NSFontAttributeName, nil]];
        [sortNumberString appendAttributedString:sortNumberTem];
    }
    return sortNumberString;
}

+ (NSAttributedString *)renderRegisterCouponAmountWith:(NSString *)text valueFont:(CGFloat)valueFont lastText:(NSString *)lastText yuanFont:(CGFloat)yuanFont
{
    UIColor *redColor=[UIColor zheJiangBusinessRedColor];
    NSMutableAttributedString *sortNumberString=[[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString *sortNumberTem=[[NSMutableAttributedString alloc] init];
    {
        NSString *sortStr=text;
        sortNumberTem = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",sortStr] attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:valueFont],NSFontAttributeName, nil]];
        [sortNumberString appendAttributedString:sortNumberTem];
        
        sortNumberTem=[[NSMutableAttributedString alloc] initWithString:lastText attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:yuanFont],NSFontAttributeName, nil]];
        [sortNumberString appendAttributedString:sortNumberTem];
    }
    return sortNumberString;
}
//从字符串中按顺序找到 为数字的字符
+ (NSString *)findNumFromStr:(NSString *)originalString
{
    // Intermediate
    NSMutableString *numberString = [[NSMutableString alloc] init];
    NSString *tempStr;
    NSScanner *scanner = [NSScanner scannerWithString:originalString];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789.%"];
    
    while (![scanner isAtEnd]) {
        // Throw away characters before the first number.
        [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
        
        // Collect numbers.
        [scanner scanCharactersFromSet:numbers intoString:&tempStr];
        [numberString appendString:tempStr];
        tempStr = @"";
    }
    return numberString;
}

//剔除字符串中不是数字的字符
+ (NSString *)deleteClutterCharacterFor:(NSString *)str {
    NSString *oneStr=[str stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    NSString *reusltStr=[self findNumFromStr:oneStr];
    return reusltStr;
}


//获取 字符串按最大尺寸rect 和字体大小 得到需要的size
+ (CGSize)achieveStrRuleSizeWith:(CGSize)rect targetStr:(NSString *)targetStr strFont:(CGFloat)strFont {
    CGRect resultRect=[targetStr boundingRectWithSize:rect options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:strFont],NSFontAttributeName, nil] context:nil];
    return resultRect.size;
}



//掩饰用户的手机号
+ (NSString *)coverUsecellPhoneWith:(NSString *)cellPhoneStr  {
    
    NSString *phoneNumStr=cellPhoneStr;
    phoneNumStr=[phoneNumStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    return phoneNumStr;
}

//掩饰用户的姓名
+ (NSString *)coverUserNameWith:(NSString *)nameStr  {
    if (nameStr.length < 3) {
        NSString *nameStrOne=[nameStr stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"*"];
        return nameStrOne;
    }else{
        NSString *nameStrOne=[nameStr stringByReplacingCharactersInRange:NSMakeRange(0, nameStr.length - 2) withString:@"*"];
        return nameStrOne;
    }
    return nil;
}


//渲染基金详情
+ (NSAttributedString *)renderFundDataWithStr:(NSString *)targetStr targetStrFont:(UIFont *)targetStrFont valueStr:(NSString *)valueStr valueStrFont:(UIFont *)valueStrFont {
    
    NSMutableAttributedString *resultString=[[NSMutableAttributedString alloc] init];
    UIColor *characterColor = [UIColor characterBlackColor];
    UIColor *redColor = [UIColor zheJiangBusinessRedColor];
    NSMutableAttributedString *temStr=nil;
    {
        temStr=[[NSMutableAttributedString alloc] initWithString:targetStr attributes:[NSDictionary dictionaryWithObjectsAndKeys:characterColor,NSForegroundColorAttributeName,targetStrFont,NSFontAttributeName, nil]];
        [resultString appendAttributedString:temStr];
        
        NSString *valuedd=[NSString stringWithFormat:@"%.2f",[valueStr floatValue]];        
        temStr=[[NSMutableAttributedString alloc] initWithString:valuedd attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,valueStrFont,NSFontAttributeName, nil]];
        [resultString appendAttributedString:temStr];
    }
    return resultString;
}


+ (double)roundValueWith:(double)value {
    return round(value*100)/100;
}


//渲染加息字符串
+ (NSAttributedString *)renderIncreaseInterestWithValue:(NSString *)value valueFont:(float)valueFont percentFont:(float)percentFont {
    
    NSMutableAttributedString *resultString=[[NSMutableAttributedString alloc] init];
    UIColor *redColor=[UIColor zheJiangBusinessRedColor];
    NSMutableAttributedString *temStr=nil;
    
    {
        temStr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"+%@",value] attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:valueFont],NSFontAttributeName, nil]];
        [resultString appendAttributedString:temStr];
        
        temStr=[[NSMutableAttributedString alloc] initWithString:@"%" attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:percentFont],NSFontAttributeName, nil]];
        [resultString appendAttributedString:temStr];
    }
    
    return resultString;
}
/**
 *渲染详情页加息字符串
 */
+ (NSAttributedString *)renderDetailIncreaseInterestWithValue:(NSString *)value valueFont:(float)valueFont percentFont:(float)percentFont
{
    NSMutableAttributedString *resultString=[[NSMutableAttributedString alloc] init];
    UIColor *redColor=[UIColor whiteColor];
    NSMutableAttributedString *temStr=nil;
    {
        temStr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"+%@",value] attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:valueFont],NSFontAttributeName, nil]];
        [resultString appendAttributedString:temStr];
        
        temStr=[[NSMutableAttributedString alloc] initWithString:@"%" attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:percentFont],NSFontAttributeName, nil]];
        [resultString appendAttributedString:temStr];
    }    
    return resultString;
}

//渲染购买按钮 上的 购买和剩余金额
+ (NSAttributedString *)renderPurchaseBTWithSurplusNum:(NSInteger)surplusNum {
    
    NSMutableAttributedString *resultString=[[NSMutableAttributedString alloc] init];
    UIColor *redColor=[UIColor whiteColor];
    NSString *numStr=[NSString stringWithFormat:@"剩余可购买金额%ld元",(long)surplusNum];
        
    NSMutableAttributedString *temStr=nil;
    {
        temStr=[[NSMutableAttributedString alloc] initWithString:@"购买" attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:16],NSFontAttributeName, nil]];
        [resultString appendAttributedString:temStr];
        
        temStr=[[NSMutableAttributedString alloc] initWithString:numStr attributes:[NSDictionary dictionaryWithObjectsAndKeys:redColor,NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:13],NSFontAttributeName, nil]];
        //[resultString appendAttributedString:temStr];
    }
    
    return resultString;
}

+ (NSString *)roundValueToDoubltValue:(NSString *)string
{
    double d = [string doubleValue];
    NSString * testNumber = [NSString stringWithFormat:@"%f",d];
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    return outNumber;
}

+ (NSAttributedString *)renderImageAndTextWithValue:(NSString *)value valueFont:(float)valueFont valueColor:(UIColor *)valueColor image:(UIImage *)image imageFrame:(CGRect)imageFrame index:(int)index
{
    NSMutableAttributedString *imageAndTextString = [[NSMutableAttributedString alloc] initWithString:value attributes:[NSDictionary dictionaryWithObjectsAndKeys:valueColor,NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:valueFont],NSFontAttributeName, nil]];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = imageFrame;
    
    NSAttributedString *textString = [NSAttributedString attributedStringWithAttachment:attachment];
    [imageAndTextString insertAttributedString:textString atIndex:index];
    return imageAndTextString;
}

+ (NSAttributedString *)renderImageAndDoubleTextWithValue:(NSString *)value valueFont:(float)valueFont valueColor:(UIColor *)valueColor viceValue:(NSString *)viceValue viceFont:(float)viceValueFont viceValueColor:(UIColor *)viceValueColor image:(UIImage *)image imageFrame:(CGRect)imageFrame index:(int)index
{
    NSMutableAttributedString *imageAndTextString = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *sortNumberTem = [[NSMutableAttributedString alloc] init];
    sortNumberTem = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",value] attributes:[NSDictionary dictionaryWithObjectsAndKeys:valueColor,NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:valueFont],NSFontAttributeName, nil]];
    [imageAndTextString appendAttributedString:sortNumberTem];
    
    sortNumberTem=[[NSMutableAttributedString alloc] initWithString:viceValue attributes:[NSDictionary dictionaryWithObjectsAndKeys:viceValueColor,NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica" size:viceValueFont],NSFontAttributeName, nil]];
    [imageAndTextString appendAttributedString:sortNumberTem];
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = imageFrame;
    NSAttributedString *textString = [NSAttributedString attributedStringWithAttachment:attachment];
    [imageAndTextString insertAttributedString:textString atIndex:index];
    return imageAndTextString;
}








@end
