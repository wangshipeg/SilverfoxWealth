

#import "ProductDetailVC.h"
#import "CommitBuyInfoWebview.h"
#import "CalculateView.h"
#import "DataRequest.h"
#import "CalculateAndBuyView.h"
#import "CommunalInfo.h"
#import "StringHelper.h"
#import "NoneInvestView.h"
#import "VCAppearManager.h"
#import <SVProgressHUD.h>
#import "PromptLanguage.h"
#import "BottomBlackLineView.h"
#import "AddDetailIncomeImageView.h"
#import "CalculateProductInfo.h"
#import "SilverWealthProductCell.h"
#import "BuyBlockUpTableViewCell.h"
#import "DetailPageBuyBlockModel.h"
#import "MJRefresh.h"
#import "SCMeasureDump.h"
#import "DateHelper.h"

#import "ProductDetailWebView.h"
#import "ProductIntroduceWebView.h"
#import "ProductContractWebView.h"
#import "UIImageView+WebCache.h"
#import "HeadLineView.h"

#import "MQGradientProgressView.h"
#import "CouponShowRootVC.h"
#import "BackRebateActivityModel.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ProductDetailVC ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource,headLineDelegate>
@property (nonatomic, strong) CustomerNavgationController *customNav;
@property (nonatomic, strong) UILabel                  *yearIncomeNameLB;
@property (nonatomic, strong) UIView *titleContentView;
@property (nonatomic, strong) UIView *secondContentView;
@property (strong, nonatomic) RoundCornerClickBT       *buyBT;
@property (strong, nonatomic) UILabel                  *yearIncomeLB;
@property (strong, nonatomic) UILabel                  *financePeriodLB;
@property (strong, nonatomic) UILabel                  *exchangeFrequencyLB;
@property (nonatomic, strong) MQGradientProgressView *progressView;
@property (nonatomic, strong) UILabel *investmentLB;
@property (nonatomic, strong) UILabel *carryInterestTimeLB;
@property (nonatomic, strong) UILabel *remainderMoneyLB;
@property (nonatomic, strong) UILabel *percentLB;
@property (nonatomic, copy) SilverWealthProductDetailModel   *resultSilverWealthProduct;
@property (nonatomic, strong) CalculateView            *calculateView;
@property (nonatomic, strong) NoneInvestView *noneInvestView;
@property (nonatomic, strong) UIImageView *lineImg;
@property (nonatomic, strong) NSTimer *time;
@property (nonatomic, strong) SilverWealthProductCell *silverWPCell;
@property (nonatomic, assign) NSInteger secondNumber;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeadView;
@property (nonatomic, strong) HeadLineView *headLineView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) ProductDetailWebView *productDetailWebView;
@property (nonatomic, strong) ProductIntroduceWebView *inreoduceWebView;
@property (nonatomic, strong) ProductContractWebView *conreactWebView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UILabel *noRecordLabel;
@property (nonatomic, strong) UIImageView *imageDotView;

@property (nonatomic, strong) UIButton *bonusDetailBT;
@property (nonatomic, strong) UIView *rebateView;
@property (nonatomic, strong) NSMutableArray *rebateMutArr;
@property (nonatomic, strong) AddDetailIncomeImageView *incomeIM;
@end

@implementation ProductDetailVC
{
    int page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self animateView];
    [self loadProductDetail];
}

- (void)createBaseUI {
    UILabel *lastOrderLB = [[UILabel alloc] init];
    lastOrderLB.numberOfLines = 0;
    float height = [UILabel getHeightByWidth:[UIScreen mainScreen].bounds.size.width - 30 title:_resultSilverWealthProduct.lastOrder font:[UIFont systemFontOfSize:14]];
    if ([_resultSilverWealthProduct.cashType intValue] == 1 || [_resultSilverWealthProduct.cashType intValue] == 2) {
        height = [UILabel getHeightByWidth:[UIScreen mainScreen].bounds.size.width - 30 title:_resultSilverWealthProduct.cashAmount font:[UIFont systemFontOfSize:14]];
    }
    if (height > 0) {
        height += 5;
    }
    lastOrderLB.frame = CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 30, height * 2);
    NSString *lastOrderRebateStr;
    if (_resultSilverWealthProduct.lastOrder.length > 0) {
        lastOrderRebateStr = [NSString stringWithFormat:@"尾单可获得投资金额%@%%的银子",_resultSilverWealthProduct.lastOrder];
    }else if ([_resultSilverWealthProduct.cashType intValue] == 2){
        float number = [_resultSilverWealthProduct.cashAmount floatValue];
        float percent = number / 100;
        NSString *percentStr = [StringHelper roundValueToDoubltValue:[NSString stringWithFormat:@"%f",percent]];
        lastOrderRebateStr = [NSString stringWithFormat:@"尾单返投资金额%@%%元现金",percentStr];
    }else if([_resultSilverWealthProduct.cashType intValue] == 1){
        lastOrderRebateStr = [NSString stringWithFormat:@"尾单返%@元现金",_resultSilverWealthProduct.cashAmount];
    }
    lastOrderLB.attributedText = [StringHelper renderImageAndTextWithValue:[NSString stringWithFormat:@"  %@",lastOrderRebateStr] valueFont:14 valueColor:[UIColor zheJiangBusinessRedColor] image:[UIImage imageNamed:@"LastEntry.png"] imageFrame:CGRectMake(0, -height / 3, height , height + height / 4) index:0];
    
    UILabel *bonusStrategyLB = [[UILabel alloc] init];
    bonusStrategyLB.numberOfLines = 0;
    [bonusStrategyLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:13] characterColor:[UIColor characterBlackColor]];
    NSMutableAttributedString *bonusStr;
    if (_resultSilverWealthProduct.bonusStrategy.length > 0) {
        bonusStr = [self subRebateStringOfNumber:_resultSilverWealthProduct.bonusStrategy];
    }
    
    float height2 = [UILabel getHeightByWidth:[UIScreen mainScreen].bounds.size.width - 30 title:[bonusStr string] font:[UIFont systemFontOfSize:13]];
    if (height2 > 0) {
        height2 = height2 + height2 / 2;
    }
    bonusStrategyLB.frame = CGRectMake(15, height * 2, [UIScreen mainScreen].bounds.size.width - 30, height2);
    
    bonusStrategyLB.attributedText = bonusStr;
    
    _rebateView = [[UIView alloc] init];
    _rebateView.backgroundColor = [UIColor whiteColor];
    _tableHeadView.frame = CGRectMake(0, 0, self.view.frame.size.width, 190 + height * 2 + height2);
    _rebateView.frame = CGRectMake(0, 180, self.view.frame.size.width, height * 2 + height2);
    [_tableHeadView addSubview:_rebateView];
    [_rebateView addSubview:lastOrderLB];
    [_rebateView addSubview:bonusStrategyLB];
    
    UILabel *grayLineLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width, 0.5)];
    grayLineLB.alpha = .5;
    grayLineLB.backgroundColor = [UIColor grayColor];
    [_rebateView addSubview:grayLineLB];
    
    UILabel *grayLineLBTwo = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
    grayLineLBTwo.alpha = .5;
    grayLineLBTwo.backgroundColor = [UIColor grayColor];
    [bonusStrategyLB addSubview:grayLineLBTwo];
    
    if (height2 > 0) {
        _bonusDetailBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bonusDetailBT setTitle:@"[使用条件?]" forState:UIControlStateNormal];
        [_bonusDetailBT setTitleColor:[UIColor iconBlueColor] forState:UIControlStateNormal];
        _bonusDetailBT.titleLabel.font = [UIFont systemFontOfSize:12];
        _bonusDetailBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        if (height == 0) {
            _bonusDetailBT.frame = CGRectMake(self.view.frame.size.width - 90,height2 - 22, 80, 20);
        } else {
            _bonusDetailBT.frame = CGRectMake(self.view.frame.size.width - 90,height * 2 + height2 - 22, 80, 20);
        }
        [_bonusDetailBT addTarget:self action:@selector(handleUseInfomation) forControlEvents:UIControlEventTouchUpInside];
        _bonusDetailBT.hidden = YES;
        [_rebateView addSubview:_bonusDetailBT];
    }
}

- (NSMutableAttributedString *)subRebateStringOfNumber:(NSString *)rebateString
{
    NSMutableAttributedString *changeColorStr= [[NSMutableAttributedString alloc] init];
    NSString *rebateStr = [NSString stringWithFormat:@"  %@",rebateString];
    NSString *bonusStrategyStr = [rebateStr stringByReplacingOccurrencesOfString:@";" withString:@";\n        "];
    NSArray *components = [bonusStrategyStr componentsSeparatedByString:@";"];
    NSMutableArray *mutArr = [NSMutableArray array];
    for (int i = 0; i < components.count; i ++) {
        NSArray *subArr = [components[i] componentsSeparatedByString:@"，"];
        [mutArr addObjectsFromArray:subArr];
    }
    NSMutableArray *numberArr = [NSMutableArray array];
    for (int i = 0; i < mutArr.count; i ++) {
        if (i % 2 != 0) {
            [numberArr addObject:mutArr[i]];
        }
    }
    for (int i = 0; i < numberArr.count; i ++) {
        NSString *numStr = [StringHelper findNumFromStr:numberArr[i]];
        NSRange range = [components[i] rangeOfString:numStr];
        
        NSAttributedString *appendStr = [self setSubString:components[i] FontNumber:[UIFont systemFontOfSize:13] AndRange:range AndColor:[UIColor zheJiangBusinessRedColor] index:i];
        [changeColorStr appendAttributedString:appendStr];
    }
    return changeColorStr;
}

- (NSMutableAttributedString *)setSubString:(NSString *)string FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor index:(NSInteger)index
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSFontAttributeName value:font range:range];
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    if (index == 0) {
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:@"BackRebate.png"];
        attachment.bounds = CGRectMake(0, -6, 21, 21);
        
        NSAttributedString *textString = [NSAttributedString attributedStringWithAttachment:attachment];
        [str insertAttributedString:textString atIndex:0];
    }
    return str;
}

- (void)handleUseInfomation
{
    CouponShowRootVC *rootVC = [[CouponShowRootVC alloc] init];
    rootVC.backRebateArr = _rebateMutArr;
    [self addChildViewController:rootVC];
    [rootVC.view setFrame:self.view.frame];
    [self.view addSubview:rootVC.view];
}

- (void)loadProductDetail
{
    [[DataRequest sharedClient] achieveProductDetailWith:_productId callback:^(id obj) {
        DLog(@"产品详情加载结果=====%@",obj);
        [SVProgressHUD dismiss];
        if ([obj isKindOfClass:[SilverWealthProductDetailModel class]]) {
            SilverWealthProductDetailModel *dic = obj;
            self.resultSilverWealthProduct = dic;
            [self UIDecorate];
            [self showRebateInfomationButton];
            [self setUpSensorsAnalyticsSDK];
            [self achieveCustomerInfo];
        }
        [_tableView reloadData];
    }];
}

- (void)achieveCustomerInfo
{
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    if (user) {
        [[DataRequest sharedClient] achieveCustomerUserInfoWithcustomerId:user.customerId callback:^(id obj) {
            if ([obj isKindOfClass:[IndividualInfoManage class]]) {
                IndividualInfoManage *resultUser = obj;
                [IndividualInfoManage updateAccountWith:resultUser];
            }
        }];
    }
    [self showProductDetail];
}

- (void)showRebateInfomationButton
{
    [[DataRequest sharedClient] requestRebateActivitiesWithProductId:_productId callback:^(id obj) {
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *rebateArr = [NSArray arrayWithArray:obj];
            _rebateMutArr = [NSMutableArray array];
            for (BackRebateActivityModel *rebateModel in rebateArr) {
                if ([rebateModel.type intValue] == 3 || [rebateModel.type intValue] == 4) {
                    _bonusDetailBT.hidden = NO;
                    [_rebateMutArr addObject:rebateModel];
                }
            }
        }
    }];
}

- (void)setUpSensorsAnalyticsSDK
{
    BOOL isRebateOrNot = NO;
    BOOL isFirstOrderRewardOrNot = NO;
    BOOL isLastOrderRewardOrNot = NO;
    if (_resultSilverWealthProduct.bonusStrategy.length > 1) {
        isRebateOrNot = YES;
    }
    if (_resultSilverWealthProduct.firstOrder.length > 1) {
        isFirstOrderRewardOrNot = YES;
    }
    if (_resultSilverWealthProduct.lastOrder.length > 0) {
        isLastOrderRewardOrNot = YES;
    }
    NSString *increaseIntreastStr;
    if (_resultSilverWealthProduct.increaseInterest) {
        if ([_resultSilverWealthProduct.increaseInterest doubleValue] > 0) {
            increaseIntreastStr = _resultSilverWealthProduct.increaseInterest;
        }
    }
    [[SensorsAnalyticsSDK sharedInstance] track:@"ProductView"
                                 withProperties:@{
                                                  @"ProductName" : _resultSilverWealthProduct.name,
                                                  @"ProductCategory" : _resultSilverWealthProduct.property,
                                                  @"FinancePeriod": @([_resultSilverWealthProduct.financePeriod integerValue]),
                                                  @"YearIncome":@([_resultSilverWealthProduct.yearIncome floatValue]),
                                                @"IncreaseIntreast":@([increaseIntreastStr floatValue]),
                                                  @"RebateOrNot": isRebateOrNot ? @YES : @NO,
                                                  @"FirstOrderRewardOrNot": isFirstOrderRewardOrNot ? @YES : @NO,
                                                  @"LastOrderRewardOrNot": isLastOrderRewardOrNot ? @YES : @NO,
                                                  @"TotalAmount":@([_resultSilverWealthProduct.totalAmount intValue]),
                                                  @"LowestAmount":@([_resultSilverWealthProduct.lowestMoney intValue]),
                                                  }];
}
//设置产品详情
- (void)showProductDetail
{
    self.title = _resultSilverWealthProduct.name;
    _customNav.titleLabel.text = _resultSilverWealthProduct.name;
    NSString * outNumber = [StringHelper roundValueToDoubltValue:_resultSilverWealthProduct.yearIncome];
    self.yearIncomeLB.attributedText = [StringHelper renderDetailYearIncomeWithValue:outNumber  valueFont:40 percentFont:25];
    self.financePeriodLB.text = [NSString stringWithFormat:@"理财期限\n%ld天",(long)[_resultSilverWealthProduct.financePeriod  integerValue]];
    if (![_resultSilverWealthProduct.label isEqual:@""]) {
        self.exchangeFrequencyLB.text = [NSString stringWithFormat:@" %@ ",_resultSilverWealthProduct.label];
    } else {
        [self.exchangeFrequencyLB removeFromSuperview];
    }
    if ([_resultSilverWealthProduct.interestType intValue] == 0) {
        self.carryInterestTimeLB.text = [NSString stringWithFormat:@"起息时间\n%@",_resultSilverWealthProduct.interestDate];
    }else if ([_resultSilverWealthProduct.interestType intValue] == 1){
        if (_resultSilverWealthProduct.interestDate.length == 0) {
            self.carryInterestTimeLB.text = [NSString stringWithFormat:@"起息时间\nT+1起息"];
        }else{
            self.carryInterestTimeLB.text = [NSString stringWithFormat:@"起息时间\n%@",_resultSilverWealthProduct.interestDate];
        }
    }else if ([_resultSilverWealthProduct.interestType intValue] == 2){
        self.carryInterestTimeLB.text = [NSString stringWithFormat:@"起息时间\n购买当天起息"];
    }
    
    //剩余可投金额
    NSString *str = [NSString stringWithFormat:@"%d",[_resultSilverWealthProduct.totalAmount intValue] - [_resultSilverWealthProduct.actualAmount intValue]];
    self.remainderMoneyLB.attributedText = [StringHelper renderPurchaseFrequencyWith:str];
    //百分比
    NSString *percentStr = [NSString stringWithFormat:@"%f",[[CalculateProductInfo calculateProductCollectProgressWith:_resultSilverWealthProduct] doubleValue]];
    //向下取整
    float b = [percentStr floatValue];
    int a;
    a = floor(b * 100);
    _percentLB.text = [NSString stringWithFormat:@"%d%%",a];
    
    if ([_resultSilverWealthProduct.increaseInterest floatValue] > 0) {
        NSString *increaseInterest = [StringHelper roundValueToDoubltValue:_resultSilverWealthProduct.increaseInterest];
        _incomeIM = [[AddDetailIncomeImageView alloc] initWithAddIncomeValue:increaseInterest];
        [_titleContentView addSubview:_incomeIM];
        [_incomeIM mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_yearIncomeLB.mas_right);
            make.bottom.equalTo(_yearIncomeLB.mas_bottom).offset(-10);
            make.height.equalTo(@20);
        }];
    }else{
        _incomeIM = [[AddDetailIncomeImageView alloc] initWithAddIncomeValue:@""];
        [_titleContentView addSubview:_incomeIM];
        [_incomeIM mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_yearIncomeLB.mas_right);
            make.bottom.equalTo(_yearIncomeLB.mas_bottom).offset(-10);
            make.height.equalTo(@20);
            make.width.equalTo(@0);
        }];
    }
    UILabel *label = [[UILabel alloc] init];
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    if (user) {
        [[DataRequest sharedClient] requestProductDetailAndSilverStoreCouponWithCustomerId:user.customerId type:@"7" callback:^(id obj) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = obj;
                if ([dict[@"data"] doubleValue] > 0) {
                    NSString *vipInterestStr = [StringHelper roundValueToDoubltValue:dict[@"data"]];
                    label.attributedText = [StringHelper renderImageAndTextWithValue:[NSString stringWithFormat:@"+ %@%%",vipInterestStr] valueFont:16 valueColor:[UIColor whiteColor] image:[UIImage imageNamed:[NSString stringWithFormat:@"v_%@",user.vipLevel]] imageFrame:CGRectMake(0, 0, 15, 15) index:1];
                    [_titleContentView addSubview:label];
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(_incomeIM.mas_right);
                        make.bottom.equalTo(_yearIncomeLB.mas_bottom).offset(-10);
                        make.height.equalTo(@20);
                    }];
                }
            }
        }];
    }
    
    if ([_resultSilverWealthProduct.versionDiscriminate intValue] == 2)
    {
        [_headLineView setTitleArray:@[@"产品详情",@"风控审核",@"安全保障",@"购买记录"]];
    } else if ([_resultSilverWealthProduct.versionDiscriminate intValue] == 1){
        if ([_resultSilverWealthProduct.existContract intValue] == 0) {
            [_headLineView setTitleArray:@[@"产品详情",@"项目介绍",@"合同协议",@"购买记录"]];
        } else {
            [_headLineView setTitleArray:@[@"产品详情",@"购买记录"]];
        }
    }
    //进度条
    [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(run)userInfo:nil repeats:NO];
    //返利图标
    if (_resultSilverWealthProduct.lastOrder.length > 0 || _resultSilverWealthProduct.bonusStrategy.length > 0 || [_resultSilverWealthProduct.cashType intValue] == 1 || [_resultSilverWealthProduct.cashType intValue] == 2) {
        [self performSelector:@selector(createBaseUI) withObject:nil];
    }else{
        _tableHeadView.frame = CGRectMake(0, 0, self.view.frame.size.width, 190);
    }
    
    BOOL isBeginSale = [CalculateProductInfo calculateProdcutBeginSaleWith:_resultSilverWealthProduct];
    if (isBeginSale) {
        [self NotOnSale];
        return;
    }
    BOOL isSellout=[CalculateProductInfo calculateProdcutDetailWhetherSelloutWith:_resultSilverWealthProduct];
    if (isSellout) {
        [self notCanButProduct];
    }else{
        [self canBuyProduct];
    }
}

-(void)calculator
{
    if (!self.resultSilverWealthProduct) {
        return;
    }
    if (!_calculateView) {
        _calculateView = [[[NSBundle mainBundle] loadNibNamed:@"CommenCell" owner:self options:nil] objectAtIndex:0];
    }
    _calculateView.productModel = self.resultSilverWealthProduct;
    [_calculateView show];
}

#pragma -mark 点击购买
- (void)buyProduct
{
    [MobClick event:@"product_detail_purchase_btn"];
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    if (!user) {
        [VCAppearManager presentLoginVCWithCurrentVC:self];
        return;
    }
    _buyBT.userInteractionEnabled = NO;
    [self isDredgeBankDepository];
}

- (void)isDredgeBankDepository
{
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [self achieveCurrentUserInfo:user];
}

- (void)achiveWeatherSetUpTradePassword:(IndividualInfoManage *)user
{
    [[DataRequest sharedClient]requestWhetherSetUpTradePasswordAccountId:user.accountId callback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"pinFlag"] intValue] == 1) {
                [self inspectWhetherAlreadyBuy:user];
            }else{
                [SCMeasureDump shareSCMeasureDump].openAccountPresentVC = @"other";
                [VCAppearManager presentSetUpTradePasswordVC:self];
            }
        }
        if ([obj isKindOfClass:[NSString class]]) {
            _buyBT.userInteractionEnabled = YES;
            [SVProgressHUD showErrorWithStatus:obj];
        }
    }];
}

- (void)achieveCurrentUserInfo:(IndividualInfoManage *)user
{
    if (user.accountId.length == 0) {
        [self achiveUserInfo:user];
    }else if(user.accountId.length > 0){
        [self achiveWeatherSetUpTradePassword:user];
    }
}

- (void)achiveUserInfo:(IndividualInfoManage *)user
{
    if (user.accountId.length == 0) {
        [SVProgressHUD dismiss];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您还未开通银行存管账户\n是否开通?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"以后再说" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"立即开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [VCAppearManager presentPersonalAmountCurrentVC:self];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if (user.accountId.length > 0){
        [self achiveWeatherSetUpTradePassword:user];
    }
}

- (void)inspectWhetherAlreadyBuy:(IndividualInfoManage *)user
{
    [[DataRequest sharedClient] inspectUserIsAlreadyProductWithProductId:self.resultSilverWealthProduct.productId customerId:user.customerId callback:^(id obj) {
        _buyBT.userInteractionEnabled = YES;
        DLog(@"检查是否购买某产品====%@",obj);
        _buyBT.userInteractionEnabled = YES;
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *resultStr = obj[@"code"];
            if ([resultStr integerValue] == 8001) {
                [SVProgressHUD dismiss];
                if (!_noneInvestView) {
                    _noneInvestView=[[NoneInvestView alloc] initWithFrame:CGRectMake(0, 0, 300, 110)];
                    _noneInvestView.noteLB.text=[PromptLanguage alreadyBuyThisProductWith:self.resultSilverWealthProduct.property];
                }
                [_noneInvestView show];
            }else if ([resultStr integerValue] == 2000){
                [self enterBuyPageTwoStep];
            }
        }
    }];
}

- (void)enterBuyPageTwoStep
{
    _buyBT.userInteractionEnabled = YES;
    CommitBuyInfoWebview *buyView=[[CommitBuyInfoWebview alloc] init];
    buyView.productId = self.productId;
    [self.navigationController pushViewController:buyView animated:YES];
}

//已经售罄
- (void)notCanButProduct {
    //到期时间(起息时间加上理财期限)
    NSString *timeStr = [CalculateProductInfo calculateTimeWith:_resultSilverWealthProduct.interestDate spaceDayTime:_resultSilverWealthProduct.financePeriod];
    NSString *dueTime = [timeStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *incomeTimeStr = [[SCMeasureDump shareSCMeasureDump].nowTime substringToIndex:10];
    NSString *dateStr = [incomeTimeStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if ([dateStr intValue] > [dueTime intValue] || [dateStr intValue] == [dueTime intValue]) {
        [self.buyBT setTitle:@"已还款" forState:UIControlStateNormal];
        [self.buyBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.remainderMoneyLB.text = @"已还款";
    } else {
        [self.buyBT setTitle:@"待还款" forState:UIControlStateNormal];
        [self.buyBT setTitleColor:[UIColor zheJiangBusinessRedColor] forState:UIControlStateNormal];
        self.remainderMoneyLB.text = @"待还款";
    }
    self.buyBT.backgroundColor=[UIColor typefaceGrayColor];
    self.buyBT.userInteractionEnabled=NO;
    self.remainderMoneyLB.textColor = [UIColor characterBlackColor];
}

- (void)NotOnSale
{
    self.remainderMoneyLB.text = @"未开始";
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [inputFormatter dateFromString:[SCMeasureDump shareSCMeasureDump].nowTime];
    NSDate *inputShippedTimeDate = [inputFormatter dateFromString:_resultSilverWealthProduct.shippedTime];
    self.secondNumber = [DateHelper secondAfterNumWithAnotherDate:inputShippedTimeDate selfDate:inputDate];
    self.time =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.time forMode:UITrackingRunLoopMode];
}
//倒计时
- (void)timerFireMethod:(NSTimer *)time
{
    if (self.secondNumber < 0 || self.secondNumber == 0) {
        [self.time invalidate];
        self.time = nil;
        
        NSString *str = [NSString stringWithFormat:@"%d",[_resultSilverWealthProduct.totalAmount intValue] - [_resultSilverWealthProduct.actualAmount intValue]];
        self.remainderMoneyLB.attributedText = [StringHelper renderPurchaseFrequencyWith:str];
        
        self.buyBT.backgroundColor=[UIColor zheJiangBusinessRedColor];
        self.buyBT.userInteractionEnabled=YES;
        [self.buyBT setTitle:@"购买" forState:UIControlStateNormal];
        return ;
    }
    [self.buyBT setBackgroundColor:[UIColor typefaceGrayColor]];
    self.buyBT.userInteractionEnabled = NO;
    [self.buyBT setTitle:[NSString stringWithFormat:@"%@",[self lessSecondToDay:self.secondNumber--]] forState:UIControlStateNormal];
}

- (NSString *)lessSecondToDay:(NSUInteger)seconds
{
    NSUInteger day  = (NSUInteger)seconds/(24*3600);
    NSUInteger hour = (NSUInteger)(seconds%(24*3600))/3600;
    NSUInteger min  = (NSUInteger)(seconds%(3600))/60;
    NSUInteger second = (NSUInteger)(seconds%60);
    NSString *time = [NSString stringWithFormat:@"%02lu小时%02lu分%02lu秒后开售",(unsigned long)day * 24 +(unsigned long)hour,(unsigned long)min,(unsigned long)second];
    return time;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)canBuyProduct {
    self.buyBT.backgroundColor = [UIColor zheJiangBusinessRedColor];
    self.buyBT.userInteractionEnabled = YES;
    [self.buyBT setTitle:@"购买" forState:UIControlStateNormal];
}

- (void)refreshHeadLine:(NSInteger)currentIndex
{
    if (_headLineView.titleArray.count == 4) {
        _currentIndex = currentIndex;
        if (currentIndex == 0) {
            [MobClick event:@"product_detail_tab0"];
            [_tableView reloadData];
        } else if (currentIndex == 1) {
            [MobClick event:@"product_detail_tab1"];
            [_tableView reloadData];
        } else if (currentIndex == 2) {
            [MobClick event:@"product_detail_tab2"];
            [_tableView reloadData];
        } else {
            [MobClick event:@"product_detail_tab3"];
        }
        if (currentIndex == 3) {
            [self.dataSource removeAllObjects];
            page = 1;
            [self loadUrlDetail];
            __weak typeof(self) weakSelf = self;
            weakSelf.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                page ++;
                [weakSelf loadUrlDetail];
            }];
        }else{
            if (_noRecordLabel) {
                _noRecordLabel.hidden = YES;
            }
            self.tableView.mj_footer.hidden = YES;
        }
    }else if(_headLineView.titleArray.count == 2){
        if (currentIndex == 0) {
            [MobClick event:@"product_detail_tab0"];
        }else{
            [MobClick event:@"product_detail_tab3"];
        }
        _currentIndex = currentIndex;
        [_tableView reloadData];
        if (currentIndex == 1) {
            [self.dataSource removeAllObjects];
            page = 1;
            [self loadUrlDetail];
            __weak typeof(self) weakSelf = self;
            weakSelf.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                page ++;
                [weakSelf loadUrlDetail];
            }];
        } else {
            if (_noRecordLabel) {
                _noRecordLabel.hidden = YES;
            }
            self.tableView.mj_footer.hidden = YES;
        }
    }
}

- (void)animateView
{
    [SCMeasureDump shareSCMeasureDump].webProductId = _productId;
    //[SVProgressHUD showWithStatus:PleaseWaitALittleWhile];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 114) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *))
    {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    if (IS_iPhoneX) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, iPhoneX_Navigition_Bar_Height, WIDTH, HEIGHT - iPhoneX_Navigition_Bar_Height - 34 - 49) style:UITableViewStylePlain];
    }
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.bounces = NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];

    self.buyBT = [RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    self.buyBT.titleLabel.numberOfLines = 2;
    self.buyBT.titleLabel.textAlignment=NSTextAlignmentCenter;
    CalculateAndBuyView *CBView = [[CalculateAndBuyView alloc]  initWith:_buyBT];
    [CBView achieveClickEventWith:^{
        [MobClick event:@"calculator_btn_click"];
        [self calculator];
    } buBlock:^{
        [MobClick event:@"purchase_btn"];
        [SVProgressHUD showWithStatus:PleaseWaitALittleWhile];
        [self buyProduct];
    }];
    [self.view addSubview:CBView];
    if (IS_iPhoneX) {
        [CBView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
            make.height.equalTo(@83);
        }];
    } else {
        [CBView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
            make.height.equalTo(@50);
        }];
    }
    _productDetailWebView = [[ProductDetailWebView alloc] init];
    _conreactWebView = [[ProductContractWebView alloc] init];
    [self addNewMessageObserve];
}

- (void)loadUrlDetail
{
    [[DataRequest sharedClient] achieveProductDetailBuyBlockUpWith:page productId:_productId callback:^(id obj) {
        [self.tableView.mj_footer  endRefreshing];
        if (obj == nil && page != 1) {
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }else if (obj == nil && page == 1){
            self.tableView.mj_footer.hidden = YES;
        }else if ([obj isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:obj];
            self.tableView.mj_footer.hidden = NO;
            [self loadSilverDetailDataWith:array];
        }
        [self.tableView reloadData];
    }];
}

- (void)loadSilverDetailDataWith:(NSMutableArray *)dic
{
    if (!self.dataSource) {
        self.dataSource=[NSMutableArray array];
    }
    [self.dataSource addObjectsFromArray:dic];
}

- (void)addNewMessageObserve {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(addMessageNoteWith) name:@"webProductDetail" object:nil];
}

- (void)addMessageNoteWith
{
   [self.tableView reloadData];
}

#pragma mark ---- UITableViewDelegate ----
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_headLineView.titleArray.count == 2) {
        if (_currentIndex == 0) {
            return _productDetailWebView.webView.frame.size.height;
        }
        return 60;
    } else if (_headLineView.titleArray.count == 4) {
        if (_currentIndex == 0) {
            return _productDetailWebView.webView.bounds.size.height;
        }else if (_currentIndex == 1){
            return _inreoduceWebView.webView.frame.size.height;
        }else if(_currentIndex == 2){
            return _conreactWebView.webView.frame.size.height;
        }
        if (self.dataSource.count > 0) {
            return 60;
        }
        if (IS_iPhoneX) {
            return HEIGHT - iPhoneX_Navigition_Bar_Height - 49 - 34 - 40;
        }
        return HEIGHT - 114 - 40;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_headLineView.titleArray.count == 2)
    {
        if (_currentIndex == 1) {
            return _dataSource.count;
        }
        return 1;
    }else if (_headLineView.titleArray.count == 4){
        if (_currentIndex == 3) {
            if (self.dataSource.count == 0) {
                return 1;
            }
            return _dataSource.count;
        }
        return 1;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!_headLineView) {
        _headLineView = [[HeadLineView alloc] init];
        _headLineView.frame = CGRectMake(0, 0, WIDTH, 40);
        _headLineView.delegate = self;
    }
    return _headLineView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_headLineView.titleArray.count == 4) {
        if (_currentIndex == 0) {
            static NSString *identifier = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell){
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                //_productDetailWebView.frame = cell.frame;
                [cell addSubview:_productDetailWebView];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            return cell;
        }else if(_currentIndex == 1){
            static NSString *identifier = @"cell1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell){
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            _inreoduceWebView.frame = CGRectMake(0, 0, WIDTH, 1000);
            [cell addSubview:_inreoduceWebView];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }else if(_currentIndex == 2){
            static NSString *identifier = @"cell2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell){
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            _conreactWebView.frame = CGRectMake(0, 0, WIDTH, 1000);
            [cell addSubview:_conreactWebView];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }else if (_currentIndex == 3){
            static NSString *assetCellIdentifier = @"MyAssetCell";
            BuyBlockUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:assetCellIdentifier];
            if (!cell) {
                cell = [[BuyBlockUpTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:assetCellIdentifier];
            }
            if (self.dataSource.count == 0) {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.backgroundColor = [UIColor whiteColor];
                _noRecordLabel = [[UILabel alloc] init];
                _noRecordLabel.textColor = [UIColor characterBlackColor];
                _noRecordLabel.font = [UIFont systemFontOfSize:15];
                _noRecordLabel.textAlignment = NSTextAlignmentCenter;
                _noRecordLabel.frame = CGRectMake(10, 30, WIDTH - 20, 20);
                _noRecordLabel.text = @"暂无购买记录!";
                [cell addSubview:_noRecordLabel];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            DetailPageBuyBlockModel *model = [self.dataSource objectAtIndex:indexPath.row];
            if (!model) {
                return nil;
            }
            [cell buyBlockupWith:model];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    if (_headLineView.titleArray.count == 2) {
        if (_currentIndex == 0) {
            static NSString *identifier = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell){
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                _productDetailWebView = [[ProductDetailWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 1000)];
                //_productDetailWebView.frame = cell.frame;
                [cell addSubview:_productDetailWebView];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            return cell;
        }else if (_currentIndex == 1){
            static NSString *assetCellIdentifier = @"MyAssetCell";
            BuyBlockUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:assetCellIdentifier];
            if (!cell) {
                cell = [[BuyBlockUpTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:assetCellIdentifier];
            }
            if (self.dataSource.count == 0) {
                return cell;
            }
            DetailPageBuyBlockModel *model = [self.dataSource objectAtIndex:indexPath.row];
            if (!model) {
                return nil;
            }
            [cell buyBlockupWith:model];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return nil;
}

- (void)UIDecorate {
    _inreoduceWebView = [[ProductIntroduceWebView alloc] init];
    
    _tableHeadView = [[UIView alloc] init];
    _tableHeadView.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
    _tableHeadView.backgroundColor = [UIColor backgroundGrayColor];
    [_tableView setTableHeaderView:_tableHeadView];
    [_tableView bringSubviewToFront:_tableHeadView];
    
    _titleContentView = [[UIView alloc] init];
    _titleContentView.backgroundColor = [UIColor zheJiangBusinessRedColor];
    [_tableHeadView addSubview:_titleContentView];
    _titleContentView.frame = CGRectMake(0, 0, self.view.frame.size.width, 120);
    _secondContentView = [[UIView alloc] init];
    _secondContentView.backgroundColor=[UIColor whiteColor];
    [_tableHeadView addSubview:_secondContentView];
    [_secondContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleContentView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@60);
    }];
    
    //预计年化收益 固定标题
    _yearIncomeNameLB=[[UILabel alloc] init];
    [_yearIncomeNameLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor whiteColor]];
    _yearIncomeNameLB.text=@"预期年化收益";
    [_titleContentView addSubview:_yearIncomeNameLB];
    [_yearIncomeNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleContentView.mas_top).offset(20);
        make.left.equalTo(_titleContentView.mas_left).offset(15);
        //make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    
    //显示年化收益
    _yearIncomeLB=[[UILabel alloc] init];
    [_yearIncomeLB decorateLabelStyleWithCharacterFont:[UIFont fontWithName:@"Helvetica" size:45] characterColor:[UIColor whiteColor]];
    _yearIncomeLB.text=@"-----";
    [_titleContentView addSubview:_yearIncomeLB];
    [_yearIncomeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleContentView.mas_left).offset(15);
        make.top.equalTo(_yearIncomeNameLB.mas_bottom).offset(10);
        make.bottom.equalTo(_titleContentView.mas_bottom).offset(-10);
    }];
    _yearIncomeLB.adjustsFontSizeToFitWidth = YES;
    
    //标签活动
    _exchangeFrequencyLB=[[UILabel alloc] init];
    _exchangeFrequencyLB.text=@"---";
    [_exchangeFrequencyLB decorateLabelStyleWithCharacterFont:[UIFont fontWithName:@"Helvetica" size:15] characterColor:[UIColor whiteColor]];
    _exchangeFrequencyLB.backgroundColor = [UIColor yellowSilverfoxColor];
    _exchangeFrequencyLB.layer.cornerRadius = 5;
    _exchangeFrequencyLB.layer.masksToBounds = YES;
    [_titleContentView addSubview:_exchangeFrequencyLB];
    [_exchangeFrequencyLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleContentView.mas_top).offset(22);
        make.right.equalTo(_titleContentView.mas_right).offset(-15);
        make.height.equalTo(@17);
    }];
    
    //显示理财期限
    _financePeriodLB=[[UILabel alloc] init];
    _financePeriodLB.textAlignment=NSTextAlignmentRight;
    [_financePeriodLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor whiteColor]];
    _financePeriodLB.text=@"-----";
    _financePeriodLB.numberOfLines = 0;
    [_titleContentView addSubview:_financePeriodLB];
    [_financePeriodLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleContentView.mas_top).offset(60);
        make.right.equalTo(_titleContentView.mas_right).offset(-15);
        make.width.equalTo(@130);
        make.height.equalTo(@45);
    }];
    
    //起息时间
    _carryInterestTimeLB = [[UILabel alloc] init];
    _carryInterestTimeLB.text = @"----";
    _carryInterestTimeLB.numberOfLines = 0;
    _carryInterestTimeLB.textAlignment = NSTextAlignmentCenter;
    _carryInterestTimeLB.font = [UIFont systemFontOfSize:14];
    [_secondContentView addSubview:_carryInterestTimeLB];
    _carryInterestTimeLB.textColor = [UIColor characterBlackColor];
    [_carryInterestTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_secondContentView.mas_top).offset(12);
        make.width.equalTo(@100);
        make.left.equalTo(_secondContentView.mas_left);
        make.height.equalTo(@40);
    }];
    //分割线
    _lineImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grayLine.png"]];
    [_secondContentView addSubview:_lineImg];
    [_lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_secondContentView.mas_top).offset(15);
        make.width.equalTo(@1);
        make.left.equalTo(_carryInterestTimeLB.mas_right);
        make.height.equalTo(@30);
    }];
    //剩余可投金额
    _remainderMoneyLB = [[UILabel alloc] init];
    _remainderMoneyLB.text = @"---";
    _remainderMoneyLB.textColor = [UIColor characterBlackColor];
    [_secondContentView addSubview:_remainderMoneyLB];
    _remainderMoneyLB.font = [UIFont systemFontOfSize:14];
    [_remainderMoneyLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_secondContentView.mas_top).offset(17);
        make.right.equalTo(_secondContentView.mas_right);
        make.left.equalTo(_lineImg.mas_right).offset(15);
        make.height.equalTo(@15);
    }];
    
    _progressView = [[MQGradientProgressView alloc] init];
    _progressView.colorArr = @[(id)MQRGBColor(76, 167, 238).CGColor,(id)MQRGBColor(76, 238, 228).CGColor,(id)MQRGBColor(76, 167, 238).CGColor];
    _progressView.backgroundColor = [UIColor colorWithRed:216 green:216 blue:216];
    [_secondContentView addSubview:_progressView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_remainderMoneyLB.mas_bottom).offset(10);
        make.left.equalTo(_lineImg.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-55);
        make.height.equalTo(@1);
    }];
    DLog(@"%f",self.progressView.frame.size.width);
    _imageDotView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ProgressDot.png"]];
    _imageDotView.frame = CGRectMake(self.progressView.frame.size.width * _progressView.progress, -2, 8, 5);
    [_progressView addSubview:_imageDotView];
    
    _investmentLB = [[UILabel alloc] init];
    _investmentLB.text = @"";
    _investmentLB.textColor = [UIColor depictBorderGrayColor];
    [_secondContentView addSubview:_investmentLB];
    _investmentLB.font = [UIFont systemFontOfSize:13];
    [_investmentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_progressView.mas_bottom).offset(2);
        make.left.equalTo(_lineImg.mas_right).offset(15);
        make.height.equalTo(@15);
    }];
    
    //显示百分比
    _percentLB = [[UILabel alloc] init];
    [_secondContentView addSubview:_percentLB];
    _percentLB.text = @"---";
    _percentLB.textColor = [UIColor zheJiangBusinessRedColor];
    _percentLB.font = [UIFont systemFontOfSize:14];
    [_percentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_remainderMoneyLB.mas_bottom).offset(3);
        make.right.equalTo(_secondContentView.mas_right);
        make.left.equalTo(_progressView.mas_right).offset(15);
        make.height.equalTo(@15);
    }];
}

- (void)run
{
    [_progressView setProgress:[[CalculateProductInfo calculateProductCollectProgressWith:_resultSilverWealthProduct] doubleValue]];
    _imageDotView.frame = CGRectMake(self.progressView.frame.size.width * _progressView.progress, -2, 8, 5);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    if (_resultSilverWealthProduct) {
        _customNav.titleLabel.text = _resultSilverWealthProduct.name;
    }
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    weakSelf.customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}


@end


