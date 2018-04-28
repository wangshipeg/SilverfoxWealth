//
//  IndianaCommitVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "IndianaCommitVC.h"
#import "TopBottomBalckBorderView.h"
#import "BlackBorderTextField.h"
#import "AddCancelButton.h"
#import "StringHelper.h"
#import "RoundCornerClickBT.h"
#import "DataRequest.h"
#import "SVProgressHUD.h"
#import "WithoutAuthorization.h"
#import "UserInfoUpdate.h"
#import "VCAppearManager.h"
#import "CommitSuccessVC.h"

@interface IndianaCommitVC ()<UITextFieldDelegate>

@property (nonatomic, strong) TopBottomBalckBorderView *purchaseMoneyBaseView;
@property (nonatomic, strong) BlackBorderTextField *numTF;
@property (nonatomic, strong) UILabel *totalValueLB;
@property (nonatomic, strong) UIButton *commitBT;
@property (nonatomic, strong) NSString *totleResultStr;

@end

@implementation IndianaCommitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
    [self calculateCurrentTotleInputMoney];
    // Do any additional setup after loading the view.
}

//给输入购买份数键盘添加完成按钮 和 实时通知
- (void)addDissmissViewForTextField {
    UIView *dismissView=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(textFieldDissMiss) title:@"完成"];
    [self.numTF setInputAccessoryView:dismissView];
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(textFieldTextChangeWith:) name:UITextFieldTextDidChangeNotification object:nil];
}

//份数不能超过5位数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.location>=5) {
        return NO;
    }
    return YES;
}

- (void)textFieldTextChangeWith:(NSNotification *)note {
    if ([self.numTF.text integerValue] < 0) {
        self.numTF.text = @"1";
    }
    if (self.numTF.text.length >= 1 && [self.numTF.text
                                        integerValue] == 0) {
        self.numTF.text =@"1";
    }
    [self detectionCurrentState];
}

- (void)textFieldDissMiss {
    [self.numTF resignFirstResponder];
}

//实时计算话费银子数
- (void)detectionCurrentState {
    [self calculateCurrentTotleInputMoney];
}
//根据当前输入的份数 计算总共花费多少钱
- (void)calculateCurrentTotleInputMoney {
    //一次夺宝消耗银子数
    NSInteger lowestMoney=[self.consumeSilver floatValue];
    //份数
    NSInteger portionNum=[self.numTF.text integerValue];
    //结果
    _totleResultStr=[NSString stringWithFormat:@"%ld",lowestMoney*portionNum];
    _totalValueLB.attributedText = [StringHelper renderFrontAndAfterDifferentFontWithValue:@"共" frontFont:16 frontColor:[UIColor characterBlackColor] afterStr:_totleResultStr  afterFont:16 afterColor:[UIColor zheJiangBusinessRedColor] lastStr:@"两" lastFont:16 lastColor:[UIColor characterBlackColor]];
}


- (void)caculatePurchaseNum:(UIButton *)sender {
    //减购买份数
    if (sender.tag==1) {
        //如果已经减到1了 就不减了
        if ([self.numTF.text integerValue] == 1) {
            return;
        }
        //如果小于1了 重置为1
        if ([self.numTF.text integerValue] <= 0) {
            self.numTF.text = @"1";
            [self detectionCurrentState];
            return;
        }
        //否则 让当前份数减一
        self.numTF.text=[NSString stringWithFormat:@"%ld",[self.numTF.text integerValue]-1];
    }
    
    //加购买份数
    if (sender.tag==2) {
        //如果位数长度大于6 不让加
        NSString *newStr=[NSString stringWithFormat:@"%ld",[self.numTF.text integerValue]+1];
        if (newStr.length > 5) {
            return;
        }
        self.numTF.text=newStr;
    }
    [self detectionCurrentState];
}

- (void)UIDecorate
{
    CustomerNavgationController *customNav = [[CustomerNavgationController alloc] init];
    if (IS_iPhoneX) {
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height);
    }else{
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    }
    customNav.titleLabel.text = @"夺宝";
    self.title = @"夺宝";
    [self.view addSubview:customNav];
    __weak typeof (self) weakSelf = self;
    customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.view.backgroundColor = [UIColor backgroundGrayColor];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    //显示金额父视图
    _purchaseMoneyBaseView=[[TopBottomBalckBorderView alloc] init];
    _purchaseMoneyBaseView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_purchaseMoneyBaseView];
    [_purchaseMoneyBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(customNav.mas_bottom).offset(24);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(@50);
    }];
    
    //参与次数 text
    UILabel *label = [[UILabel alloc] init];
    [self.purchaseMoneyBaseView addSubview:label];
    label.text = @"参与次数";
    label.textColor = [UIColor characterBlackColor];
    label.font = [UIFont systemFontOfSize:16];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.purchaseMoneyBaseView.mas_centerY);
        make.left.equalTo(self.purchaseMoneyBaseView.mas_left).offset(15);
        make.height.equalTo(@20);
    }];
    
    //份数减少按钮
    UIButton *decreaseBT=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.purchaseMoneyBaseView addSubview:decreaseBT];
    decreaseBT.tag=1;
    [decreaseBT addTarget:self action:@selector(caculatePurchaseNum
                                                
                                                :) forControlEvents:UIControlEventTouchUpInside];
    [decreaseBT setImage:[UIImage imageNamed:@"DecreaseNum.png"] forState:UIControlStateNormal];
    [decreaseBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(10);
        make.top.equalTo(self.purchaseMoneyBaseView.mas_top);
        make.bottom.equalTo(self.purchaseMoneyBaseView.mas_bottom);
        make.width.equalTo(@30);
    }];
    
    //份数输入框
    _numTF=[[BlackBorderTextField alloc] init];
    _numTF.delegate=self;
    _numTF.keyboardType=UIKeyboardTypeNumberPad;
    [self.purchaseMoneyBaseView addSubview:_numTF];
    [_numTF setFont:[UIFont systemFontOfSize:16]];
    _numTF.text=@"1";
    [_numTF setTextAlignment:NSTextAlignmentCenter];
    [_numTF setTextColor:[UIColor characterBlackColor]];
    [_numTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.purchaseMoneyBaseView.mas_centerY);
        make.left.equalTo(decreaseBT.mas_right);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    [self addDissmissViewForTextField];
    
    //份数增加按钮
    UIButton *additionBT=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.purchaseMoneyBaseView addSubview:additionBT];
    additionBT.tag=2;
    [additionBT addTarget:self action:@selector(caculatePurchaseNum:) forControlEvents:UIControlEventTouchUpInside];
    [additionBT setImage:[UIImage imageNamed:@"AddNum.png"] forState:UIControlStateNormal];
    [additionBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_numTF.mas_right);
        make.top.equalTo(self.purchaseMoneyBaseView.mas_top);
        make.bottom.equalTo(self.purchaseMoneyBaseView.mas_bottom);
        make.width.equalTo(@30);
    }];
    
    //总金额label
    _totalValueLB=[[UILabel alloc] init];
    [self.purchaseMoneyBaseView addSubview:_totalValueLB];
    [_totalValueLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.purchaseMoneyBaseView.mas_centerY);
        make.right.equalTo(self.purchaseMoneyBaseView.mas_right).offset(-15);
        make.height.equalTo(@20);
    }];
    
    //提交按钮
    _commitBT = [RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_commitBT];
    [_commitBT setTitle:@"提交" forState:UIControlStateNormal];
    [_commitBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _commitBT.backgroundColor = [UIColor zheJiangBusinessRedColor];
    [_commitBT addTarget:self action:@selector(handleCommitBT:) forControlEvents:UIControlEventTouchUpInside];
    [_commitBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(43);
        make.top.equalTo(self.purchaseMoneyBaseView.mas_bottom).offset(40);
        make.height.equalTo(@45);
        make.right.equalTo(self.view.mas_right).offset(-43);
    }];
}

//点击提交按钮响应事件
- (void)handleCommitBT:(RoundCornerClickBT *)sender
{
    [MobClick event:@"snatch_commit"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"土豪, 您要消耗%@两银子参与%@次夺宝, 是否继续",_totleResultStr,self.numTF.text] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MobClick event:@"snatch_go_on"];
        //点击提交之后 在夺宝结果没出来之前  不能再次提交夺宝
        [self achiveIndianaCommitData];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)achiveIndianaCommitData
{
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] IndianaCommitPagecustomerId:user.customerId goodsId:_idStr portion:_numTF.text callback:^(id obj) {
        DLog(@"0元夺宝提交兑换返回内容===%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] intValue] == 2000) {
                [self setUpSensorsAnalyticsSDK];
                NSDictionary *dict = obj[@"data"];
                //兑换成功, 跳转到提交成功页面
                CommitSuccessVC *successVC = [[CommitSuccessVC alloc] init];
                successVC.indianaTimesStr = self.numTF.text;
                successVC.indianaNum = dict[@"joinCodes"];
                [self.navigationController pushViewController:successVC animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
            }
        }
        //授权
        if ([obj isKindOfClass:[WithoutAuthorization class]]) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self];//取消当前请求
            [UserInfoUpdate clearUserLocalInfo];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [VCAppearManager presentLoginVCWithCurrentVC:self];
        }
        //[self loadUrlDetail];
    }];
}

- (void)setUpSensorsAnalyticsSDK
{
    [[SensorsAnalyticsSDK sharedInstance] track:@"ParticipateIndiana"
                                 withProperties:@{
                                                  @"GoodsName" : _nameStr,
                                                  @"JoinPrice":@([_totleResultStr intValue]),
                                                  @"JoinCount":@([_numTF.text intValue]),
                                                  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

