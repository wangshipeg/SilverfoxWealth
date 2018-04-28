//
//  RefinedProductCell.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/7/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerSeparateTableViewCell.h"
#import "BlackBorderBT.h"
#import "SilverWealthProductModel.h"
#import "SilverWealthProductDetailModel.h"
#import "UAProgressView.h"
#import "RecommendContentModel.h"
#import "MQGradientProgressView.h"

typedef void (^SafeBTBlock)();//安全保障
typedef void (^NoviceGuideBlock)();//新手指引
typedef void (^SignInBlock)();//签到有礼
typedef void (^SilverGoodsBlock)();//银子商城

@interface RefinedProductCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *incomeLB;
@property (nonatomic, strong) UILabel *IM;
@property (nonatomic, strong) UIImageView *cornerIM;
@property (nonatomic, strong) UAProgressView *progressView;
@property (nonatomic, strong) UILabel *leastInvestmentMoneyLB;
@property (nonatomic, strong) UILabel *incomeTitleLB;
@property (nonatomic, strong) UILabel *timeLimitTitleLB;
@property (nonatomic , assign)NSComparisonResult result;

@property (strong, nonatomic) UILabel         *recommendProductNameLB;
@property (strong, nonatomic) UILabel         *recommendProductYearIncomeLB;
@property (nonatomic, strong) UILabel *infomationLB;//购买送xx
@property (nonatomic, strong) UILabel *timeLimitLB;//理财期限
@property (nonatomic, strong) UILabel *timeLimitText;//理财期限
@property (nonatomic, strong) UILabel *buyMoneyLB;//起购金额
@property (nonatomic, strong) UILabel *buyMoneyText;//起购金额
@property (strong, nonatomic) UIButton *buyBT;//购买按钮
@property (nonatomic, copy) SafeBTBlock safeBlock;//传递安全保障点击事件
@property (nonatomic, copy) NoviceGuideBlock noviceBlock;//传递新手指引点击事件
@property (nonatomic, copy) SignInBlock signInBlock;//传递签到有礼事件
@property (nonatomic, copy) SilverGoodsBlock silverBlock;//传递银子商城事件
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *leastInvestmentMoneyTitleLB;
@property (nonatomic, strong) MQGradientProgressView *progressLineView;
@property (nonatomic, strong) UIImageView *imageDotView;
@property (nonatomic, strong) UILabel *surplusAmountLB;

@property (nonatomic, strong) UIButton *noviceBT;
@property (nonatomic, strong) UIButton *signInBT;
@property (nonatomic, strong) UIButton *silverGoodsBT;
@property (nonatomic, strong) UIButton *safeBT;

@property (nonatomic, strong) UILabel *strusLabel;


- (instancetype)initWithFourReuseIdentifier:(NSString *)reuseIdentifier;


- (void)showFourDaraWithDic;


//初始化活动/常规产品 (包含未开售产品)
- (instancetype)initWithOtherReuseIdentifier:(NSString *)reuseIdentifier;
-(void)showOtherDataWithDic:(SilverWealthProductModel *)dic;
@end





