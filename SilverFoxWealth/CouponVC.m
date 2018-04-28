//
//  CouponVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/9/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CouponVC.h"
#import "MyBonusCell.h" //活动红包cell
#import "MyBonusOneCell.h" //累加红包cell
#import "DataRequest.h"
#import "IndividualInfoManage.h"
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
#import <MJRefresh.h>

@interface CouponVC ()
{
    int page; //
}
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (strong, nonatomic) UITableView    *tableView;
@property (strong, nonatomic) UIView         *backContentView;
@property (nonatomic, strong) NSString       *totalTradeMoney;//交易总金额 从投资客信息中获取
@property (nonatomic, strong) NSMutableArray *CanUseSource;
@property (nonatomic, strong) NSMutableArray *NotUseSource;
@property (nonatomic, strong) NSMutableArray *useSource;

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) RebateModel *model;
@property (nonatomic, strong) RebateModel *rebateModel;

@end

@implementation CouponVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.CanUseSource = [NSMutableArray array];
    self.NotUseSource = [NSMutableArray array];
    self.useSource = [NSMutableArray array];
    self.dataArr = [NSMutableArray array];
    page = 1;
    [self UIDecorate];
    [self animation];
    [self addNewMessageObserve];
}

- (void)addNewMessageObserve {
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(addMessageNoteWith) name:@"loadOver" object:nil];
}

- (void)addMessageNoteWith
{
    __weak typeof(self) weakSelf = self;
    weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf.dataSource removeAllObjects];
        [weakSelf achieveRebateList];
    }];
    
    weakSelf.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [weakSelf achieveRebateList];
    }];
    self.tableView.allowsSelection=NO;
    [self.tableView.mj_header beginRefreshing];
    
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(viewWillAppearSendMessage) name:@"viewWilAppear" object:nil];
}

- (void)viewWillAppearSendMessage
{
    [self.dataSource removeAllObjects];
    page = 1;
    [self achieveRebateList];
}

- (void)animation
{
    [SVProgressHUD showWithStatus:PleaseWaitALittleWhile];
}

- (void)achieveRebateList {
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    if (!user) {
        return;
    }
    [[DataRequest sharedClient] obtainUserRebateWithcustomerId:user.customerId page:page used:1 size:15 callback:^(id obj) {
        DLog(@"已失效红包加载结果====%@",obj);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        if (!obj) {
            [self showNoBonusView];
            return;
        }
        //正常获取数据
        if (obj == nil && page != 1) {
            [self clearBackContentViewSubView];
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }else if (obj == nil && page == 1){
            [self showNoBonusView];
        }else if ([obj isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:obj];
            if (array.count == 0 && page == 1) {
                [self showNoBonusView];
            }else if (array.count == 0 && page != 1){
                [self clearBackContentViewSubView];
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }else{
                [self clearBackContentViewSubView];
                [self loadMyCouponDataWith:array];
            }
        }
    }];
}

- (void)loadMyCouponDataWith:(NSMutableArray *)dic {
    if (!self.dataSource) {
        self.dataSource=[NSMutableArray array];
    }
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
    static NSString *commonCell=@"couponCell";
    MyBonusCell *cell = [tableView dequeueReusableCellWithIdentifier:commonCell];
    if (!cell) {
        cell=[[MyBonusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commonCell];
    }
    if (self.dataSource.count == 0) {
        return cell;
    }
    RebateModel *model=[self.dataSource objectAtIndex:indexPath.section];
    if (!model) {
        return nil;
    }
    [cell showCanNotUseRebateDetailWith:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//展示无收益中的产品无数据图
- (void)showNoBonusView {
    [self clearBackContentViewSubView];
    if (self.dataSource.count == 0 ) {
        [self notBuyProductWithTitle:@"土豪,您当前没有已失效的优惠券!"];
    }
}

//没有购买产品 显示
- (void)notBuyProductWithTitle:(NSString *)title {
    [VCAppearManager arrengmentNotDataViewWithSuperView:_backContentView title:title];
    [self.view bringSubviewToFront:_backContentView];
}

//清除 无数据背景视图 如果有的话
- (void)clearBackContentViewSubView {
    if ([_backContentView subviews] != 0) {
        for (UIView *vi in [_backContentView subviews]) {
            [vi removeFromSuperview];
        }
        [self.view sendSubviewToBack:_backContentView];
    }
    _backContentView.hidden=YES;
}

- (void)UIDecorate {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if ([self.pushStutas isEqualToString:@"PUSHS"]) {
        _tableView=[[UITableView alloc] init];
        [self.view addSubview:_tableView];
        self.tableView.dataSource=self;
        self.tableView.delegate=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom).offset(-165);
        }];
        
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.backgroundColor = [UIColor backgroundGrayColor];
    }else
    {
        _tableView=[[UITableView alloc] init];
        [self.view addSubview:_tableView];
        self.tableView.dataSource=self;
        self.tableView.delegate=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom).offset(-165);
        }];
        
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.backgroundColor = [UIColor backgroundGrayColor];
    }
    
    
    _backContentView=[[UIView alloc] init];
    [self.view addSubview:_backContentView];
    _backContentView.backgroundColor=[UIColor clearColor];
    [_backContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-165);
    }];
}

-(void)dealloc{
    //移除观察者
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
