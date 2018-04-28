//
//  MyAssetVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/3/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MyAssetVC.h"
#import "CommunalInfo.h"
#import "MySilverVC.h"
#import "MyBonusVC.h"
#import "AlreadyBuyProductVC.h"
#import "MyBankCardListVC.h"
#import "DataRequest.h"
#import "AssetNotLoginView.h"
#import "UINavigationController+DetectionNetState.h"
#import "ShareConfig.h"

#import "UserInfoUpdate.h"
#import "StringHelper.h"
#import "AnimationHelper.h"

#import "AssetModel.h"
#import "WithoutAuthorization.h"

#import "PromptLanguage.h"
#import "UMMobClick/MobClick.h"
#import "InspectNetwork.h"
#import "VCAppearManager.h"
#import "UILabel+LabelStyle.h"
#import "AssetSubIncomeView.h"
#import "FastAnimationAdd.h"
#import "BottomBlackLineView.h"

#import "SCMeasureDump.h"
#import "CacheHelper.h"
//#import "AFHTTPRequestOperationManager.h"
#import "UserDefaultsManager.h"
#import "MoreVC.h"
#import "UserInfoModel.h"
#import <MJRefresh.h>

#import "UserMessageVC.h"
#import "DrawalsVC.h"
#import "RechargeVC.h"
#import "ExchangeDetailVC.h"
#import "SetUpTradePasswordWebView.h"
#import "MyAssetCollectionViewCell.h"
#import "UIImageView+WebCache.h"

#import "VipCenterViewController.h"

@interface MyAssetVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;


@property (strong, nonatomic) UILabel        *totalAssetTitleLB;
//和所有显示内容一般大的一个view 用做未登录提示父视图
@property (strong, nonatomic) UIView         *backContentView;

@property (strong, nonatomic) UILabel        *totalAssetLB;//总资产
@property (strong, nonatomic) UILabel        *balanceLB;
@property (strong, nonatomic) UILabel        *accumulationProfitLB;//累计收益
@property (nonatomic, strong) UILabel *yesterdayProfitLB;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) AssetModel *myAssetModel;
@property (nonatomic, strong) UIButton *showMoney;
@property (nonatomic, strong) NSMutableArray *systemSource;
@property (nonatomic, strong) NSMutableArray *mutArr;
@property (nonatomic, strong) UIButton *withdrawalsBT;
@property (nonatomic, strong) UIButton *rechargeBT;
@property (nonatomic, strong) CustomerNavgationController *customNav;

@property (nonatomic, strong) UIImageView *vipImg;
@property (nonatomic, strong) UIView *btBackgroundView;
@property (nonatomic, strong) UIView *viewAlpha;
@property (nonatomic, strong) UIImageView *headerImgView;

@end

@implementation MyAssetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
    [self dataInitialize];
    [_customNav.rightButton setImage:[UIImage imageNamed:@"MessageRead.png"] forState:UIControlStateNormal];
}
- (void)animateViewOfRound
{
    NSUserDefaults *userDEfault = [NSUserDefaults standardUserDefaults];
    if ([userDEfault boolForKey:@"myAssetFirst"] == NO) {
        [self setUpguideLayeView];
        [userDEfault setBool:YES forKey:@"myAssetFirst"];
    }
}

- (void)setUpguideLayeView
{
    _viewAlpha = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _viewAlpha.backgroundColor = [UIColor clearColor];
    [[[UIApplication sharedApplication] keyWindow]addSubview:_viewAlpha];
    
    UIImageView *imageAlpha = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guideLayer.png"]];
    imageAlpha.frame = _viewAlpha.frame;
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

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadUserAsset];
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    if (!user) {
        return;
    }
    _rechargeBT.userInteractionEnabled = YES;
    _withdrawalsBT.userInteractionEnabled = YES;
    _collectionView.userInteractionEnabled = YES;
    [self achieveUserInfoOfAssets:user];
    [self showUsetInfo];
    if ([[CacheHelper getTotalAssetDataString] isEqualToString:@"****"])
    {
        _showMoney.userInteractionEnabled = YES;
    } else {
        _showMoney.userInteractionEnabled = NO;
    }
}

- (void)achieveUserInfoOfAssets:(IndividualInfoManage *)user{
    [[DataRequest sharedClient] achieveCustomerUserInfoWithcustomerId:user.customerId callback:^(id obj) {
        if ([obj isKindOfClass:[IndividualInfoManage class]]) {
            IndividualInfoManage *resultUser = obj;
            [IndividualInfoManage updateAccountWith:resultUser];
            
            if (resultUser.accountId.length == 0) {
                NSUserDefaults *userDEfault = [NSUserDefaults standardUserDefaults];
                if ([userDEfault boolForKey:@"openAnCount"] == NO) {
                    [self isDredgeBankAccount:@"viewWillAppear"];
                    [userDEfault setBool:YES forKey:@"openAnCount"];
                }
            }
            if ([resultUser.vipLevel intValue] > 0) {
                _vipImg.hidden = NO;
                _vipImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"v_%@",resultUser.vipLevel]];
            }else{
                _vipImg.hidden = YES;
            }
            
            if (resultUser.headSculptureUrl.length > 0) {
                [_headerImgView sd_setImageWithURL:[NSURL URLWithString:resultUser.headSculptureUrl] placeholderImage:[UIImage imageNamed:@"AdvertDefault.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    _headerImgView.image = image;
                }];
            }else{
                _headerImgView.image = [UIImage imageNamed:@"defaultHeaderImg.png"];
            }
            _headerImgView.layer.cornerRadius = 25;
            _headerImgView.layer.masksToBounds = YES;
        }
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
        }
    }];
}

- (void)isDredgeBankAccount:(NSString *)markStr
{
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    if (!user) {
        return;
    }
    if (user.accountId.length == 0) {
        [SVProgressHUD dismiss];
        _rechargeBT.userInteractionEnabled = YES;
        _withdrawalsBT.userInteractionEnabled = YES;
        _collectionView.userInteractionEnabled = YES;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您还未开通银行存管账户\n是否开通?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"以后再说" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"立即开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [VCAppearManager presentPersonalAmountCurrentVC:self];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if(user.accountId.length > 0 && ([markStr isEqualToString:@"drawalsBT"] || [markStr isEqualToString:@"rechargeBT"])) {
        [[DataRequest sharedClient] requestWhetherSetUpTradePasswordAccountId:user.accountId callback:^(id obj) {
            _rechargeBT.userInteractionEnabled = YES;
            _withdrawalsBT.userInteractionEnabled = YES;
            _collectionView.userInteractionEnabled = YES;
            DLog(@"是否设置交易密码======%@",obj);
            if ([obj isKindOfClass:[NSDictionary class]]) {
                if ([obj[@"pinFlag"] intValue] == 1) {
                    if ([markStr isEqualToString:@"drawalsBT"]) {
                        DrawalsVC *drawalsVC = [[DrawalsVC alloc] init];
                        drawalsVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:drawalsVC animated:YES];
                    }
                    if ([markStr isEqualToString:@"rechargeBT"]) {
                        RechargeVC *rechargeVC = [[RechargeVC alloc] init];
                        rechargeVC.hidesBottomBarWhenPushed = YES;
                        rechargeVC.fromStr = @"asset";
                        [self.navigationController pushViewController:rechargeVC animated:YES];
                    }
                }else{
                    [SCMeasureDump shareSCMeasureDump].openAccountPresentVC = @"other";
                    [VCAppearManager presentSetUpTradePasswordVC:self];
                }
            }
            if ([obj isKindOfClass:[NSString class]]) {
                [SVProgressHUD showErrorWithStatus:obj];
            }
        }];
    }
}

- (void)showUsetInfo
{
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    if (user) {
        [[DataRequest sharedClient] obtainUserNoReadMessageWithcustomerId:user.customerId callback:^(id obj) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                if ([obj[@"unreadCount"] intValue] > 0) {
                    [_customNav.rightButton setImage:[UIImage imageNamed:@"MessageNORead.png"] forState:UIControlStateNormal];
                    return;
                }
                [_customNav.rightButton setImage:[UIImage imageNamed:@"MessageRead.png"] forState:UIControlStateNormal];
            }
        }];
    }
}

- (void)loadUserAsset
{
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    if (user) {
        [self clearBackContentViewSubView];
        [self animateViewOfRound];
        [self achieveAssetDataWith:user.customerId];
    } else {
        [self noLogin];
    }
}

-(void)achieveAssetDataWith:(NSString *)customerId
{
    [[DataRequest sharedClient] obtainUserAssetWithcustomerId:customerId callback:^(id obj)
     {
         [self.collectionView.mj_header endRefreshing];
         DLog(@"我的资产加载结果====%@",obj);
         if ([obj isKindOfClass:[AssetModel class]])
         {
             self.myAssetModel = obj;
             if (![[CacheHelper getTotalAssetDataString] isEqualToString:@"****"])
             {
                 [self showAssetDetail:self.myAssetModel];
             } else {
                 [self showCloseDetail];
             }
             [CacheHelper saveAssetData:obj];
         }
         if ([obj isKindOfClass:[WithoutAuthorization class]])
         {
             [UserInfoUpdate clearUserLocalInfo];
             [self noLogin];
             return;
         }
         if ([obj isKindOfClass:[NSError class]]) {
             AssetModel *dic=[CacheHelper currentAssetData];
             if (dic) {
                 [self showAssetDetail:dic];
             }
         }
     }];
}

- (void)showCloseDetail
{
    self.totalAssetLB.text = @"****";
    self.balanceLB.text = @"****";
    self.accumulationProfitLB.text = @"****";
    self.yesterdayProfitLB.text = @"****";
}

-(void)showAssetDetail:(AssetModel *)dic
{
    //总资产
    NSString *totalAssetStr = [NSString stringWithFormat:@"%.2f",[dic.totalAsset doubleValue]];
    double doubleValueTotal = [totalAssetStr doubleValue];
    
    NSString *totalValue = [NSString stringWithFormat:@"%.2f",[StringHelper roundValueWith:doubleValueTotal]];
    [self.totalAssetLB pop_addAnimation:[AnimationHelper addValueChangeAnimationWithFinallyValue:[totalValue doubleValue] anmationCompletion:^{
        self.totalAssetLB.text=totalValue;
        _showMoney.userInteractionEnabled = YES;
    }] forKey:@"totalAssetLB"];
    
    NSString *balanceValue = [NSString stringWithFormat:@"%.2f",[dic.balance doubleValue]];
    [self.balanceLB pop_addAnimation:[AnimationHelper addValueChangeAnimationWithFinallyValue:[balanceValue doubleValue] anmationCompletion:^{
        self.balanceLB.text = balanceValue;
    }] forKey:@"balanceLB"];
    
    NSString *accumulationValue = [NSString stringWithFormat:@"%.2f",[StringHelper roundValueWith:[dic.accumulationProfit doubleValue]]];
    [self.accumulationProfitLB pop_addAnimation:[AnimationHelper addValueChangeAnimationWithFinallyValue:[accumulationValue doubleValue] anmationCompletion:^{
        self.accumulationProfitLB.text = accumulationValue;
    }] forKey:@"accumulationProfitLB"];
    
    NSString *yesterdayProfitValue = [NSString stringWithFormat:@"%.2f",[StringHelper roundValueWith:[dic.yesterdayProfit doubleValue]]];
    [self.yesterdayProfitLB pop_addAnimation:[AnimationHelper addValueChangeAnimationWithFinallyValue:[yesterdayProfitValue doubleValue] anmationCompletion:^{
        self.yesterdayProfitLB.text = yesterdayProfitValue;
    }] forKey:@"yesterdayProfitLB"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"assetsCell" forIndexPath:indexPath];
    [cell assetCellContentWith:[_dataSource objectAtIndex:indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width, 315);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"assetHeadCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor backgroundGrayColor];
        
        UIView *backViewAssetView = [[UIView alloc] init];
        backViewAssetView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"assetsBackground.png"]];
        [cell addSubview:backViewAssetView];
        [backViewAssetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left);
            make.right.equalTo(cell.mas_right);
            make.top.equalTo(cell.mas_top);
            make.height.equalTo(@260);
        }];
        
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:_headerImgView];
        [_headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.mas_centerX);
            make.top.equalTo(cell.mas_top).offset(20);
            make.width.equalTo(@50);
            make.height.equalTo(@50);
        }];
        
        _vipImg = [[UIImageView alloc] init];
        [cell addSubview:_vipImg];
        [_vipImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerImgView.mas_right).offset(3);
            make.bottom.equalTo(_headerImgView.mas_bottom);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }];
        
        _showMoney = [UIButton buttonWithType:UIButtonTypeCustom];
        [cell addSubview:_showMoney];
        _showMoney.userInteractionEnabled = NO;
        if ([[CacheHelper getTotalAssetDataString] isEqualToString:@"****"])
        {
            _showMoney.userInteractionEnabled = YES;
            [_showMoney setImage:[UIImage imageNamed:@"passwordHidden.png"] forState:UIControlStateNormal];
            [_showMoney setImage:[UIImage imageNamed:@"passwordShow.png"] forState:UIControlStateSelected];
            [_showMoney addTarget:self action:@selector(isCloseMoney:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [_showMoney setImage:[UIImage imageNamed:@"passwordShow.png"] forState:UIControlStateNormal];
            [_showMoney setImage:[UIImage imageNamed:@"passwordHidden.png"] forState:UIControlStateSelected];
            [_showMoney addTarget:self action:@selector(isShowMoney:) forControlEvents:UIControlEventTouchUpInside];
        }
        [_showMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerImgView.mas_bottom).offset(5);
            make.right.equalTo(cell.mas_right);
            make.width.equalTo(@60);
            make.height.equalTo(@50);
        }];
        
        //显示总资产
        _totalAssetLB = [[UILabel alloc] init];
        [cell addSubview:_totalAssetLB];
        _totalAssetLB.text = @"";
        _totalAssetLB.textAlignment = NSTextAlignmentCenter;
        [_totalAssetLB decorateLabelStyleWithCharacterFont:[UIFont fontWithName:@"Helvetica" size:40] characterColor:[UIColor whiteColor]];
        [_totalAssetLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@40);
            make.top.equalTo(_headerImgView.mas_bottom).offset(20);
            make.centerX.equalTo(cell.mas_centerX);
            make.width.equalTo(cell.mas_width);
        }];
        
        _totalAssetTitleLB = [[UILabel alloc] init];
        [cell addSubview:_totalAssetTitleLB];
        _totalAssetTitleLB.text = @"总资产(元)";
        _totalAssetTitleLB.textAlignment = NSTextAlignmentCenter;
        _totalAssetTitleLB.textColor = [UIColor whiteColor];
        _totalAssetTitleLB.font = [UIFont systemFontOfSize:14];
        [_totalAssetTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_totalAssetLB.mas_bottom);
            make.centerX.equalTo(cell.mas_centerX);
            make.width.equalTo(@180);
            make.height.equalTo(@20);
        }];
        
        //余额
        AssetSubIncomeView *leftIncomeView = [[AssetSubIncomeView alloc] initWithTitle:@"可用资产(元)"];
        [cell addSubview:leftIncomeView];
        _balanceLB = leftIncomeView.contentLB;
        _balanceLB.text = @"";
        [leftIncomeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left);
            make.top.equalTo(_totalAssetTitleLB.mas_bottom).offset(20);
            make.width.equalTo(cell.mas_width).multipliedBy(0.33);
            make.centerX.equalTo(@(cell.frame.size.width / 3));
            make.height.equalTo(@50);
        }];
        //昨日收益
        AssetSubIncomeView *yesterdayProfitView = [[AssetSubIncomeView alloc] initWithTitle:@"昨日收益(元)"];
        [cell addSubview:yesterdayProfitView];
        _yesterdayProfitLB = yesterdayProfitView.contentLB;
        _yesterdayProfitLB.text = @"0.00";
        [yesterdayProfitView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(leftIncomeView.mas_top);
            make.width.equalTo(cell.mas_width).multipliedBy(0.33);
            make.centerX.equalTo(cell.mas_centerX);
            make.height.equalTo(@50);
        }];
        
        //累计收益
        AssetSubIncomeView *rightIncomeView = [[AssetSubIncomeView alloc] initWithTitle:@"累计收益(元)"];
        [cell addSubview:rightIncomeView];
        _accumulationProfitLB = rightIncomeView.contentLB;
        _accumulationProfitLB.text = @"";
        [rightIncomeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.mas_right);
            make.top.equalTo(leftIncomeView.mas_top);
            make.width.equalTo(cell.mas_width).multipliedBy(0.33);
            make.centerX.equalTo(@(cell.frame.size.width / 3 * 2));
            make.height.equalTo(@50);
        }];
        
        if (!_btBackgroundView) {
            _btBackgroundView = [[UIView alloc] init];
            _btBackgroundView.backgroundColor = [UIColor whiteColor];
            _btBackgroundView.layer.cornerRadius=5;
            _btBackgroundView.layer.shadowColor=[UIColor grayColor].CGColor;
            _btBackgroundView.layer.shadowOffset=CGSizeMake(1, 1);
            _btBackgroundView.layer.shadowOpacity=0.5;
            _btBackgroundView.layer.shadowRadius=5;
            [cell addSubview:_btBackgroundView];
            [_btBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.mas_left).offset(15);
                make.right.equalTo(cell.mas_right).offset(-15);
                make.top.equalTo(cell.mas_top).offset(240);
                make.height.equalTo(@60);
            }];
        }
        [cell bringSubviewToFront:_btBackgroundView];

        _withdrawalsBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btBackgroundView addSubview:_withdrawalsBT];
        [FastAnimationAdd codeBindAnimation:_withdrawalsBT];
        [_withdrawalsBT setImage:[UIImage imageNamed:@"withdrawalsBT_img.png"] forState:UIControlStateNormal];
        [_withdrawalsBT addTarget:self action:@selector(clickWithdrawalsBT:) forControlEvents:UIControlEventTouchUpInside];
        [_withdrawalsBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_btBackgroundView.mas_top);
            make.bottom.equalTo(_btBackgroundView.mas_bottom);
            make.width.equalTo(@((cell.frame.size.width - 30) / 2));
            make.left.equalTo(_btBackgroundView.mas_left);
        }];
        
        _rechargeBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btBackgroundView addSubview:_rechargeBT];
        [FastAnimationAdd codeBindAnimation:_rechargeBT];
        [_rechargeBT setImage:[UIImage imageNamed:@"rechargeBT_img@2x.png"] forState:UIControlStateNormal];
        [_rechargeBT addTarget:self action:@selector(clickRechargeBT:) forControlEvents:UIControlEventTouchUpInside];
        [_rechargeBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_withdrawalsBT.mas_right);
            make.top.equalTo(_withdrawalsBT.mas_top);
            make.width.equalTo(@((cell.frame.size.width - 30) / 2));
            make.bottom.equalTo(_withdrawalsBT.mas_bottom);
        }];
        
        return cell;
    }
    return nil;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([InspectNetwork connectedToNetwork]) {
        [self goToNextPageWith:indexPath];
    }else {
        [SVProgressHUD showErrorWithStatus:NotHaveNetwork];
    }
}

- (void)goToNextPageWith:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [MobClick event:@"my_assert_trade_record"];
        ExchangeDetailVC *exchangeVC = [[ExchangeDetailVC alloc] init];
        exchangeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:exchangeVC animated:YES];
    }
    if (indexPath.row == 1) {
        [MobClick event:@"my_assert_bought_product"];
        AlreadyBuyProductVC *already=[[AlreadyBuyProductVC alloc] init];
        already.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:already animated:YES];
    }
    if (indexPath.row == 2){
        VipCenterViewController *vipCenter = [[VipCenterViewController alloc] init];
        vipCenter.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vipCenter animated:YES];
    }
    if (indexPath.row == 3) {
        [MobClick event:@"my_assert_red_bag"];
        MyBonusVC *bonus = [[MyBonusVC alloc] init];
        bonus.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bonus animated:YES];
    }
    if (indexPath.row == 4) {
        [MobClick event:@"my_assert_my_invite"];
        [VCAppearManager pushNewH5VCWithCurrentVC:self workS:invitorFriend];
    }
    if (indexPath.row == 5) {
        [MobClick event:@"my_assert_silver"];
        MySilverVC *silverVC = [[MySilverVC alloc] init];
        silverVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:silverVC animated:YES];
    }
}

- (void)noLogin {
    _backContentView.hidden = NO;
    AssetNotLoginView *asset =[[AssetNotLoginView alloc] initWithFrame:CGRectMake(0, 0, 300, 400) noteTitle:@"土豪！您还没有登录呢!" btTitle:@"点击登录"];
    asset.translatesAutoresizingMaskIntoConstraints=NO;
    [self.backContentView addSubview:asset];
    [self.backContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[asset]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(asset)]];
    [self.backContentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[asset]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(asset)]];
    [self.view bringSubviewToFront:_backContentView];
    [asset logInWith:^{
        [VCAppearManager presentLoginVCWithCurrentVC:self];
    }];
}

- (void)clearBackContentViewSubView {
    if ([_backContentView subviews] != 0) {
        for (UIView *vi in [_backContentView subviews]) {
            [vi removeFromSuperview];
        }
        [self.view sendSubviewToBack:_backContentView];
    }
    _backContentView.hidden=YES;
}

- (void)dataInitialize {
    _dataSource=[NSMutableArray array];
    NSDictionary *tradeDetail=[NSDictionary dictionaryWithObjectsAndKeys:
                               @"ExchangeDetail.png",@"imageName",@"交易明细",@"name",@"查看交易明细",@"viceName", nil];
    NSDictionary *alreadyBuyProduct=[NSDictionary dictionaryWithObjectsAndKeys:
                                     @"TradeMark.png",@"imageName",@"已购产品",@"name",@"查看已购产品",@"viceName", nil];
    NSDictionary *vipLevel=[NSDictionary dictionaryWithObjectsAndKeys:
                               @"vipCenter.png",@"imageName",@"会员中心",@"name",@"查看会员特权",@"viceName", nil];
    NSDictionary *productMark=[NSDictionary dictionaryWithObjectsAndKeys:
                               @"优惠券.png",@"imageName",@"我的优惠券",@"name",@"查看我的优惠券",@"viceName", nil];
    NSDictionary *myInvite=[NSDictionary dictionaryWithObjectsAndKeys:
                            @"我的邀请.png",@"imageName",@"我的邀请",@"name",@"查看我的邀请",@"viceName", nil];
    NSDictionary *myBonus=[NSDictionary dictionaryWithObjectsAndKeys:
                           @"MyBonus.png",@"imageName",@"我的银子",@"name",@"查看我的银子",@"viceName", nil];
    [_dataSource addObject:tradeDetail];
    [_dataSource addObject:alreadyBuyProduct];
    [_dataSource addObject:vipLevel];
    [_dataSource addObject:productMark];
    [_dataSource addObject:myInvite];
    [_dataSource addObject:myBonus];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentNetState:) name:Network_State_name object:nil];
}

//实时检测网络状态
- (void)updateCurrentNetState:(NSNotification *)note {
    BOOL isnet=[[note.userInfo objectForKey:@"state"] boolValue];
    [self.navigationController detectionCurrentNetWith:isnet];
}

- (void)clickWithdrawalsBT:(UIButton *)sender
{
    [SVProgressHUD showWithStatus:PleaseWaitALittleWhile];
    _collectionView.userInteractionEnabled = NO;
    _withdrawalsBT.userInteractionEnabled = NO;
    [MobClick event:@"my_assert_withdraw_btn"];
    [self isDredgeBankAccount:@"drawalsBT"];
}

- (void)clickRechargeBT:(UIButton *)sender
{
    [SVProgressHUD showWithStatus:PleaseWaitALittleWhile];
    _rechargeBT.userInteractionEnabled = NO;
    _collectionView.userInteractionEnabled = NO;
    [MobClick event:@"my_assert_recharge_btn"];
    [self isDredgeBankAccount:@"rechargeBT"];
}

- (void)UIDecorate {
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    [_customNav.leftButton setImage:[UIImage imageNamed:@"asset_more.png"] forState:UIControlStateNormal];
    [_customNav.rightButton setImage:[UIImage imageNamed:@"MessageRead.png"] forState:UIControlStateNormal];
    _customNav.titleLabel.text = @"我的";
    self.title = @"我的";
    [self.view addSubview:_customNav];
    __weak typeof(self) weakSelf = self;
    self.customNav.leftViewController = ^(){
        [MobClick event:@"my_assert_more"];
        MoreVC *moreVC = [[MoreVC alloc] init];
        moreVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:moreVC animated:YES];
    };
    
    _customNav.rightButtonHandle = ^{
        IndividualInfoManage *user = [IndividualInfoManage currentAccount];
        if (user) {
            UserMessageVC *userMessageVC = [[UserMessageVC alloc] init];
            userMessageVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:userMessageVC animated:YES];
        }else{
            [VCAppearManager presentLoginVCWithCurrentVC:weakSelf];
        };
    };
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.frame.size.width / 2 - 0.5, 75);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    if (IS_iPhoneX) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, iPhoneX_Navigition_Bar_Height, self.view.frame.size.width, self.view.frame.size.height - iPhoneX_Navigition_Bar_Height - 84) collectionViewLayout:layout];
    }else{
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width,self.view.frame.size.height - 64 - 50) collectionViewLayout:layout];
    }
    
    _collectionView.backgroundColor = [UIColor backgroundGrayColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //注册cell
    [_collectionView registerClass:[MyAssetCollectionViewCell class] forCellWithReuseIdentifier:@"assetsCell"];
    //注册页眉
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"assetHeadCell"];
    
    [self.view addSubview:_collectionView];
    
    weakSelf.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        IndividualInfoManage *user = [IndividualInfoManage currentAccount];
        [self achieveAssetDataWith:user.customerId];
        if ([[CacheHelper getTotalAssetDataString] isEqualToString:@"****"]){
            _showMoney.userInteractionEnabled = YES;
        }else{
            _showMoney.userInteractionEnabled = NO;
        }
    }];
    
    _backContentView = [[UIView alloc] init];
    [self.view addSubview:_backContentView];
    _backContentView.backgroundColor = [UIColor clearColor];
    [_backContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
- (void)isShowMoney:(UIButton *)sender{
    if (sender.selected) {
        [MobClick event:@"my_assert_open"];
        self.totalAssetLB.text=[NSString stringWithFormat:@"%.2f",[StringHelper roundValueWith:[self.myAssetModel.totalAsset doubleValue]]];
        self.balanceLB.text = [NSString stringWithFormat:@"%.2f",floor([self.myAssetModel.balance doubleValue] *100) / 100];
        self.accumulationProfitLB.text = [NSString stringWithFormat:@"%.2f",floor([self.myAssetModel.accumulationProfit doubleValue] *100) / 100];
        self.yesterdayProfitLB.text = [NSString stringWithFormat:@"%.2f",floor([self.myAssetModel.yesterdayProfit doubleValue] *100) / 100];
        [CacheHelper deletTotalAssetDataString];
    } else {
        [MobClick event:@"my_assert_close"];
        self.totalAssetLB.text = @"****";
        self.balanceLB.text = @"****";
        self.accumulationProfitLB.text = @"****";
        self.yesterdayProfitLB.text = @"****";
        [CacheHelper saveTotalAssetDataString:self.totalAssetLB.text];
    }
    sender.selected = !sender.selected;
}

- (void)isCloseMoney:(UIButton *)sender
{
    if (sender.selected) {
        self.totalAssetLB.text = @"****";
        self.balanceLB.text = @"****";
        self.accumulationProfitLB.text = @"****";
        self.yesterdayProfitLB.text = @"****";
        [CacheHelper saveTotalAssetDataString:self.totalAssetLB.text];
    } else {
        self.totalAssetLB.text = [NSString stringWithFormat:@"%.2f",[StringHelper roundValueWith:[self.myAssetModel.totalAsset doubleValue]]];
        self.balanceLB.text = [NSString stringWithFormat:@"%.2f",floor([self.myAssetModel.balance doubleValue] *100) / 100];
        self.accumulationProfitLB.text = [NSString stringWithFormat:@"%.2f",floor([self.myAssetModel.accumulationProfit doubleValue] *100) / 100];
        self.yesterdayProfitLB.text = [NSString stringWithFormat:@"%.2f",floor([self.myAssetModel.yesterdayProfit doubleValue] *100) / 100];
        [CacheHelper deletTotalAssetDataString];
    }
    sender.selected = !sender.selected;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end

