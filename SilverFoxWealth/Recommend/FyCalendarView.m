//
//  FyCalendarView.m
//  FYCalendar
//
//  Created by 丰雨 on 16/3/17.
//  Copyright © 2016年 Feng. All rights reserved.
//

#import "FyCalendarView.h"
#import "TopBottomBalckBorderView.h"
#import "DataRequest.h"
#import "SCMeasureDump.h"

@interface FyCalendarView ()
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) NSMutableArray *daysArray;
@property (nonatomic, strong) UILabel *numLB;
@property (nonatomic, strong) NSString *numStr;

@end

@implementation FyCalendarView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDate];
        [self setupNextAndLastMonthView];
        [self recommendFillSignPageNumber];
    }
    return self;
}

- (void)recommendFillSignPageNumber{
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] recommendFillSignPageNumberWithCustomerId:user.customerId callback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = obj;
            _numStr = dic[@"cardNum"];
            if (_numLB) {
                _numLB.text = [NSString stringWithFormat:@"%@",_numStr];
            }
        }
    }];
}

- (void)setupDate {
    self.daysArray = [NSMutableArray arrayWithCapacity:42];
    for (int i = 0; i < 42; i++) {
        UIButton *button = [[UIButton alloc] init];
        [self addSubview:button];
        [_daysArray addObject:button];
//        [button addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setupNextAndLastMonthView {
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"brn_left"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(nextAndLastMonth:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftBtn];
    leftBtn.tag = 1;
    leftBtn.frame = CGRectMake(10, 10, 20, 20);
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"btn_right"] forState:UIControlStateNormal];
    rightBtn.tag = 2;
    [rightBtn addTarget:self action:@selector(nextAndLastMonth:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];
    rightBtn.frame = CGRectMake(self.frame.size.width - 30, 10, 20, 20);
}

- (void)nextAndLastMonth:(UIButton *)button {
    if (button.tag == 1) {
        if (self.lastMonthBlock) {
            self.lastMonthBlock();
        }
    } else {
        if (self.nextMonthBlock) {
            self.nextMonthBlock();
        }
    }
}

#pragma mark - create View
- (void)setDate:(NSDate *)date{
    _date = date;
    [self createCalendarViewWith:date];
}

- (void)createCalendarViewWith:(NSDate *)date{
    
    CGFloat itemW     = self.frame.size.width / 7;
    CGFloat itemH     = self.frame.size.width / 7;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, itemH)];
    backgroundView.backgroundColor = [UIColor backgroundGrayColor];
    [self addSubview:backgroundView];
                                                                    
    // 1.year month
    self.headlabel = [[UILabel alloc] init];
    self.headlabel.text = [NSString stringWithFormat:@"%li年%li月",(long)[self year:date],(long)[self month:date]];
    self.headlabel.font = [UIFont systemFontOfSize:18];
    self.headlabel.frame = CGRectMake(90, 0, self.frame.size.width - 180, itemH);
    self.headlabel.textAlignment   = NSTextAlignmentCenter;
    self.headlabel.textColor = [UIColor characterBlackColor];
    [backgroundView addSubview: self.headlabel];
    
    UILabel *fillSignLB = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 70, 0, 45, itemH)];
    [fillSignLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:14] characterColor:[UIColor characterBlackColor]];
    fillSignLB.text = @"补签卡";
    [backgroundView addSubview:fillSignLB];
    
    _numLB = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 25, itemH / 2 - 10, 20, 20)];
    _numLB.backgroundColor = [UIColor yellowSilverfoxColor];
    _numLB.textAlignment = NSTextAlignmentCenter;
    [_numLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:14] characterColor:[UIColor whiteColor]];
    _numLB.text = [NSString stringWithFormat:@"%@",_numStr];
    _numLB.layer.cornerRadius = 10;
    _numLB.layer.masksToBounds = YES;
    [backgroundView addSubview:_numLB];
    
    // 2.weekday
    NSArray *array = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    self.weekBg = [[UIView alloc] init];
    self.weekBg.frame = CGRectMake(0, CGRectGetMaxY(self.headlabel.frame), self.frame.size.width, itemH);
    [self addSubview:self.weekBg];
    
    UILabel *lb = [[UILabel alloc] init];
    lb.backgroundColor = [UIColor backgroundGrayColor];
    lb.frame = CGRectMake(0, CGRectGetMaxY(self.headlabel.frame) - 1, self.frame.size.width, 1);
    [self.weekBg addSubview:lb];

    
    for (int i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] init];
        week.text     = array[i];
        week.font     = [UIFont systemFontOfSize:14];
        week.frame    = CGRectMake(itemW * i, 10, itemW, 32);
        week.textAlignment   = NSTextAlignmentCenter;
        week.backgroundColor = [UIColor clearColor];
        week.textColor       = [UIColor characterBlackColor];
        [self.weekBg addSubview:week];
    }
    
    //  3.days (1-31)
    for (int i = 0; i < 42; i++) {
        
        int x = (i % 7) * itemW ;
        int y = (i / 7) * itemH + CGRectGetMaxY(self.weekBg.frame);
        
        UIButton *dayButton = _daysArray[i];
        dayButton.frame = CGRectMake(x + 5, y + 1, itemW - 7, itemH - 7);
        dayButton.titleLabel.font = [UIFont systemFontOfSize:13];
        dayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        //dayButton.layer.cornerRadius = 5.0f;
        
//        dayButton.layer.cornerRadius = 1;
//        dayButton.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor typefaceGrayColor]);
        
//        [dayButton addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];
        
        NSInteger daysInLastMonth = [self totaldaysInMonth:[self lastMonth:date]];
        NSInteger daysInThisMonth = [self totaldaysInMonth:date];
        NSInteger firstWeekday    = [self firstWeekdayInThisMonth:date];
        NSInteger day = 0;
        
        
        if (i < firstWeekday) {
            day = daysInLastMonth - firstWeekday + i + 1;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            day = i + 1 - firstWeekday - daysInThisMonth;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else{
            day = i - firstWeekday + 1;
            [dayButton setTitle:[NSString stringWithFormat:@"%li", (long)day] forState:UIControlStateNormal];
            [self setStyle_AfterToday:dayButton];
        }
        
        [dayButton setTitle:[NSString stringWithFormat:@"%li", (long)day] forState:UIControlStateNormal];
        dayButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        // this month
        if ([self month:date] == [self month:[NSDate date]]) {
            NSInteger todayIndex = [self day:date] + firstWeekday - 1;            
            if (i < todayIndex && i >= firstWeekday) {
                //                [self setStyle_BeforeToday:dayButton];
            }else if(i ==  todayIndex){
                [self setStyle_Today:dayButton];
            }
        }
    }
}

#pragma mark - output date
-(void)logDate:(UIButton *)dayBtn
{
    self.selectBtn.selected = NO;
//    [self.selectBtn setBackgroundColor:[UIColor clearColor]];
    dayBtn.selected = YES;
    self.selectBtn = dayBtn;
    [dayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[dayBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];//点击数字变红色
    
    NSInteger day = [[dayBtn titleForState:UIControlStateNormal] integerValue];
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
    
    NSString *dateString = [NSString stringWithFormat:@"%li-%02li-%02li",[comp year],[comp month],day];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"消耗1张补签卡进行补签?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不补签" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确认补签" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self requestFillSignBackData:dateString button:dayBtn];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    UITabBarController *control = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *VC=(UINavigationController *)control.selectedViewController;
    UIViewController *productVC=[VC topViewController];
    [productVC presentViewController:alertController animated:YES completion:nil];
}

- (void)requestFillSignBackData:(NSString *)dateStr button:(UIButton *)dayBtn
{
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] recommendFillSignWithCustomerId:user.customerId date:dateStr callback:^(id obj) {
        DLog(@"补签返回结果======%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [self recommendFillSignPageNumber];
            NSInteger day = [[dayBtn titleForState:UIControlStateNormal] integerValue];
            NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
            if (self.calendarBlock) {
                self.calendarBlock(day, [comp month], [comp year]);
            }
            NSDictionary *dic = obj;
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"补签此日获得%@两银子",dic[@"silverNum"]]];
        }
        if ([obj isKindOfClass:[NSString class]]) {
            [SVProgressHUD showErrorWithStatus:obj];
        }
    }];
}



#pragma mark - date button style

- (void)setStyle_BeyondThisMonth:(UIButton *)btn
{
    btn.enabled = NO;
    if (self.isShowOnlyMonthDays) {
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    } else {
        [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    }
}

//- (void)setStyle_BeforeToday:(UIButton *)btn
//{
//        btn.enabled = NO;
//    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    for (NSString *str in self.allDaysArr) {
//        if ([str isEqualToString:btn.titleLabel.text]) {
//            UIView *domView = [[UIView alloc] initWithFrame:CGRectMake(btn.frame.size.width / 2 - 3, btn.frame.size.height - 6, 6, 6)];
//            domView.backgroundColor = [UIColor orangeColor];
//            domView.layer.cornerRadius = 3;
//            domView.layer.masksToBounds = YES;
//            [btn addSubview:domView];
//        }
//    }
//    for (NSString *str in self.allDaysArr) {
//        if ([str isEqualToString:btn.titleLabel.text]) {
//            UIImageView *stateView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height)];
//            stateView.layer.cornerRadius = btn.frame.size.height / 2;
//            stateView.layer.masksToBounds = YES;
//            stateView.backgroundColor = [UIColor blueColor];
//            stateView.alpha = 0.5;
//            [btn addSubview:stateView];
//        }
//    }
//}

//当天
- (void)setStyle_Today:(UIButton *)btn
{
    NSString *currentTime = [[SCMeasureDump shareSCMeasureDump].nowTime substringToIndex:10];
    NSString *dateString = [currentTime stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *currentDayDate = [dateString substringFromIndex:6];
    if (![self.allDaysArr containsObject: currentDayDate]) {
        [btn setBackgroundImage:[UIImage imageNamed:@"sameDay.png"] forState:UIControlStateNormal];
    }
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UILabel *label = [[UILabel alloc] init];
    [btn addSubview:label];
    label.backgroundColor = [UIColor yellowSilverfoxColor];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn.mas_top).offset(5);
        make.right.equalTo(btn.mas_right).offset(-5);
        make.height.equalTo(@5);
        make.width.equalTo(@5);
    }];
    label.layer.cornerRadius = 2.5;
    label.layer.masksToBounds = YES;
}

- (void)setStyle_AfterToday:(UIButton *)btn
{
    [btn setBackgroundImage:[UIImage imageNamed:@"noSign.png"] forState:UIControlStateNormal];
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 17);
    [btn setTitleColor:[UIColor characterBlackColor] forState:UIControlStateNormal];
    for (NSString *str in self.allDaysArr) {
        if ([str intValue] == [btn.titleLabel.text intValue]) {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"alreadSIgn.png"] forState:UIControlStateNormal];
        }
    }
    for (NSString *str in self.partDaysArr) {
        if ([str intValue] == [btn.titleLabel.text intValue]) {
            //未签到不设置标注
            [btn setBackgroundImage:[UIImage imageNamed:@"fillSign.png"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

#pragma mark - Lazy loading
- (NSArray *)allDaysArr {
    if (!_allDaysArr) {
        _allDaysArr = [NSMutableArray array];
    }
    return _allDaysArr;
}

- (NSArray *)partDaysArr {
    if (!_partDaysArr) {
        _partDaysArr = [NSArray array];
    }
    return _partDaysArr;
}

- (UIColor *)headColor {
    if (!_headColor) {
        _headColor = [UIColor orangeColor];
    }
    return _headColor;
}

- (UIColor *)dateColor {
    if (!_dateColor) {
        _dateColor = [UIColor orangeColor];
    }
    return _dateColor;
}

- (UIColor *)allDaysColor {
    if (!_allDaysColor) {
        _allDaysColor = [UIColor blueColor];
    }
    return _allDaysColor;
}

- (UIColor *)partDaysColor {
    if (!_partDaysColor) {
        _partDaysColor = [UIColor cyanColor];
    }
    return _partDaysColor;
}

- (UIColor *)weekDaysColor {
    if (!_weekDaysColor) {
        _weekDaysColor = [UIColor lightGrayColor];
    }
    return _weekDaysColor;
}

//一个月第一个周末
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *component = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [component setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:component];
    NSUInteger firstWeekDay = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekDay - 1;
}

//总天数
- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

#pragma mark - month +/-

- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}


#pragma mark - date get: day-month-year

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}


- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

@end


