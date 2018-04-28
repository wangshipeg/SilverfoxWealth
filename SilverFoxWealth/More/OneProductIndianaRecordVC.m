//
//  OneProductIndianaRecordVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OneProductIndianaRecordVC.h"
#import "DataRequest.h"
#import "MJRefresh.h"
#import "IndianaRecordsModel.h"
#import "SilverClearCell.h"

@interface OneProductIndianaRecordVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CustomerNavgationController *customNav;

@end

@implementation OneProductIndianaRecordVC
{
    int page;
    BOOL isHaveFooter;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _customNav = [[CustomerNavgationController alloc] init];
    if (IS_iPhoneX) {
        _customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height);
    }else{
        _customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    }
    _customNav.titleLabel.text = @"我的夺宝";
    self.title = @"我的夺宝";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.view.backgroundColor = [UIColor backgroundGrayColor];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    _dataSource = [NSMutableArray array];
    isHaveFooter = YES;
    [self UIDecorate];
    // Do any additional setup after loading the view.
}

//夺宝记录MyIndianaRecordWithDetailPageAccount
- (void)achievePecommendData:(NSString *)cellphone
{
    [[DataRequest sharedClient] MyIndianaRecordWithDetailPageCellphone:cellphone goodsId:_idStr page:page callback:^(id obj) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        DLog(@"我的夺宝详情页 夺宝记录===%@",obj);
        
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *array = [NSArray arrayWithObject:obj];
            if (array.count > 0 && array.count < 15 && page == 1) {
                self.tableView.mj_footer.hidden = YES;
            }
            [self loadMyCouponDataWith:obj];
        }else if(obj == nil && page != 1){
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            DLog(@"我的夺宝详情页夺宝记录加载结果错误");
        }
    }];
}

- (void)loadMyCouponDataWith:(NSMutableArray *)array
{
    [self.dataSource addObjectsFromArray:array];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IndianaRecordsModel *model=[self.dataSource objectAtIndex:indexPath.row];
    if (!model) {
        return nil;
    }
    static NSString *silverIdentifier=@"myIndiana";
    SilverClearCell *cell = [tableView dequeueReusableCellWithIdentifier:silverIdentifier];
    if (!cell) {
        cell=[[SilverClearCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:silverIdentifier];
    }
    [cell showMyIndianaWithDic:model];
    return cell;
}

- (void)UIDecorate
{
    self.tableView=[[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNav.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator=NO;
    
    __weak typeof(self) weakSelf = self;
    weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf.dataSource removeAllObjects];
        IndividualInfoManage *user=[IndividualInfoManage currentAccount];
        [weakSelf achievePecommendData:user.cellphone];
    }];
    weakSelf.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        IndividualInfoManage *user=[IndividualInfoManage currentAccount];
        [weakSelf achievePecommendData:user.cellphone];
    }];
    
    [self.tableView.mj_header beginRefreshing];
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

