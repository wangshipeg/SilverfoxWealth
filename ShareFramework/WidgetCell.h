//
//  WidgetCell.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/11/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAProgressView.h"
#import "WidgetModel.h"

@interface WidgetCell : UITableViewCell

@property (strong, nonatomic) UILabel *nameLb;
@property (nonatomic, strong) UILabel *nameLBNoive;
@property (nonatomic, strong) UILabel *infomationLB;//活动说明字段
@property (nonatomic, strong) UIView  *activityBackView; //活动父视图
@property (nonatomic, strong) UIView *addIncomeView;
@property (strong, nonatomic) UILabel *timeLimitLB;
@property (strong, nonatomic) UILabel *incomeLB;
@property (nonatomic, strong) UILabel *timeLimitTitleLB;

@property (nonatomic, strong) UILabel *incomeTitleLB;
@property (strong, nonatomic) UILabel *leastInvestmentMoneyLB;
@property (nonatomic, strong) UILabel *leastInvestmentMoneyTitleLB; //固定标签显示 起购 还是购
@property (nonatomic, strong) UILabel *incomeTitleLBOfNew;

//角标
@property (nonatomic, strong) UIImageView *cornerIM;
//新手产品 才用这个属性
@property (nonatomic, strong) UILabel *exchangeNumLB;//交易笔数
@property (nonatomic, strong) UAProgressView *progressView;

@property (nonatomic , assign)NSComparisonResult result;//判断是否开售

@property (nonatomic , strong)UIView *backView;

@property (nonatomic , strong)UIImageView *firstIM;
@property (nonatomic , strong)UIImageView *lastIM;
@property (nonatomic , strong)UIImageView *backIM;

@property (nonatomic, strong) UILabel *IM;

@property (nonatomic, strong) UILabel *strusLabel;

//初始化活动/常规产品 (包含未开售产品)
- (instancetype)initWithOtherReuseIdentifier:(NSString *)reuseIdentifier;
-(void)showOtherDataWithDic:(WidgetModel *)dic;

@end
