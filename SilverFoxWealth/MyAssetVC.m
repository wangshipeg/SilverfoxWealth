//
//  MyAssetVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/3/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MyAssetVC.h"
#import "CommunalInfo.h"
#import "MyAssetCell.h"
#import "MySilverVC.h"
#import "MyBonusVC.h" //我的红包
#import "AlreadyBuyProductVC.h" //已购产品
#import "MyBankCardListVC.h"
#import "DataRequest.h"
#import "IndividualInfoManage.h" //用户信息管理
#import "AssetNotLoginView.h"
#import "UINavigationController+DetectionNetState.h"
#import "ShareConfig.h"

#import "UserInfoUpdate.h"  //用户信息更新
#import "StringHelper.h"
#import "AnimationHelper.h"

#import "AssetModel.h"
#import "WithoutAuthorization.h"

#import "RequestOAth.h"
#import "PromptLanguage.h"
#import "UMMobClick/MobClick.h"
#import "InspectNetwork.h"
#import "VCAppearManager.h"
#import <Masonry/Masonry.h>
#import "UIColor+CustomColors.h"
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

@interface MyAssetVC ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UILabel        *totalAssetTitleLB;
//和所有显示内容一般大的一个view 用做未登录提示父视图
@property (strong, nonatomic) UIView         *backContentView;
@property (strong, nonatomic) UITableView    *tableView;
@property (strong, nonatomic) UILabel        *totalAssetLB;//总资产
@property (strong, nonatomic) UILabel        *balanceLB;
@property (strong, nonatomic) UILabel        *accumulationProfitLB;//累计收益
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (strong, nonatomic) BottomBlackLineView         *tableHeaderView;
@property (nonatomic, strong) AssetModel *myAssetModel;
@property (nonatomic, strong) UIButton *showMoney;
@property (nonatomic, strong) UIImageView *messageNoteIM;
@property (nonatomic, strong) NSMutableArray *systemSource;
@property (nonatomic, strong) NSMutableArray *mutArr;

@end

@implementation MyAssetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
    [self dataInitialize];
    [self barStyle];
    [self showUsetInfo];
    _messageNoteIM.image = [UIImage imageNamed:@"MessageRead.png"];
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(addMessageNoteWith:) name:Message_Center_Name object:nil];
}

- (void)addMessageNoteWith:(NSNotificationCenter *)sender
{
    _messageNoteIM.image = [UIImage imageNamed:@"MessageNORead.png"];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[CacheHelper getTotalAssetDataString] isEqualToString:@"****"])
    {
        _showMoney.userInteractionEnabled = YES;
    }else{
        _showMoney.userInteractionEnabled = NO;
    }
    
    NSUserDefaults *userDEfault = [NSUserDefaults standardUserDefaults];
    if ([userDEfault boolForKey:@"assetView"] == NO) {
        [self isDredgeBankAccount:@"viewWillAppear"];
        [userDEfault setBool:YES forKey:@"assetView"];
    }
    [self loadUserAsset];
}

- (void)isDredgeBankAccount:(NSString *)markStr
{
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] achieveCustomerUserInfoWithcustomerId:user.customerId callback:^(id obj) {
        if ([obj isKindOfClass:[IndividualInfoManage class]]) {
            IndividualInfoManage *resultUser = obj;
            if (resultUser.accountId.length == 0) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您还未开通银行存管账户\n是否开通?" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"以后再说" style:UIAlertActionStyleDefault handler:nil];
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"立即开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:otherAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }else{
                if ([markStr isEqualToString:@"drawalsBT"]) {
                    DrawalsVC *drawalsVC = [[DrawalsVC alloc] init];
                    drawalsVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:drawalsVC animated:YES];
                }
                if ([markStr isEqualToString:@"rechargeBT"]) {
                    
                }
            }
        }
    }];
}

- (void)showUsetInfo
{
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    if (user) {
        [[DataRequest sharedClient] obtainUserNoReadMessageWithcustomerId:user.customerId callback:^(id obj) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                
                if ([obj[@"unreadCount"] intValue] > 0) {
                    _messageNoteIM.image = [UIImage imageNamed:@"MessageNORead.png"];;
                    return;
                }
                _messageNoteIM.image = [UIImage imageNamed:@"MessageRead.png"];
            }
        }];
    }
}

- (void)loadUserAsset
{
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    //如果已经登录
    if (user) {
        [self clearBackContentViewSubView];
        [self achieveAssetDataWith:user.customerId];
    }else {
        [self noLogin];
    }
}

-(void)achieveAssetDataWith:(NSString *)customerId
{
    [[DataRequest sharedClient] obtainUserAssetWithcustomerId:customerId callback:^(id obj)
    {
        DLog(@"我的资产加载结果====%@",obj);
        if ([obj isKindOfClass:[AssetModel class]])
        {
            self.myAssetModel = obj;
            if (![[CacheHelper getTotalAssetDataString] isEqualToString:@"****"])
            {
                [self showAssetDetail:self.myAssetModel];
            }else{
                [self showCloseDetail];
            }
            //缓存数据
            [CacheHelper saveAssetData:obj];
        }
        //授权
        if ([obj isKindOfClass:[WithoutAuthorization class]])
        {
            [RequestOAth authenticationWithclient_id:customerId response_type:@"code" callback:^(BOOL succeedState) {
                if (succeedState == YES) {
                    [self achieveAssetDataWith:customerId];
                }
                if (succeedState == NO) {
                    [UserInfoUpdate clearUserLocalInfo];
                    [self noLogin];
                }
                return;
            }];
        }
        //请求出错
        if ([obj isKindOfClass:[NSError class]]) {
            DLog(@"加载失败 使用缓存数据");
            AssetModel *dic=[CacheHelper currentAssetData];
            if (dic) {
                [self showAssetDetail:dic];
            }
        }
    }];
}
//
- (void)showCloseDetail
{
    self.totalAssetLB.text = @"****";
    self.balanceLB.text = @"****";
    self.accumulationProfitLB.text = @"****";
}
//动画展示个人信息
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
    
    NSString *accumulationValue=[NSString stringWithFormat:@"%.2f",[StringHelper roundValueWith:[dic.accumulationProfit doubleValue]]];
    [self.accumulationProfitLB pop_addAnimation:[AnimationHelper addValueChangeAnimationWithFinallyValue:[accumulationValue doubleValue] anmationCompletion:^{
        self.accumulationProfitLB.text=accumulationValue;
    }] forKey:@"accumulationProfitLB"];
}

-(NSString *)notRounding:( float )price afterPoint:( int )position
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness: NO  raiseOnOverflow: NO  raiseOnUnderflow: NO  raiseOnDivideByZero: NO ];
    
    NSDecimalNumber *ouncesDecimal;
    
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return  [NSString stringWithFormat: @"%@" ,roundedOunces];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *assetCellIdentifier=@"MyAssetCell";
    MyAssetCell *cell = [tableView dequeueReusableCellWithIdentifier:assetCellIdentifier];
    if (!cell) {
        cell=[[MyAssetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:assetCellIdentifier];
    }
    [cell giveValueWithDic:[_dataSource objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([InspectNetwork connectedToNetwork]) {
        [self goToNextPageWith:indexPath];
    }else {
        [SVProgressHUD showErrorWithStatus:NotHaveNetwork];
    }
}
- (void)goToNextPageWith:(NSIndexPath *)indexPath {
    //已购产品
    if (indexPath.row == 1) {
        [MobClick event:@"my_assert_bought_product"];
        AlreadyBuyProductVC *already=[[AlreadyBuyProductVC alloc] init];
        already.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:already animated:YES];
    }
    //我的优惠券
    if (indexPath.row == 2) {
        [MobClick event:@"my_assert_red_bag"];
        MyBonusVC *bonus=[[MyBonusVC alloc] init];
        bonus.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:bonus animated:YES];
    }
    //我的银子
    if (indexPath.row == 3) {
        [MobClick event:@"my_assert_silver"];
        MySilverVC *silverVC = [[MySilverVC alloc] init];
        silverVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:silverVC animated:YES];
    }
    //我的邀请
    if (indexPath.row == 4) {
        [MobClick event:@"my_assert_my_invite"];
        [VCAppearManager pushH5VCWithCurrentVC:self workS:myInvitor];
    }
    
    //我的银行卡
    if (indexPath.row == 5) {
        [MobClick event:@"my_assert_my_bank_card"];
        MyBankCardListVC *list=[[MyBankCardListVC alloc] init];
        list.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:list animated:YES];
    }
}

//未登录 页面处理
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

//清除 登录背景视图上的登陆视图 如果有
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
    self.title=@"我的资产";
    _dataSource=[NSMutableArray array];
    NSDictionary *tradeDetail=[NSDictionary dictionaryWithObjectsAndKeys:
                               @"ExchangeDetail.png",@"imageName",@"交易明细",@"name", nil];
    NSDictionary *alreadyBuyProduct=[NSDictionary dictionaryWithObjectsAndKeys:
                                     @"TradeMark.png",@"imageName",@"已购产品",@"name", nil];
    NSDictionary *productMark=[NSDictionary dictionaryWithObjectsAndKeys:
                               @"优惠券.png",@"imageName",@"我的优惠券",@"name", nil];
    NSDictionary *myBonus=[NSDictionary dictionaryWithObjectsAndKeys:
                           @"MyBonus.png",@"imageName",@"我的银子",@"name", nil];
    NSDictionary *mySilver=[NSDictionary dictionaryWithObjectsAndKeys:
                            @"我的邀请.png",@"imageName",@"我的邀请",@"name", nil];
    NSDictionary *myBankCard=[NSDictionary dictionaryWithObjectsAndKeys:
                              @"MyBankCard.png",@"imageName",@"我的银行卡",@"name", nil];
    [_dataSource addObject:tradeDetail];
    [_dataSource addObject:alreadyBuyProduct];
    [_dataSource addObject:productMark];
    [_dataSource addObject:myBonus];
    [_dataSource addObject:mySilver];
    [_dataSource addObject:myBankCard];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentNetState:) name:Network_State_name object:nil];
}
//实时检测网络状态
- (void)updateCurrentNetState:(NSNotification *)note {
    BOOL isnet=[[note.userInfo objectForKey:@"state"] boolValue];
    [self.navigationController detectionCurrentNetWith:isnet];
}

- (void)barStyle
{
    _messageNoteIM = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageRead.png"]];
    _messageNoteIM.frame=CGRectMake(0, 0, 18, 18);
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:_messageNoteIM];
    self.navigationItem.rightBarButtonItem = rightBar;
    UITapGestureRecognizer *rightTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightTapGesture:)];
    [_messageNoteIM addGestureRecognizer:rightTapGesture];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"更多";
    label.textColor = [UIColor iconBlueColor];
    [view addSubview:label];
    UIBarButtonItem *barBT = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = barBT;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [view addGestureRecognizer:tapGesture];
}

- (void)handleRightTapGesture:(UITapGestureRecognizer *)sender
{
    UserMessageVC *userMessageVC = [[UserMessageVC alloc] init];
    userMessageVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userMessageVC animated:YES];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender
{
    [MobClick event:@"my_assert_more"];
    _messageNoteIM.image = [UIImage imageNamed:@"MessageRead.png"];
    MoreVC *moreVC = [[MoreVC alloc] init];
    moreVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:moreVC animated:YES];
}

- (void)clickWithdrawalsBT:(UIButton *)sender
{
    DrawalsVC *drawalsVC = [[DrawalsVC alloc] init];
    drawalsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:drawalsVC animated:YES];
   // [self isDredgeBankAccount:@"drawalsBT"];
}

- (void)clickRechargeBT:(UIButton *)sender
{
    [self isDredgeBankAccount:@"rechargeBT"];
}

- (void)UIDecorate {
    self.view.backgroundColor=[UIColor backgroundGrayColor];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets=YES;
    
    //tableview
    _tableView=[[UITableView alloc] init];
    [self.view addSubview:_tableView];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    _tableView.showsVerticalScrollIndicator = NO;
    
    __weak typeof(self) weakSelf = self;
    weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        IndividualInfoManage *user=[IndividualInfoManage currentAccount];
        [self achieveAssetDataWith:user.customerId];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
    //headerView
    _tableHeaderView = [[BottomBlackLineView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 284 / 375)];
    self.tableView.tableHeaderView = _tableHeaderView;
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableHeaderView.backgroundColor = [UIColor whiteColor];
    
    _showMoney = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tableHeaderView addSubview:_showMoney];
    _showMoney.userInteractionEnabled = NO;
    if ([[CacheHelper getTotalAssetDataString] isEqualToString:@"****"])
    {
        _showMoney.userInteractionEnabled = YES;
        [_showMoney setImage:[UIImage imageNamed:@"passwordHidden.png"] forState:UIControlStateNormal];
        [_showMoney setImage:[UIImage imageNamed:@"passwordShow.png"] forState:UIControlStateSelected];
        [_showMoney addTarget:self action:@selector(isCloseMoney:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_showMoney setImage:[UIImage imageNamed:@"passwordShow.png"] forState:UIControlStateNormal];
        [_showMoney setImage:[UIImage imageNamed:@"passwordHidden.png"] forState:UIControlStateSelected];
        [_showMoney addTarget:self action:@selector(isShowMoney:) forControlEvents:UIControlEventTouchUpInside];
    }
    [_showMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableHeaderView.mas_top).offset(10);
        make.right.equalTo(_tableHeaderView.mas_right);
        make.width.equalTo(@60);
        make.height.equalTo(@50);
    }];
    
    //显示总资产
    _totalAssetLB=[[UILabel alloc] init];
    [_tableHeaderView addSubview:_totalAssetLB];
    _totalAssetLB.text=@"";
    [_totalAssetLB decorateLabelStyleWithCharacterFont:[UIFont fontWithName:@"Helvetica" size:40] characterColor:[UIColor zheJiangBusinessRedColor]];
    _totalAssetLB.textAlignment=NSTextAlignmentLeft;
    [_totalAssetLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.top.equalTo(_tableHeaderView.mas_top).offset(40);
        make.left.equalTo(_tableHeaderView.mas_left).offset(25);
        make.width.equalTo(_tableHeaderView.mas_width);
    }];
    
    //总资产标题
    _totalAssetTitleLB=[[UILabel alloc] init];
    [_tableHeaderView addSubview:_totalAssetTitleLB];
    _totalAssetTitleLB.textAlignment = NSTextAlignmentLeft;
    _totalAssetTitleLB.text = @"总资产(元)";
    _totalAssetTitleLB.textColor = [UIColor depictBorderGrayColor];
    _totalAssetTitleLB.font = [UIFont systemFontOfSize:14];
    [_totalAssetTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_totalAssetLB.mas_bottom);
        make.left.equalTo(_tableHeaderView.mas_left).offset(25);
        make.width.equalTo(@180);
        make.height.equalTo(@20);
    }];
    
    //余额
    AssetSubIncomeView *leftIncomeView=[[AssetSubIncomeView alloc] initWithTitle:@"可用资产(元)"];
    [_tableHeaderView addSubview:leftIncomeView];
    _balanceLB = leftIncomeView.contentLB;
    [leftIncomeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tableHeaderView.mas_left).offset(25);
        make.top.equalTo(_totalAssetTitleLB.mas_bottom).offset(20);
        make.width.equalTo(_tableHeaderView.mas_width).multipliedBy(0.5).offset(-15);
        make.height.equalTo(@70);
    }];
    
    UIImageView *imageLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"financialLine.png"]];
    [_tableHeaderView addSubview:imageLine];
    [imageLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftIncomeView.mas_centerY);
        make.centerX.equalTo(_tableHeaderView.mas_centerX);
        make.height.equalTo(@40);
        make.width.equalTo(@1);
    }];
    
    //累计收益
    AssetSubIncomeView *rightIncomeView=[[AssetSubIncomeView alloc] initWithTitle:@"累计收益(元)"];
    [_tableHeaderView addSubview:rightIncomeView];
    _accumulationProfitLB = rightIncomeView.contentLB;
    [rightIncomeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageLine.mas_right).offset(15);
        make.top.equalTo(leftIncomeView.mas_top);
        make.width.equalTo(_tableHeaderView.mas_width).multipliedBy(0.5).offset(-15);
        make.height.equalTo(@70);
    }];
    
    UIButton *withdrawalsBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tableHeaderView addSubview:withdrawalsBT];
    withdrawalsBT.layer.cornerRadius = 20;
    withdrawalsBT.layer.masksToBounds = YES;
    withdrawalsBT.backgroundColor = [UIColor iconBlueColor];
    [FastAnimationAdd codeBindAnimation:withdrawalsBT];
    withdrawalsBT.titleLabel.font = [UIFont systemFontOfSize:15];
    [withdrawalsBT setTitle:@"提现" forState:UIControlStateNormal];
    [withdrawalsBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [withdrawalsBT addTarget:self action:@selector(clickWithdrawalsBT:) forControlEvents:UIControlEventTouchUpInside];
    [withdrawalsBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_tableHeaderView.mas_bottom).offset(-40);
        make.left.equalTo(self.view.mas_left).offset(25);
        make.right.equalTo(self.view.mas_centerX).offset(-25);
        make.height.equalTo(@44);
    }];
    
    UIButton *rechargeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [_tableHeaderView addSubview:rechargeBT];
    rechargeBT.layer.cornerRadius = 20;
    rechargeBT.layer.masksToBounds = YES;
    rechargeBT.backgroundColor = [UIColor zheJiangBusinessRedColor];
    [FastAnimationAdd codeBindAnimation:rechargeBT];
    rechargeBT.titleLabel.font = [UIFont systemFontOfSize:15];
    [rechargeBT setTitle:@"充值" forState:UIControlStateNormal];
    [rechargeBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rechargeBT addTarget:self action:@selector(clickRechargeBT:) forControlEvents:UIControlEventTouchUpInside];
    [rechargeBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_tableHeaderView.mas_bottom).offset(-40);
        make.left.equalTo(self.view.mas_centerX).offset(25);
        make.right.equalTo(self.view.mas_right).offset(-25);
        make.height.equalTo(@44);
    }];
    
    _backContentView = [[UIView alloc] init];
    [self.view addSubview:_backContentView];
    _backContentView.backgroundColor = [UIColor clearColor];
    [_backContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
- (void)isShowMoney:(UIButton *)sender{
    if (sender.selected) {
        [MobClick event:@"my_assert_open"];
        self.totalAssetLB.text=[NSString stringWithFormat:@"%.2f",[StringHelper roundValueWith:[self.myAssetModel.totalAsset doubleValue]]];
        self.balanceLB.text = [NSString stringWithFormat:@"%.2f",[self.myAssetModel.balance doubleValue]];
        self.accumulationProfitLB.text = [NSString stringWithFormat:@"%.2f",[self.myAssetModel.accumulationProfit doubleValue]];
        [CacheHelper deletTotalAssetDataString];
    }else {
        [MobClick event:@"my_assert_close"];
        self.totalAssetLB.text = @"****";
        self.balanceLB.text = @"****";
        self.accumulationProfitLB.text = @"****";
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
        [CacheHelper saveTotalAssetDataString:self.totalAssetLB.text];
    }else {
        self.totalAssetLB.text=[NSString stringWithFormat:@"%.2f",[StringHelper roundValueWith:[self.myAssetModel.totalAsset doubleValue]]];
        self.balanceLB.text = [NSString stringWithFormat:@"%.2f",[self.myAssetModel.balance doubleValue]];
        self.accumulationProfitLB.text = [NSString stringWithFormat:@"%.2f",[self.myAssetModel.accumulationProfit doubleValue]];
        [CacheHelper deletTotalAssetDataString];
    }
    sender.selected = !sender.selected;
}

//#pragma -mark UTtableviewStyle
//-(void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
//    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] init];
    view.backgroundColor=[UIColor depictBorderGrayColor];
    return view;
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
