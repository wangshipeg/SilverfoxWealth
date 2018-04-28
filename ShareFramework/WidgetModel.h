//
//  WidgetModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/11/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WidgetModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *actualAmount;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *financePeriod;
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *increaseInterest;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSString *totalAmount;
@property (nonatomic, strong) NSString *yearIncome;
@property (nonatomic, strong) NSString *property;
@property (nonatomic, strong) NSString *shippedTime;
@property (nonatomic, strong) NSString *interestDate;
@property (nonatomic, strong) NSString *nowTime;

- (id)initWithDic:(NSDictionary *)dic;


@end
