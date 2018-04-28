

#import "AlreadyBuyProductDetailVC.h"
#import "DataRequest.h"
#import "ProductDetailVC.h"
#import "CommunalInfo.h"
#import "WithoutAuthorization.h"
#import "DateHelper.h"
#import "VCAppearManager.h"
#import <SVProgressHUD.h>
#import "PromptLanguage.h"
#import "TopBottomBalckBorderAndArrowView.h"
#import "AlreadyBuyProductDetailCustomView.h"
#import "UILabel+LabelStyle.h"
#import "CalculateProductInfo.h"
#import "NoShareWebView.h"
#import "AlreadyBuyProductsDetailModel.h"
#import "CommunalInfo.h"
#import "StringHelper.h"
#import "WithoutAuthorization.h"
#import "UserInfoUpdate.h"

#define CUSTOM_CELL_HEIGHT 50

@interface AlreadyBuyProductDetailVC ()
@property (nonatomic, strong) CustomerNavgationController *customNav;
@property (strong, nonatomic) UILabel             *productNameLB;
@property (strong, nonatomic) UILabel             *remainingDaysLB;
@property (strong, nonatomic) UILabel             *purchaseTimeLB;
@property (strong, nonatomic) UILabel             *expireTimeLB;
@property (strong, nonatomic) UILabel             *generationIncomeTimeLB;
@property (strong, nonatomic) UILabel             *purchaseSumLB;
@property (strong, nonatomic) UILabel             *productInterestLB;
@property (nonatomic, strong) UILabel *baseProfitLB;
@property (nonatomic, strong) UILabel             *useRebateLB;
@property (strong, nonatomic) UILabel             *signatureLB;
@property (nonatomic, strong) UILabel *vipInterestLB;

@property (nonatomic, strong) AlreadyBuyProductsDetailModel *detailModel;

@property (nonatomic, strong) AlreadyBuyProductDetailCustomView *incomeNumBackView;
@property (nonatomic, strong) AlreadyBuyProductDetailCustomView *purchaseSumBackView;
@property (nonatomic, strong)  AlreadyBuyProductDetailCustomView *expireTimeBackView;
@property (nonatomic, strong)  AlreadyBuyProductDetailCustomView *purchaseBackView;
@property (nonatomic, strong)  TopBottomBalckBorderAndArrowView *signatureView;
@property (nonatomic, strong)  AlreadyBuyProductDetailCustomView *generationIncomeTimeBackView;
@property (nonatomic, strong)  AlreadyBuyProductDetailCustomView *bankInfoBackView;
@property (nonatomic, strong)  AlreadyBuyProductDetailCustomView *vipInterestView;

@end

@implementation AlreadyBuyProductDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
    [self achieveProductDetail];
}

- (void)achieveProductDetail {
    [[DataRequest sharedClient] obtainUserAlreadyPurchaseProductDetailWithOrderNO:_infoModel.orderNO callback:^(id obj) {
        
        if ([obj isKindOfClass:[AlreadyBuyProductsDetailModel class]]) {
            _detailModel = obj;
            [self showAlreadyPurchaseProductDetail:_detailModel];
        }
        if ([obj isKindOfClass:[WithoutAuthorization class]]) {
            [UserInfoUpdate clearUserLocalInfo];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [VCAppearManager presentLoginVCWithCurrentVC:self];
        }
    }];
}

- (void)showAlreadyPurchaseProductDetail:(AlreadyBuyProductsDetailModel *)model {
    _productNameLB.text = model.productName;
    
    if ([model.interestType intValue] == 0) {
        //固定起息
        if ([model.remainingDays intValue] < 1) {
            _remainingDaysLB.text = @"回款中";
        }else{
            _remainingDaysLB.text = [NSString stringWithFormat:@"剩余%@天到期",model.remainingDays];
        }
        if ([model.remainingDays intValue] < 1 && [model.status intValue] != 3) {
            _remainingDaysLB.text = @"回款中";
        }else if ([model.remainingDays intValue] < 1 && [model.status intValue] == 3) {
            _remainingDaysLB.text = @"已回款";
        }
    }else if ([model.interestType intValue] == 1) {
        //T+1起息
        if ([model.status intValue] == 1) {
            if ([model.remainingDays intValue] > [model.financePeriod intValue]) {
                _remainingDaysLB.text = @"放款中";
            }else if ([model.remainingDays intValue] < 1) {
                _remainingDaysLB.text = @"回款中";
            }else{
                _remainingDaysLB.text = [NSString stringWithFormat:@"剩余%@天到期",model.remainingDays];
            }
        }else if ([model.status intValue] == 3) {
            _remainingDaysLB.text = @"已回款";
        }else if ([model.status intValue] == 2) {
            _remainingDaysLB.text = @"募集中";
        }
    }
    
    _purchaseTimeLB.text = model.orderTime;
    if ([model.status intValue] == 2 && [model.interestType intValue] == 1) {
        _expireTimeBackView.hidden = YES;
        [_purchaseSumBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_purchaseBackView.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.equalTo(@CUSTOM_CELL_HEIGHT);
        }];
    }else {
        _expireTimeLB.text = [CalculateProductInfo calculateTimeWith:model.interestDate spaceDayTime:model.financePeriod];
    }
    NSString *couponAmountStr = [StringHelper roundValueToDoubltValue:model.couponAmount];
    _purchaseSumLB.text = [NSString stringWithFormat:@"%@元",model.principal];
    if ([model.couponCategory intValue] == 1) {
        _generationIncomeTimeLB.text = [NSString stringWithFormat:@"%@元",couponAmountStr];
    }else if ([model.couponCategory intValue] == 2){
        NSString *intreaseAmount = [StringHelper roundValueToDoubltValue:model.couponAmount];
        NSString *profit;
        if ([model.couponPeriod intValue] > [model.financePeriod intValue]) {
            profit = [NSString stringWithFormat:@"%.2f",[model.financePeriod intValue] * [intreaseAmount doubleValue] *[model.principal intValue] / 36500];
        }else{
            profit = [NSString stringWithFormat:@"%.2f",[model.couponPeriod intValue] * [intreaseAmount doubleValue] *[model.principal intValue] / 36500];
        }
        //NSString *profitAmount = [StringHelper roundValueToDoubltValue:profit];
        _generationIncomeTimeLB.text = [NSString stringWithFormat:@"%@%%(%@天)%@元",intreaseAmount,model.couponPeriod,profit];
    }else if ([model.couponCategory intValue] == 3){
        _generationIncomeTimeLB.text = @"无";
    }
    NSString *interestStr = [StringHelper roundValueToDoubltValue:model.interest];
    _productInterestLB.text = [NSString stringWithFormat:@"%@元",interestStr];
    if (model.interest.length == 0 || [model.interest doubleValue] == 0) {
        _incomeNumBackView.hidden = YES;
        [_bankInfoBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_generationIncomeTimeBackView.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.equalTo(@CUSTOM_CELL_HEIGHT);
        }];
    }
    
    NSString *vipterestStr = [StringHelper roundValueToDoubltValue:model.vipProfit];
    _vipInterestLB.text = [NSString stringWithFormat:@"%@元",vipterestStr];
    if (model.vipProfit.length == 0 || [model.vipProfit doubleValue] == 0) {
        _vipInterestView.hidden = YES;
        [_signatureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bankInfoBackView.mas_bottom).offset(-0.5);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.equalTo(@CUSTOM_CELL_HEIGHT);
        }];
    }
    NSString *baseProfitStr = [StringHelper roundValueToDoubltValue:model.baseProfit];
    _baseProfitLB.text = [NSString stringWithFormat:@"%@元",baseProfitStr];
    if (model.signature.length > 0) {
        _signatureView.hidden = NO;
        _signatureLB.text = [NSString stringWithFormat:@"%@",model.signature];
    }
}

- (void)entryDetail:(UITapGestureRecognizer *)sender {
    [MobClick event:@"order_detail_enter_product_detail"];
    [VCAppearManager pushSilverWealthProductDetailWithCurrentVC:self model:_detailModel.productId];
}

- (void)UIDecorate {
    self.view.backgroundColor=[UIColor backgroundGrayColor];
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"已购产品详情";
    self.title = @"已购产品详情";
    [self.view addSubview:_customNav];
    __weak typeof(self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    TopBottomBalckBorderAndArrowView *productNameBackView=[[TopBottomBalckBorderAndArrowView alloc] init];
    [self.view addSubview:productNameBackView];
    UITapGestureRecognizer *productNameTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(entryDetail:)];
    [productNameBackView addGestureRecognizer:productNameTap];
    productNameBackView.backgroundColor=[UIColor whiteColor];
    [productNameBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNav.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@CUSTOM_CELL_HEIGHT);
    }];
    
    _productNameLB=[[UILabel alloc] init];
    [productNameBackView addSubview:_productNameLB];
    [_productNameLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
    [_productNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(productNameBackView.mas_left).offset(15);
        make.centerY.equalTo(productNameBackView.mas_centerY);
        make.right.equalTo(productNameBackView.mas_centerX);
        make.height.equalTo(@20);
    }];
    
    _remainingDaysLB=[[UILabel alloc] init];
    [productNameBackView addSubview:_remainingDaysLB];
    [_remainingDaysLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:15] characterColor:[UIColor iconBlueColor]];
    _remainingDaysLB.textAlignment=NSTextAlignmentRight;
    [_remainingDaysLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(productNameBackView.mas_right).offset(-40);
        make.height.equalTo(@20);
        make.width.equalTo(@140);
        make.centerY.equalTo(productNameBackView.mas_centerY);
    }];
    
    _purchaseTimeLB = [[UILabel alloc] init];
    _purchaseBackView = [[AlreadyBuyProductDetailCustomView alloc] initWithTitle:@"购买时间" contentLB:_purchaseTimeLB];
    [self.view addSubview:_purchaseBackView];
    [_purchaseBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(productNameBackView.mas_bottom).offset(-0.5);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@CUSTOM_CELL_HEIGHT);
    }];
    
    _expireTimeLB=[[UILabel alloc] init];
    _expireTimeBackView=[[AlreadyBuyProductDetailCustomView alloc] initWithTitle:@"到期时间" contentLB:_expireTimeLB];
    [self.view addSubview:_expireTimeBackView];
    [_expireTimeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_purchaseBackView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@CUSTOM_CELL_HEIGHT);
    }];
    
    _purchaseSumLB=[[UILabel alloc] init];
    _purchaseSumBackView=[[AlreadyBuyProductDetailCustomView alloc] initWithTitle:@"购买金额" contentLB:_purchaseSumLB];
    _purchaseSumLB.textColor=[UIColor zheJiangBusinessRedColor];
    [self.view addSubview:_purchaseSumBackView];
    [_purchaseSumBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_expireTimeBackView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@CUSTOM_CELL_HEIGHT);
    }];
    
    _generationIncomeTimeLB = [[UILabel alloc] init];
    _generationIncomeTimeBackView=[[AlreadyBuyProductDetailCustomView alloc] initWithTitle:@"使用优惠券" contentLB:_generationIncomeTimeLB];
    _generationIncomeTimeLB.textColor = [UIColor zheJiangBusinessRedColor];
    [self.view addSubview:_generationIncomeTimeBackView];
    [_generationIncomeTimeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_purchaseSumBackView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@CUSTOM_CELL_HEIGHT);
    }];
    
    _productInterestLB=[[UILabel alloc] init];
    _incomeNumBackView=[[AlreadyBuyProductDetailCustomView alloc] initWithTitle:@"产品加息" contentLB:_productInterestLB];
    _productInterestLB.textColor=[UIColor zheJiangBusinessRedColor];
    [self.view addSubview:_incomeNumBackView];
    [_incomeNumBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_generationIncomeTimeBackView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@CUSTOM_CELL_HEIGHT);
    }];
    
    _baseProfitLB = [[UILabel alloc] init];
    _bankInfoBackView=[[AlreadyBuyProductDetailCustomView alloc] initWithTitle:@"产品收益" contentLB:_baseProfitLB];
    _baseProfitLB.textColor = [UIColor zheJiangBusinessRedColor];
    [self.view addSubview:_bankInfoBackView];
    _bankInfoBackView.backgroundColor=[UIColor whiteColor];
    [_bankInfoBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_incomeNumBackView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@CUSTOM_CELL_HEIGHT);
    }];
    
    _vipInterestLB = [[UILabel alloc] init];
    _vipInterestView = [[AlreadyBuyProductDetailCustomView alloc] initWithTitle:@"会员加息" contentLB:_vipInterestLB];
    _vipInterestLB.textColor = [UIColor zheJiangBusinessRedColor];
    [self.view addSubview:_vipInterestView];
    _vipInterestView.backgroundColor = [UIColor whiteColor];
    [_vipInterestView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bankInfoBackView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@CUSTOM_CELL_HEIGHT);
    }];
    
    _signatureView=[[TopBottomBalckBorderAndArrowView alloc] init];
    [self.view addSubview:_signatureView];
    UITapGestureRecognizer *dealTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thirdDealAction:)];
    [_signatureView addGestureRecognizer:dealTap];
    _signatureView.backgroundColor=[UIColor whiteColor];
    [_signatureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_vipInterestView.mas_bottom).offset(-0.5);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@CUSTOM_CELL_HEIGHT);
    }];
    
    _signatureLB=[[UILabel alloc] init];
    [_signatureView addSubview:_signatureLB];
    [_signatureLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
    [_signatureLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_signatureView.mas_left).offset(15);
        make.centerY.equalTo(_signatureView.mas_centerY);
        make.width.equalTo(@220);
        make.height.equalTo(@20);
    }];
    
    UILabel *lookLB = [[UILabel alloc] init];
    [_signatureView addSubview:lookLB];
    lookLB.text = @"查看";
    [lookLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor iconBlueColor]];
    lookLB.textAlignment=NSTextAlignmentRight;
    [lookLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_signatureView.mas_right).offset(-30);
        make.height.equalTo(@20);
        make.width.equalTo(@40);
        make.centerY.equalTo(_signatureView.mas_centerY);
    }];
    _signatureView.hidden = YES;
}

- (void)thirdDealAction:(UITapGestureRecognizer *)sender
{
    [MobClick event:@"order_detail_click_product_agreement"];
    NoShareWebView *webView = [[NoShareWebView alloc] init];
    webView.urlStr = [NSString stringWithFormat:@"%@signature?orderNO=%@",LOCAL_HOST,_infoModel.orderNO];
    [self.navigationController pushViewController:webView animated:YES];
}



@end









