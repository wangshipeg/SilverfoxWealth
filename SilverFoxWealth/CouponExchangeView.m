

#import "CouponExchangeView.h"
#import <SVProgressHUD.h>
#import "AddCancelButton.h"
#import "DataRequest.h"
#import "WithoutAuthorization.h"

@interface CouponExchangeView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *couponView;
@property (nonatomic, strong) UILabel *couponNumLB;
@property (nonatomic, strong) UITextField *numTextfield;
@property (nonatomic, strong) UIButton *exchangeBT;
@property (nonatomic, strong) NSString *messgeStr;
@property (nonatomic, strong) CustomerNavgationController *customNav;

@end

@implementation CouponExchangeView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
}

//obtainUserCouponNumberWithAccount
- (void)achieveCouponNumber
{
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    if (!user) {
        return;
    }
    [[DataRequest sharedClient] obtainUserCouponNumberWithcustomerId:user.customerId code:_numTextfield.text callback:^(id obj) {
        DLog(@"兑换结果====%@",obj);
        _exchangeBT.userInteractionEnabled = YES;
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] integerValue] == 2000) {
                NSDictionary *dict = obj[@"data"];
                _messgeStr = dict[@"name"];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"兑换成功" message:_messgeStr preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
                return;
            }else{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"兑换失败" message:obj[@"msg"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alertController addAction:otherAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
        if ([obj isKindOfClass:[WithoutAuthorization class]]) {
            
        }
        if ([obj isKindOfClass:[NSError class]]) {
            [SVProgressHUD showErrorWithStatus:@"兑换失败"];
        }
    }];
}

- (void)UIDecorate
{
    self.view.backgroundColor = [UIColor backgroundGrayColor];
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"优惠券兑换";
    self.title = @"优惠券兑换";
    [self.view addSubview:_customNav];
    __weak typeof(self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    _couponView = [[UIView alloc] init];
    _couponView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_couponView];
    _couponView.layer.cornerRadius = 1;
    _couponView.layer.masksToBounds = YES;
    [_couponView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNav.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@200);
    }];
    
    _couponNumLB = [[UILabel alloc] init];
    _couponNumLB.text = @"请输入兑换码";
    _couponNumLB.textColor = [UIColor characterBlackColor];
    _couponNumLB.font = [UIFont systemFontOfSize:16];
    [self.couponView addSubview:_couponNumLB];
    [_couponNumLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.couponView.mas_top).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@20);
    }];
    
    _numTextfield = [[UITextField alloc] init];
    _numTextfield.delegate = self;
    _numTextfield.textColor = [UIColor characterBlackColor];
    _numTextfield.font = [UIFont systemFontOfSize:14];
    _numTextfield.borderStyle = UITextBorderStyleRoundedRect;
    _numTextfield.returnKeyType = UIReturnKeyDone;
    _numTextfield.clearButtonMode=UITextFieldViewModeWhileEditing;
    UIView *authCodeTFDis=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(authCodeTFDisrespond) title:@"完成"];
    [self.numTextfield setInputAccessoryView:authCodeTFDis];
    [self.numTextfield addTarget:self action:@selector(detectionNumTFText:) forControlEvents:UIControlEventEditingChanged];
    [_couponView addSubview:_numTextfield];
    [_numTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.couponNumLB.mas_bottom).offset(20);
        make.left.equalTo(self.couponView.mas_left).offset(30);
        make.right.equalTo(self.couponView.mas_right).offset(-30);
        make.height.equalTo(@45);
    }];
    
    _exchangeBT=[UIButton buttonWithType:UIButtonTypeCustom];
    [_couponView addSubview:_exchangeBT];
    _exchangeBT.layer.cornerRadius = 5;
    _exchangeBT.layer.masksToBounds = YES;
    [_exchangeBT setTitle:@"我要兑换" forState:UIControlStateNormal];
    _exchangeBT.userInteractionEnabled = NO;
    _exchangeBT.backgroundColor=[UIColor typefaceGrayColor];
    _exchangeBT.titleLabel.font=[UIFont systemFontOfSize:16];
    [_exchangeBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_exchangeBT addTarget:self action:@selector(exchangeCleck:) forControlEvents:UIControlEventTouchUpInside];
    [_exchangeBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numTextfield.mas_bottom).offset(20);
        make.left.equalTo(self.couponView.mas_left).offset(30);
        make.right.equalTo(self.couponView.mas_right).offset(-30);
        make.height.equalTo(@45);
    }];
}

- (void)exchangeCleck:(UIButton *)sender
{
    _exchangeBT.userInteractionEnabled = NO;
    [self achieveCouponNumber];
    NSLog(@"我要兑换");
}

- (void)detectionNumTFText:(NSNotification *)sender
{
    if (_numTextfield.text.length > 0) {
        _exchangeBT.userInteractionEnabled = YES;
        _exchangeBT.backgroundColor = [UIColor zheJiangBusinessRedColor];
    }
}

- (void)authCodeTFDisrespond{
    [self.numTextfield resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.numTextfield resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField==self.numTextfield) {
        if (range.location>39){
            return NO;
        }
    }
    return YES;
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

