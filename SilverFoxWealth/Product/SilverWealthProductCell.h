

#import <UIKit/UIKit.h>
#import "SilverWealthProductModel.h"
#import "AddIncomeImageView.h"
#import "MQGradientProgressView.h"

@interface SilverWealthProductCell :UITableViewCell

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
@property (nonatomic, strong) UIView  *backView;
@property (nonatomic, strong) MQGradientProgressView *progressLineView;
@property (nonatomic, strong)  UIImageView *imageDotView;
@property (nonatomic, strong) UILabel *surplusAmountLB;
//角标
@property (nonatomic, strong) UIImageView *cornerIM;
//新手产品 才用这个属性
@property (nonatomic, strong) UILabel *exchangeNumLB;//交易笔数
@property (nonatomic , assign)NSComparisonResult result;//判断是否开售

@property (nonatomic , strong)UIImageView *lastImg;

@property (nonatomic, strong) UILabel *IM;

@property (nonatomic, strong) UILabel *strusLabel;

//初始化活动/常规产品 (包含未开售产品)
- (instancetype)initWithOtherReuseIdentifier:(NSString *)reuseIdentifier;
- (void)showOtherDataWithDic:(SilverWealthProductModel *)dic;

@end
