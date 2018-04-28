//
//  WidgetModel.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/11/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WidgetModel.h"

@implementation WidgetModel

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.name = dic[@"name"];
        self.idStr = dic[@"id"];
        self.actualAmount = dic[@"actualAmount"];
        self.category = dic[@"category"];
        self.financePeriod = dic[@"financePeriod"];
        self.increaseInterest = dic[@"increaseInterest"];
        self.label = dic[@"label"];
        self.property = dic[@"property"];
        self.totalAmount = dic[@"totalAmount"];
        self.yearIncome = dic[@"yearIncome"];
        self.interestDate = dic[@"interestDate"];
    }
    return self;
}

@end

