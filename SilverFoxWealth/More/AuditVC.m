
#import "AuditVC.h"
#import "RoundCornerClickBT.h"
#import "VCAppearManager.h"
#import "MoreVC.h"
#import "MyAssetVC.h"
#import "RegisterPageVC.h"

@interface AuditVC ()
@property (nonatomic, strong) RoundCornerClickBT *nextBT;
@property (nonatomic, strong) CustomerNavgationController *customNav;
@end

@implementation AuditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
    // Do any additional setup after loading the view.
}
- (void)UIDecorate
{
    self.view.backgroundColor = [UIColor backgroundGrayColor];
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"更换手机号";
    self.title = @"更换手机号";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    _customNav.leftViewController = ^{
        UIViewController *target = nil;
        UIViewController *targetElse = nil;
        for (UIViewController * controller in weakSelf.navigationController.viewControllers) { //遍历
            if ([controller isKindOfClass:[MoreVC class]]) { //这里判断是否为你想要跳转的页面
                target = controller;
            }
            if ([controller isKindOfClass:[RegisterPageVC class]]) {
                targetElse = controller;
            }
        }
        if (target) {
            [weakSelf.navigationController popToViewController:target animated:YES]; //跳转
        }
        if (targetElse) {
            [weakSelf.navigationController popToViewController:targetElse animated:YES];
        }
    };
    
    UILabel *successLB = [[UILabel alloc] init];
    successLB.textAlignment = NSTextAlignmentCenter;
    successLB.frame = CGRectMake(0 , self.view.frame.size.height / 3.8 + 64, self.view.frame.size.width, 30);
    successLB.text = @"审核中";
    successLB.font = [UIFont systemFontOfSize:16];
    successLB.textColor = [UIColor characterBlackColor];
    [self.view addSubview:successLB];
    
    UILabel *contentLB = [[UILabel alloc] init];
    contentLB.textAlignment = NSTextAlignmentCenter;
    contentLB.frame = CGRectMake(15 , self.view.frame.size.height /3.8 + 94, self.view.frame.size.width - 30, 20);
    contentLB.text = @"审核将在3个工作日内完成";
    contentLB.font = [UIFont systemFontOfSize:16];
    contentLB.textColor = [UIColor characterBlackColor];
    [self.view addSubview:contentLB];
    
    _nextBT = [RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [_nextBT setTitle:@"我知道了" forState:UIControlStateNormal];
    _nextBT.titleLabel.font = [UIFont systemFontOfSize:16];
    _nextBT.frame = CGRectMake(43,self.view.frame.size.height / 3.8 + 164, self.view.frame.size.width - 86, 45);
    _nextBT.backgroundColor = [UIColor zheJiangBusinessRedColor];
    [_nextBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextBT addTarget:self action:@selector(accessFirstVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBT];
}

- (void)accessFirstVC:(UIButton *)sender {
    UIViewController *target = nil;
    UIViewController *targetElse = nil;
    for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
        if ([controller isKindOfClass:[MoreVC class]]) { //这里判断是否为你想要跳转的页面
            target = controller;
        }
        if ([controller isKindOfClass:[RegisterPageVC class]]) {
            targetElse = controller;
        }
    }
    if (target) {
        [self.navigationController popToViewController:target animated:YES]; //跳转
    }
    if (targetElse) {
        [self.navigationController popToViewController:targetElse animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.isViewLoaded && !self.view.window)
    {
        self.view = nil;
    }
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

