//
//  CouponGiveToOneVCViewController.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/12/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CouponGiveToOneVCViewController.h"
#import "RoundTextField.h"
#import "AddCancelButton.h"
#import "RoundCornerClickBT.h"
#import "FastAnimationAdd.h"
#import "Validation.h"
#import "DataRequest.h"
#import "SVProgressHUD.h"
#import "PromptLanguage.h"
#import "WithoutAuthorization.h"
#import "UMMobClick/MobClick.h"

@interface CouponGiveToOneVCViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) RoundTextField *phoneNumTF;
@property (nonatomic, strong) RoundCornerClickBT *giveToOneBT;
@property (nonatomic, strong) CustomerNavgationController *customNav;
@end

@implementation CouponGiveToOneVCViewController

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
    _customNav.titleLabel.text = @"优惠券转赠";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    UILabel *label = [[UILabel alloc] init];
    [self.view addSubview:label];
    label.text = @"请输入好友手机号";
    label.textColor = [UIColor characterBlackColor];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNav.mas_bottom).offset(20);
        make.height.equalTo(@20);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(self.view.mas_right).offset(-43);
    }];
    
    _phoneNumTF=[[RoundTextField alloc] init];
    [self.view addSubview:_phoneNumTF];
    _phoneNumTF.delegate = self;
    _phoneNumTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneNumTF.font=[UIFont systemFontOfSize:14];
    _phoneNumTF.placeholder = @"请输入手机号";
    _phoneNumTF.backgroundColor=[UIColor whiteColor];
    _phoneNumTF.keyboardType=UIKeyboardTypeDecimalPad;
    UIView *nameTFView=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(phoneNumTFCompleteInput:) title:@"完成"];
    [self.phoneNumTF setInputAccessoryView:nameTFView];
    [_phoneNumTF becomeFirstResponder];
    
    [self.phoneNumTF addTarget:self action:@selector(detectionPhoneNumTFText:) forControlEvents:UIControlEventEditingChanged];
    [_phoneNumTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(30);
        make.height.equalTo(@45);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(self.view.mas_right).offset(-43);
    }];
    UIView *phoneLB=[AddCancelButton addTextFieldLeftViewWithImage:@"cellphoneNumber.png" width:40];
    [_phoneNumTF setLeftView:phoneLB];
    _phoneNumTF.leftViewMode=UITextFieldViewModeAlways;
    
    _giveToOneBT = [RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_giveToOneBT];
    [_giveToOneBT setTitle:@"赠送" forState:UIControlStateNormal];
    _giveToOneBT.titleLabel.font=[UIFont systemFontOfSize:16];
    _giveToOneBT.backgroundColor=[UIColor typefaceGrayColor];
    _giveToOneBT.userInteractionEnabled=NO;
    [FastAnimationAdd codeBindAnimation:_giveToOneBT];
    [_giveToOneBT addTarget:self action:@selector(clickGiveToOneBT:) forControlEvents:UIControlEventTouchUpInside];
    [_giveToOneBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneNumTF.mas_bottom).offset(50);
        make.height.equalTo(@45);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.right.equalTo(self.view.mas_right).offset(-43);
    }];
}

- (void)clickGiveToOneBT:(UIButton *)sender
{
    [MobClick event:@"coupon_give_ensure"];
    if (![Validation mobileNum:self.phoneNumTF.text]) {
        [SVProgressHUD showErrorWithStatus:CellphoneNumError];
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否转赠给好友" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"自己留着" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"果断转赠" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MobClick event:@"coupon_give_success"];
        [self couponGiveToOneData];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)couponGiveToOneData
{
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [[DataRequest sharedClient]couponGiveToOneWithcustomerId:user.customerId customerCouponId:_couponID cellphone:self.phoneNumTF.text callback:^(id obj) {
        DLog(@"优惠券转赠返回结果====%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] integerValue] == 2000) {
                [SVProgressHUD showErrorWithStatus:@"赠送成功"];
                //                [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:Wait_Time]];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
            }
        }
        if ([obj isKindOfClass:[WithoutAuthorization class]]) {
            
        }
    }];
}

- (void)phoneNumTFCompleteInput:(UIButton *)sender
{
    [self.phoneNumTF resignFirstResponder];
}
- (void)detectionPhoneNumTFText:(UIButton *)sender
{
    if (self.phoneNumTF.text.length != 0) {
        self.phoneNumTF.rightView.hidden=NO;
    }else{
        self.phoneNumTF.rightView.hidden=YES;
    }
    [self detectionPhoneNumTFConent];
}

- (void)detectionPhoneNumTFConent {
    
    if (_phoneNumTF.text.length==11) {
        self.giveToOneBT.backgroundColor=[UIColor zheJiangBusinessRedColor];
        self.giveToOneBT.userInteractionEnabled=YES;
    }else {
        self.giveToOneBT.backgroundColor=[UIColor typefaceGrayColor];
        self.giveToOneBT.userInteractionEnabled=NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField==self.phoneNumTF) {
        if (range.location >= 11) {
            return NO;
        }
        if ([Validation oneLengthpwd:string]||[string length]==0) {
            return YES;
        }else{
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

