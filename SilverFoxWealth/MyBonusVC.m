
#import "MyBonusVC.h"
#import "CouponVC.h"
#import "BonusVC.h"
#import "BlackBorderBT.h"
#import "CouponExchangeView.h"
#import "UMMobClick/MobClick.h"
#import "VCAppearManager.h"

@interface MyBonusVC ()
@property (nonatomic, strong) CustomerNavgationController *customNav;
@end

@implementation MyBonusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSNotificationCenter *messageCenter=[NSNotificationCenter  defaultCenter];
    [messageCenter postNotificationName:@"viewWilAppear" object:Nil userInfo:nil];
}

- (void)UIDecorate {
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"我的优惠券";
    self.title = @"我的优惠券";
    [_customNav.rightButton setTitle:@"兑换码" forState:UIControlStateNormal];
    [self.view addSubview:_customNav];
    __weak typeof(self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    _customNav.rightButtonHandle = ^{
        CouponExchangeView *couponView = [[CouponExchangeView alloc] init];
        [weakSelf.navigationController pushViewController:couponView animated:YES];
    };
    self.titleArray = @[@"可使用",@"已失效"];
    
    BonusVC *oneVC = [[BonusVC alloc] init];
    CouponVC *twoVC = [[CouponVC alloc] init];
    twoVC.pushStutas = _pushStutas;
    self.controllerArray = @[oneVC,twoVC];
    
    BlackBorderBT *button = [BlackBorderBT buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"优惠券说明" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button setTitleColor:[UIColor zheJiangBusinessRedColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(rebateUserInfo:) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
//    if (IS_iPhoneX) {
//        [button mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.view.mas_bottom).offset(-34);
//        }];
//    }
}


- (void)rebateUserInfo:(UIButton *)sender {
    [MobClick event:@"red_bag_use_instruct"];
    [VCAppearManager pushH5VCWithCurrentVC:self workS:rebateUseInfo];
}
//- (void)back:(UIButton*)sender{
//    [self.navigationController popViewControllerAnimated:YES];
//}

@end

