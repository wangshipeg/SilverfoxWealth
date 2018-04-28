//
//  StringHelper.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/5/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface StringHelper : NSObject

/**
 *渲染年化收益 value:百分比的值 valueFont:百分比的字体大小 percentFont:百分号%的字体大小
 */
+ (NSAttributedString *)renderYearIncomeWithValue:(NSString *)value valueFont:(float)valueFont percentFont:(float)percentFont;
/**
 *渲染精品推荐页理财期限/起购金额
 */
+ (NSAttributedString *)renderLowsMoneyAndTimeWithValue:(int)value LabelStr:(NSString*)str valueFont:(float)valueFont percentFont:(float)percentFont;

/**
 *渲染定期产品详情页年化收益 value:百分比的值 valueFont:百分比的字体大小 percentFont:百分号%的字体大小
 */
+ (NSAttributedString *)renderDetailYearIncomeWithValue:(NSString *)value valueFont:(float)valueFont percentFont:(float)percentFont;



/**
 *前部分和后部分字体不同 渲染我的资产里标题、我的资产里纯common产品投资总金额
 */
+ (NSAttributedString *)renderFrontAndAfterDifferentFontWithValue:(NSString *)frontStr frontFont:(CGFloat)frontFont frontColor:(UIColor *)frontColor  afterStr:(NSString *)afterStr afterFont:(CGFloat)afterFont afterColor:(UIColor *)afterColor;

/**
 *ABA模式
 */
+ (NSAttributedString *)renderFrontAndAfterDifferentFontWithValue:(NSString *)frontStr frontFont:(CGFloat)frontFont frontColor:(UIColor *)frontColor  afterStr:(NSString *)afterStr afterFont:(CGFloat)afterFont afterColor:(UIColor *)afterColor  lastStr:(NSString *)lastStr lastFont:(CGFloat)lastFont lastColor:(UIColor *)lastColor;

/**
 *渲染基金详情
 */
+ (NSAttributedString *)renderFundDataWithStr:(NSString *)targetStr targetStrFont:(UIFont *)targetStrFont valueStr:(NSString *)valueStr valueStrFont:(UIFont *)valueStrFont;


/**
 *渲染购买次数
 */
+ (NSAttributedString *)renderPurchaseFrequencyWith:(NSString *)text;

/**
 *渲染红包页面使用条件
 */
+ (NSAttributedString *)renderMyBonusPageWith:(NSString *)text content:(NSString *)content;

/**
 *渲染红包金额
 */
+ (NSAttributedString *)renderRebateAmountWith:(NSString *)text valueFont:(CGFloat)valueFont yuanFont:(CGFloat)yuanFont;

/**
 *渲染加息券金额
 */
+ (NSAttributedString *)renderCouponAmountWith:(NSString *)text valueFont:(CGFloat)valueFont yuanFont:(CGFloat)yuanFont;

+ (NSAttributedString *)renderRegisterCouponAmountWith:(NSString *)text valueFont:(CGFloat)valueFont lastText:(NSString *)lastText yuanFont:(CGFloat)yuanFont;
/**
 *从字符串中按顺序找到 为数字的字符
 */
+ (NSString *)findNumFromStr:(NSString *)originalString;


/**
 *剔除字符串中不是数字的字符
 */
+ (NSString *)deleteClutterCharacterFor:(NSString *)str;

/**
 *获取 字符串按最大尺寸rect 和字体大小 得到需要的size
 */
+ (CGSize)achieveStrRuleSizeWith:(CGSize)rect targetStr:(NSString *)targetStr strFont:(CGFloat)strFont;

/**
 *掩饰用户的手机号
 */
+ (NSString *)coverUsecellPhoneWith:(NSString *)cellPhoneStr;


/**
 *掩饰用户的姓名
 */
+ (NSString *)coverUserNameWith:(NSString *)nameStr;


/**
 *对一个长浮点型进行四舍五入
 */
+ (double)roundValueWith:(double)value;

/**
 *处理8.8问题
 */
+ (NSString *)roundValueToDoubltValue:(NSString *)string;

/**
 *渲染产品列表加息字符串
 */
+ (NSAttributedString *)renderIncreaseInterestWithValue:(NSString *)value valueFont:(float)valueFont percentFont:(float)percentFont;
/**
 *渲染详情页加息字符串
 */
+ (NSAttributedString *)renderDetailIncreaseInterestWithValue:(NSString *)value valueFont:(float)valueFont percentFont:(float)percentFont;

/**
 *渲染购买按钮 上的 购买和剩余金额
 */
+ (NSAttributedString *)renderPurchaseBTWithSurplusNum:(NSInteger)surplusNum;

/**
 *图文混排
 */
+ (NSAttributedString *)renderImageAndTextWithValue:(NSString *)value valueFont:(float)valueFont valueColor:(UIColor *)valueColor image:(UIImage *)image imageFrame:(CGRect)imageFrame index:(int)index;

+ (NSAttributedString *)renderImageAndDoubleTextWithValue:(NSString *)value valueFont:(float)valueFont valueColor:(UIColor *)valueColor viceValue:(NSString *)viceValue viceFont:(float)viceValueFont viceValueColor:(UIColor *)viceValueColor image:(UIImage *)image imageFrame:(CGRect)imageFrame index:(int)index;

@end
