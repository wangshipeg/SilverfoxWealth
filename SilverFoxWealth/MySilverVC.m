//
//  MySilverVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/12/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MySilverVC.h"
#import <MJRefresh.h>
#import "DataRequest.h"
#import "StringHelper.h"
#import "RoundCornerClickBT.h"
#import "WithoutAuthorization.h"
#import "UserInfoUpdate.h"
#import "VCAppearManager.h"
#import "SilverClearCell.h"
#import "TopBottomBalckBorderView.h"
#import "SilverTraderVC.h"
#import "UIBarButtonItem+SXCreate.h"

@interface MySilverVC ()<UITableViewDelegate,UITableViewDataSource>
{
    int page;
    int pages;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIView *backContentView;
@property (nonatomic, strong) NSString *silverNum;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) CustomerNavgationController *customNav;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *headView;

@end

@implementation MySilverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    [self UIDecorate];
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [self achieveSilverDetailDataWith:user.customerId];
    // Do any additional setup after loading the view.
}

- (void)achieveSilverDetailDataWith:(NSString *)customerId {
    [[DataRequest sharedClient]achieveCustomerUserInfoWithcustomerId:customerId callback:^(id obj) {
        if ([obj isKindOfClass:[IndividualInfoManage class]]) {
            IndividualInfoManage *resultUser=obj;
            [IndividualInfoManage updateAccountWith:resultUser];
            _label.attributedText = [StringHelper renderFrontAndAfterDifferentFontWithValue:@"我的银子: " frontFont:14 frontColor:[UIColor characterBlackColor] afterStr:[NSString stringWithFormat:@"%@两",resultUser.silverNumber]  afterFont:14 afterColor:[UIColor zheJiangBusinessRedColor]];
        }
        //需要授权
        if ([obj isKindOfClass:[WithoutAuthorization class]]) {
            [UserInfoUpdate clearUserLocalInfo];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [VCAppearManager presentLoginVCWithCurrentVC:self];
        }
    }];
    [[DataRequest sharedClient] obtainUserSilverDetailWithcustomerId:customerId page:page callback:^(id obj) {
        DLog(@"银子明细加载结果=====%@",obj);
        [self.tableView.mj_header  endRefreshing];
        [self.tableView.mj_footer  endRefreshing];
        //正常获取数据
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] intValue] == 2000) {
                NSDictionary *dic=obj[@"data"];
                pages = [dic[@"pages"] intValue];
                if (page >= pages) {
                    self.tableView.mj_footer.hidden = YES;
                    [self loadSilverDetailDataWith:dic];
                    return;
                }
                self.tableView.mj_footer.hidden = NO;
                [self loadSilverDetailDataWith:dic];
            }else{
                [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
            }
        }
        //去授权
        if ([obj isKindOfClass:[WithoutAuthorization class]]) {
            [UserInfoUpdate clearUserLocalInfo];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [VCAppearManager presentLoginVCWithCurrentVC:self];
        }
    }];
}

- (void)loadSilverDetailDataWith:(NSDictionary *)dic
{
    
    if (!self.dataSource)
    {
        self.dataSource = [NSMutableArray array];
    }
    if (dic[@"silverDetails"])
    {
        NSMutableArray *detailListArray=dic[@"silverDetails"];
        if (detailListArray.count == 0) {
            [self notHaveSilverClearList];
        }else{
            [self clearBackContentViewSubView];
            [self.dataSource addObjectsFromArray:detailListArray];
            [self.tableView reloadData];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (void)clickChangeGoodsBT:(RoundCornerClickBT *)sender
{
    [MobClick event:@"my_silver_exchange_goods_clicked"];
    SilverTraderVC *silverVC = [[SilverTraderVC alloc] init];
    silverVC.whereFrom = @"mySilver";
    [self.navigationController pushViewController:silverVC animated:YES];
}

- (void)backToSelfVC
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *silverIdentifier=@"SilverClear";
    SilverClearCell *cell = [tableView dequeueReusableCellWithIdentifier:silverIdentifier];
    if (!cell) {
        cell=[[SilverClearCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:silverIdentifier];
    }
    if (self.dataSource.count == 0) {
        return cell;
    }
    [cell showInfoWithDic:[self.dataSource objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//清除 无数据背景视图
- (void)clearBackContentViewSubView {
    self.tableView.bounces = YES;
    if ([_backContentView subviews] != 0) {
        for (UIView *vi in [_backContentView subviews]) {
            [vi removeFromSuperview];
        }
        [self.view sendSubviewToBack:_backContentView];
    }
    _backContentView.hidden=YES;
}

- (void)notHaveSilverClearList {
    self.tableView.bounces = NO;
    [VCAppearManager arrengmentNotDataViewWithSuperView:_backContentView title:@"土豪，暂无记录哦!"];
    [self.view bringSubviewToFront:_backContentView];
}

- (void)UIDecorate
{
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"我的银子";
    self.title = @"我的银子";
    [self.view addSubview:_customNav];
    __weak typeof(self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _headView = [[UIView alloc] init];
    _headView.backgroundColor = [UIColor backgroundGrayColor];
    _headView.userInteractionEnabled = YES;
    [self.view addSubview:_headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNav.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@110);
    }];
    
    _topView = [[UIView alloc] init];
    [_headView addSubview:_topView];
    _topView.backgroundColor = [UIColor whiteColor];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView.mas_top);
        make.left.equalTo(_headView.mas_left);
        make.right.equalTo(_headView.mas_right);
        make.height.equalTo(@50);
    }];
    
    _label = [[UILabel alloc] init];
    [_topView addSubview:_label];
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_topView.mas_centerY);
        make.left.equalTo(_topView.mas_left).offset(15);
        make.height.equalTo(@40);
    }];
    
    RoundCornerClickBT *changeGoods = [RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [_topView addSubview:changeGoods];
    [changeGoods setTitle:@" 兑换商品 " forState:UIControlStateNormal];
    changeGoods.backgroundColor = [UIColor iconBlueColor];
    changeGoods.titleLabel.font = [UIFont systemFontOfSize:14];
    [changeGoods addTarget:self action:@selector(clickChangeGoodsBT:) forControlEvents:UIControlEventTouchUpInside];
    [changeGoods mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_topView.mas_centerY);
        make.right.equalTo(_topView.mas_right).offset(-15);
        make.height.equalTo(@30);
        make.width.equalTo(@80);
    }];
    UILabel *detailLB = [[UILabel alloc] init];
    [_headView addSubview:detailLB];
    detailLB.text = @"银子明细";
    detailLB.textColor = [UIColor characterBlackColor];
    detailLB.font = [UIFont systemFontOfSize:15];
    [detailLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_headView.mas_bottom).offset(-10);
        make.left.equalTo(_headView.mas_left).offset(15);
        make.height.equalTo(@20);
    }];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor backgroundGrayColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView.mas_bottom).offset(.2);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    _backContentView = [[UIView alloc] init];
    [self.tableView addSubview:_backContentView];
    _backContentView.backgroundColor = [UIColor clearColor];
    [_backContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self.dataSource removeAllObjects];
        [self achieveSilverDetailDataWith:user.customerId];
    }];
    
    weakSelf.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [self achieveSilverDetailDataWith:user.customerId];
    }];
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

