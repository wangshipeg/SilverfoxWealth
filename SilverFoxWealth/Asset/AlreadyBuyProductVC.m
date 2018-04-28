
#import "AlreadyBuyProductVC.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "PaymentCalendarVC.h"
#import "UMMobClick/MobClick.h"

@interface AlreadyBuyProductVC ()

@property (nonatomic, strong) UIView *viewAlpha;
@property (nonatomic, strong) CustomerNavgationController *customNav;
@end

@implementation AlreadyBuyProductVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"已购产品";
    self.title = @"已购产品";
    [_customNav.rightButton setTitle:@"回款日历" forState:UIControlStateNormal];
    [self.view addSubview:_customNav];
    __weak typeof(self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };  
    _customNav.rightButtonHandle = ^{
        [MobClick event:@"payback_calendar"];
        PaymentCalendarVC *calendarVC = [[PaymentCalendarVC alloc] init];
        [super.navigationController pushViewController:calendarVC animated:YES];
    };
    self.titleArray = @[@"待回款",@"已回款"];
    OneViewController *oneVC = [[OneViewController alloc] init];
    TwoViewController *twoVC = [[TwoViewController alloc] init];
    self.controllerArray = @[oneVC,twoVC];
}

- (void)animateViewOfRound
{
    NSUserDefaults *userDEfault = [NSUserDefaults standardUserDefaults];
    if ([userDEfault boolForKey:@"no1"] == NO) {
        [self setUpguideLayeView];
        [userDEfault setBool:YES forKey:@"no1"];
    }
}

- (void)setUpguideLayeView
{
    _viewAlpha = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _viewAlpha.backgroundColor = [UIColor clearColor];
    [[[UIApplication sharedApplication] keyWindow]addSubview:_viewAlpha];
    
    UIImageView *imageAlpha = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guideLayer.png"]];
    imageAlpha.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
    [_viewAlpha addSubview:imageAlpha];
    
    UIButton *iKnowBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [iKnowBT setImage:[UIImage imageNamed:@"IKnowBT.png"] forState:UIControlStateNormal];
    iKnowBT.frame = CGRectMake(self.view.frame.size.width / 3, self.view.frame.size.height * 2 / 3, self.view.frame.size.width / 3, 35);
    [iKnowBT addTarget:self action:@selector(clickIKnowBT:) forControlEvents:UIControlEventTouchUpInside];
    [_viewAlpha addSubview:iKnowBT];
}

- (void)clickIKnowBT:(UIButton *)sender
{
    [_viewAlpha removeFromSuperview];
}


@end

