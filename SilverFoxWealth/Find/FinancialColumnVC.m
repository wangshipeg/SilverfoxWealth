//
//  FinancialColumnVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/1/3.
//  Copyright © 2017年 apple. All rights reserved.
//



#import "FinancialColumnVC.h"
#import <MJRefresh.h>
#import "DataRequest.h"
#import "FinancialColumnCell.h"
#import "FinancialColumnModel.h"
#import "FinanclalColumnWebViewVC.h"
#import "TableViewAnimationKitHeaders.h"

@interface FinancialColumnVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) CustomerNavgationController *customNav;
@end

@implementation FinancialColumnVC
{
    int page;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    [self dataInitialize];
    [self achieveProductListData];
    // Do any additional setup after loading the view.
}

- (void)achieveProductListData
{
    [[DataRequest sharedClient] finaacialColumnListWithPage:page callback:^(id obj) {
        DLog(@"obj======%@",obj);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *array = obj;
            [self.dataSource addObjectsFromArray:array];
            self.tableView.mj_footer.hidden = NO;
            [self.tableView reloadData];
        } else if(obj == nil && page == 1) {
            self.tableView.mj_footer.hidden = YES;
        } else if(obj == nil && page > 1) {
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
        [self.tableView reloadData];
        if (obj != nil && page == 1) {
            [self starAnimationWithTableView:self.tableView];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FinancialColumnCell *cell;
    static NSString *identifier=@"FinancialColumnIdentifier";
    cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[FinancialColumnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (self.dataSource.count == 0) {
        return cell;
    }
    FinancialColumnModel *model=[self.dataSource objectAtIndex:indexPath.section];
    if (!model) {
        return nil;
    }
    [cell showFinancialColumnList:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FinanclalColumnWebViewVC *detailPageVC = [[FinanclalColumnWebViewVC alloc] init];
    FinancialColumnModel *model = self.dataSource[indexPath.section];
    detailPageVC.model = model;
    [self.navigationController pushViewController:detailPageVC animated:YES];
}

- (void)starAnimationWithTableView:(UITableView *)tableView {
    [TableViewAnimationKit showWithAnimationType:6 tableView:tableView];
}

- (void)dataInitialize
{
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    } else {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"理财专栏";
    self.title = @"理财专栏";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    weakSelf.customNav.leftViewController = ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    self.dataSource = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNav.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf.dataSource removeAllObjects];
        [weakSelf achieveProductListData];
    }];
    
    weakSelf.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [weakSelf achieveProductListData];
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


