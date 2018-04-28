

#import "BonusVC.h"
#import "MyBonusCell.h" //活动红包cell
#import "MyBonusOneCell.h" //累加红包cell
#import "DataRequest.h"
#import "HTMLVC.h"  //红包使用说明
#import "NotDataView.h"
#import "CommunalInfo.h"
#import "WithoutAuthorization.h"
#import "VCAppearManager.h"
#import <SVProgressHUD.h>
#import "PromptLanguage.h"
#import "BlackBorderBT.h"
#import "TopBottomBalckBorderView.h"
#import "SCMeasureDump.h"
#import "EstimateRebateUsefulness.h"
#import "BlackBorderBT.h"
#import "MyBonusVC.h"
#import "CouponGiveToOneVCViewController.h"
#import "CustomerSeparateTableViewCell.h"

@interface BonusVC ()
{
    int page; //
}
@property (nonatomic, strong) CustomerNavgationController *customNav;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *couponDataSource;
@property (strong, nonatomic) UITableView    *tableView;
@property (strong, nonatomic) UIView         *backContentView;
@property (nonatomic, strong) NSString       *totalTradeMoney;//交易总金额 从投资客信息中获取
@property (nonatomic, strong) NSMutableArray *CanUseSource;
@property (nonatomic, strong) NSMutableArray *NotUseSource;
@property (nonatomic, strong) NSMutableArray *useSource;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) RebateModel *model;
@property (nonatomic, strong) RebateModel *rebateModel;

@end

@implementation BonusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.CanUseSource = [NSMutableArray array];
    self.NotUseSource = [NSMutableArray array];
    self.useSource = [NSMutableArray array];
    self.dataArr = [NSMutableArray array];
    page = 1;
    [self UIDecorate];
    [self animation];
    //如果是从我的资产页面传进来的直接加载红包列表就可以了
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(addMessageNoteWith) name:@"viewWilAppear" object:nil];
}

- (void)animation
{
    [SVProgressHUD showWithStatus:PleaseWaitALittleWhile];
}

- (void)addMessageNoteWith
{
    [self achieveCustomerInfo];
}

- (void)achieveCustomerInfo {
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] AchieveCustomerUserInfoFundTradeAmountWithcustomerId:user.customerId callback:^(id obj) {
        DLog(@"获取投资客累计投资金额====%@",obj);
        //投资客 结果
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic=obj;
            _totalTradeMoney = dic[@"commonTradeAmount"];
            [self achieveRebateList];
        }
    }];
}

- (void)achieveRebateList {
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    if (!user) {
        return;
    }
    [[DataRequest sharedClient] obtainUserRebateWithcustomerId:user.customerId page:page used:0 size:15 callback:^(id obj) {
        //红包列表加载完成 把消息发送出去
        [self sendMessageToCouponsListDataRequest];
        [SVProgressHUD dismiss];
        
        if (!obj) {
            [self showNoBonusView];
            return;
        }
        if ([obj isKindOfClass:[NSArray class]]) {
            NSMutableArray *array=obj;
            if (array.count==0) {
                [self showNoBonusView];
                return;
            }
            [self clearBackContentViewSubView];
            [self loadMyCouponDataWith:array];
        }
    }];
}

- (void)sendMessageToCouponsListDataRequest{
    NSNotificationCenter *messageCenter=[NSNotificationCenter  defaultCenter];
    [messageCenter postNotificationName:@"loadOver" object:Nil userInfo:nil];
}


- (void)loadMyCouponDataWith:(NSMutableArray *)dic {
    if (!self.dataSource) {
        self.dataSource=[NSMutableArray array];
    }
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:dic];
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _model=[self.dataSource objectAtIndex:indexPath.section];
    //如果是累加红包
    if ([_model.cumulative integerValue] == 1) {
        MyBonusOneCell *cell = [[MyBonusOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"one"];
        [cell showCumulativeRebate:_model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        static NSString *commonCell=@"commonCell";
        MyBonusCell *cell = [tableView dequeueReusableCellWithIdentifier:commonCell];
        if (!cell) {
            cell = [[MyBonusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commonCell];
        }
        [cell showRebateDetailWith:_model currentTotalTradeMoney:_totalTradeMoney];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [MobClick event:@"my_coupon_give_click"];
    RebateModel *model=[self.dataSource objectAtIndex:indexPath.section];
    CouponGiveToOneVCViewController *giveToOneVC = [[CouponGiveToOneVCViewController alloc] init];
    giveToOneVC.couponID = model.couponId;
    UITabBarController *control = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *VC=(UINavigationController *)control.selectedViewController;
    UIViewController *productVC=[VC topViewController];
    [productVC.navigationController pushViewController:giveToOneVC animated:YES];
}

- (void)showNoBonusView
{
    [self clearBackContentViewSubView];
    if (self.dataSource.count == 0 )
    {
        [self notBuyProductWithTitle:@"土豪,您当前没有可使用的优惠券!"];
    }
}

- (void)notBuyProductWithTitle:(NSString *)title
{
    [VCAppearManager arrengmentNotDataViewWithSuperView:_backContentView title:title];
    [self.view bringSubviewToFront:_backContentView];
}

//清除 无数据背景视图 如果有的话
- (void)clearBackContentViewSubView
{
    if ([_backContentView subviews] != 0)
    {
        for (UIView *vi in [_backContentView subviews])
        {
            [vi removeFromSuperview];
        }
        [self.view sendSubviewToBack:_backContentView];
    }
    _backContentView.hidden=YES;
}

- (void)UIDecorate
{
    self.view.backgroundColor = [UIColor backgroundGrayColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    _tableView=[[UITableView alloc] init];
    [self.view addSubview:_tableView];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-164);
    }];
    self.tableView.backgroundColor = [UIColor backgroundGrayColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    _backContentView=[[UIView alloc] init];
    [self.view addSubview:_backContentView];
    _backContentView.backgroundColor=[UIColor clearColor];
    [_backContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-164);
    }];
    
}

#pragma -mark UITableViewStyle

//-(void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//
//    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
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
- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
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

