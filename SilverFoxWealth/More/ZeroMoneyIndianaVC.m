

#import "ZeroMoneyIndianaVC.h"
#import "ZeroMoneyIndianaViewCell.h"
#import "BlackBorderBT.h"
#import "VCAppearManager.h"
#import "MyIndianaVC.h"
#import "DataRequest.h"
#import "UserInfoUpdate.h"
#import "ZeroIndianaModel.h"
#import "StringHelper.h"
#import "ZeroIndianaDetailVC.h"
#import "MJRefresh.h"
#import "SCMeasureDump.h"

@interface ZeroMoneyIndianaVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourse;
@property (nonatomic, strong) UIView *backContentView;

@end

@implementation ZeroMoneyIndianaVC
{
    int page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViewController];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView.mj_header beginRefreshing];
}

- (void)dataRequestWithZeroIndiana
{
    [[DataRequest sharedClient] zeroMoneyFirstPage:page callback:^(id obj) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        DLog(@"0元夺宝======%@,%d",obj,page);
        
        if ([obj isKindOfClass:[NSArray class]]) {
            [self loadMyCouponDataWith:obj];
            [self clearBackContentViewSubView];
        }else if (obj == nil && page != 1) {
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            [self clearBackContentViewSubView];
        }else if (obj == nil && page == 1){
            [self notHaveSilverClearList];
        }
        
        if ([obj isKindOfClass:[NSError class]]) {
            [self notHaveSilverClearList];
        }
    }];
}

- (void)clearBackContentViewSubView {
    if ([_backContentView subviews] != 0) {
        for (UIView *vi in [_backContentView subviews]) {
            [vi removeFromSuperview];
        }
        [self.view sendSubviewToBack:_backContentView];
    }
}

- (void)notHaveSilverClearList {
    self.tableView.bounces = NO;
    [VCAppearManager arrengmentNotDataViewWithSuperView:_backContentView title:@"暂无夺宝活动!"];
    [self.view bringSubviewToFront:_backContentView];
}

- (void)loadMyCouponDataWith:(NSMutableArray *)array
{
    if (!self.dataSourse) {
        self.dataSourse = [NSMutableArray array];
    }
    [self.dataSourse addObjectsFromArray:array];
    [self.tableView reloadData];
}

- (void)setUpViewController{
    CustomerNavgationController *customNav = [[CustomerNavgationController alloc] init];
    if (IS_iPhoneX) {
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height);
    }else{
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    }
    customNav.titleLabel.text = @"0元夺宝";
    self.title = @"0元夺宝";
    [self.view addSubview:customNav];
    __weak typeof (self) weakSelf = self;
    customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor backgroundGrayColor];
    self.tableView.tableFooterView = [[UIView  alloc] init];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(customNav.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self.dataSourse removeAllObjects];
        [weakSelf dataRequestWithZeroIndiana];
    }];
    
    weakSelf.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [weakSelf dataRequestWithZeroIndiana];
    }];
    
    _backContentView = [[UIView alloc] init];
    [self.view addSubview:_backContentView];
    _backContentView.backgroundColor = [UIColor clearColor];
    [_backContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(customNav.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
    }];
    
    BlackBorderBT *button = [BlackBorderBT buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 49);
    [button setTitle:@"我的夺宝" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button setTitleColor:[UIColor zheJiangBusinessRedColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(MyIndiana:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)MyIndiana:(BlackBorderBT *)sender
{
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    if (user) {
        MyIndianaVC *myIndianaVC = [[MyIndianaVC alloc] init];
        [self.navigationController pushViewController:myIndianaVC animated:YES];
    }else{
        [VCAppearManager presentLoginVCWithCurrentVC:self];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSourse.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSourse.count == 0) {
        return 0;
    }
    ZeroIndianaModel *model = [self.dataSourse objectAtIndex:indexPath.section];
    if ([model.stock intValue] - [model.joinNum intValue] > 0) {
        return [UIScreen mainScreen].bounds.size.width * 210 / 375;
    }else{
        return [UIScreen mainScreen].bounds.size.width * 185 / 375;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    ZeroMoneyIndianaViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ZeroMoneyIndianaViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (self.dataSourse.count == 0) {
        return cell;
    }
    ZeroIndianaModel *model=[self.dataSourse objectAtIndex:indexPath.section];
    
    [cell showIndinanPageWith:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MobClick event:@"zero_snatch_detail"];
    ZeroIndianaDetailVC *detailPageVC = [[ZeroIndianaDetailVC alloc] init];
    if (self.dataSourse.count == 0) {
        return;
    }
    ZeroIndianaModel *model = self.dataSourse[indexPath.section];
    detailPageVC.titleStr = model.goodsName;
    detailPageVC.stockStr = model.stock;
    detailPageVC.joinNumStr = model.joinNum;
    detailPageVC.idStr = model.idStr;
    detailPageVC.consumeSilver = model.consumeSilver;
    [self.navigationController pushViewController:detailPageVC animated:YES];
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

