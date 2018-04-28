//
//  ProductBuyBaseVC.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/7/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TopBottomBalckBorderView.h"
#import "TopBottomBalckBorderAndArrowView.h"
#import "CheckingTDPasswordView.h"
#import "RoundCornerClickBT.h"

#import "BankAndIdentityInfoModel.h"
#import "SilverWealthProductDetailModel.h"
#import "RebateModel.h"

#import <SVProgressHUD.h>
#import "UILabel+LabelStyle.h"
#import "CalculateProductInfo.h"
#import "IndividualInfo.h"
#import "AlreadyPurchaseProductModel.h"
@interface ProductBuyBaseVC : UIViewController

//页面最顶端 显示购买金额的背景view
@property (nonatomic, strong) TopBottomBalckBorderView         *purchaseMoneyBaseView;
//选择银行卡背景
@property (nonatomic, strong) TopBottomBalckBorderView *chooseBankCardBaseView;
//预计产生收益的时间
@property (strong, nonatomic) UILabel                          *incomeTimeLB;
//预计产生收益
@property (strong, nonatomic) UILabel                          *incomeLB;
//显示所选银行卡
@property (strong, nonatomic) UILabel                          *bankCardLB;
@property (nonatomic, strong) NSString *bankCardNameAndNumber;
//提交按钮
@property (strong, nonatomic) RoundCornerClickBT               *commitBT;
//购买金额
@property (nonatomic, strong) NSString                         *currentPurchaseNum;
//当前使用的银行账号信息 包括银行账号  银行名称  姓名  卡号
@property (nonatomic, strong) NSMutableDictionary              *currentUserBankParam;
//从已绑银行卡列表选择的model
@property (nonatomic, copy  ) BankAndIdentityInfoModel         *bankAndIdentityModel;
//当前使用的红包
@property (nonatomic, copy  ) RebateModel                      *currentUseRebateModel;
//当前选择的产品 从上一个页面传进来的
@property (nonatomic, copy  ) SilverWealthProductDetailModel         *buyProductInfo;

//输入密码视图
@property (nonatomic, strong) CheckingTDPasswordView           *passwordView;

@property (nonatomic, strong) NSMutableDictionary              *userBankParam;

@property (nonatomic , strong)NSString *productId;

@property (nonatomic, strong) NSString *balanceStr;
@property (nonatomic, strong) UIButton *rechargeBT;
@property (nonatomic, strong) NSString *principalStr;

@property (nonatomic, strong) NSString *backType;


@end








