//
//  FyCalendarView.h
//  FYCalendar
//
//  Created by 丰雨 on 16/3/17.
//  Copyright © 2016年 Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FyCalendarView <NSObject>
/**
 *  点击返回的日期
 */
- (void)setupToday:(NSInteger)day Month:(NSInteger)month Year:(NSInteger)year;

//- (void)choose
@end

@interface FyCalendarView : UIView

//set 选择日期
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) UIColor *dateColor;
//年月label
@property (nonatomic, strong) UILabel *headlabel;
@property (nonatomic, strong) UIColor *headColor;
//weekView
@property (nonatomic, strong) UIView *weekBg;
@property (nonatomic, strong) UIColor *weekDaysColor;

// 全天可用
@property (nonatomic, strong) NSMutableArray *allDaysArr;
@property (nonatomic, strong) UIColor *allDaysColor;
@property (nonatomic, assign) CGFloat *allDaysAlpha;
@property (nonatomic, strong) UIImage *allDaysImage;

// 部分时段可用
@property (nonatomic, strong) NSArray *partDaysArr;
@property (nonatomic, strong) UIColor *partDaysColor;
@property (nonatomic, assign) CGFloat *partDaysAlpha;
@property (nonatomic, strong) UIImage *partDaysImage;

// 是否只显示本月日期,默认->NO
@property (nonatomic, assign) BOOL isShowOnlyMonthDays;

//创建日历
- (void)createCalendarViewWith:(NSDate *)date;
/**
 *  nextMonth
 *
 *  @param date nil = 当前日期的下一个月
 */
//- (void)setNextMonth:(NSDate *)date;
- (NSDate *)nextMonth:(NSDate *)date;

/**
 *  lastMonth
 *
 *  @param date nil -> 当前日期的上一个月
 */
//- (void)setLastMonth:(NSDate *)date;
- (NSDate *)lastMonth:(NSDate *)date;

/**
 *  nextMonth and lastMonth
 */
@property (nonatomic, copy) void(^nextMonthBlock)();
@property (nonatomic, copy) void(^lastMonthBlock)();

//选择年月  -> 暂不考虑
@property (nonatomic, copy) void(^chooseMonthBlock)();

/**
 *  点击返回日期
 */
@property (nonatomic, copy) void(^calendarBlock)(NSInteger day, NSInteger month, NSInteger year);


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com