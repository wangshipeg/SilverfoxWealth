//
//  ChangerRecordVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ChangerRecordVC.h"
#import "ChangerRecordCell.h"
#import "DataRequest.h"
#import "ExchangerRecordModel.h"
#import <MJRefresh.h>
#import "SCMeasureDump.h"
#import "SVProgressHUD.h"
#import "VCAppearManager.h"
#import "SilverTraderVC.h"

@interface ChangerRecordVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *backContentView;

@end

@implementation ChangerRecordVC

{
    int page;//当前页数
    BOOL isHaveFooter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isHaveFooter = YES;
    
    self.dataSource = [NSMutableArray array];
    [self UIDecorate];
    
    [self.tableView.mj_header beginRefreshing];
}

-(void)achieveAssetDataWith:(NSString *)customerId {
    [[DataRequest sharedClient] silverTraderExchangerRecordcustomerId:customerId page:page callback:^(id obj) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        DLog(@"银子商城兑换记录加载结果======%@",obj);
        if (obj == nil && page != 1) {
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }else if (obj == nil && page == 1){
            [self notHaveBeingProduct];
        }else if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *array = obj;
            [self clearBackContentViewSubView];
            [self loadSilverDetailDataWith:array];
        }
    }];
}

- (void)loadSilverDetailDataWith:(NSArray *)dic {
    [self.dataSource addObjectsFromArray:dic];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier=@"exchange";
    ChangerRecordCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[ChangerRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    ExchangerRecordModel *model = [self.dataSource objectAtIndex:indexPath.row];
    if (!model) {
        return nil;
    }
    
    [cell showExchangerRecordDataWithDic:model];
    
    UIView *view_bg = [[UIView alloc]initWithFrame:cell.frame];
    view_bg.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = view_bg;
    
    [cell copyNumberBlock:^{
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        [pab setString:cell.changerNum.text];
        if (pab == nil) {
            [SVProgressHUD showErrorWithStatus:@"复制失败"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"复制成功"];
        }
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//没有数据 显示
- (void)notHaveBeingProduct
{
    [VCAppearManager arrengmentNotDataViewWithSuperView:_backContentView title:@"暂无兑换记录!"];
    [self.view bringSubviewToFront:_backContentView];
}

//清除 无数据背景视图上的视图 如果有的话
- (void)clearBackContentViewSubView {
    if ([_backContentView subviews] != 0) {
        for (UIView *vi in [_backContentView subviews]) {
            [vi removeFromSuperview];
        }
        [self.view sendSubviewToBack:_backContentView];
    }
    _backContentView.hidden=YES;
}

- (void)UIDecorate
{
    CustomerNavgationController *customNav = [[CustomerNavgationController alloc] init];
    if (IS_iPhoneX) {
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height);
    }else{
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    }
    customNav.titleLabel.text = @"兑换记录";
    self.title = @"兑换记录";
    [self.view addSubview:customNav];
    __weak typeof (self) weakSelf = self;
    customNav.leftViewController = ^{
        UIViewController *target = nil;
        for (UIViewController * controller in weakSelf.navigationController.viewControllers) { //遍历
            if ([controller isKindOfClass:[SilverTraderVC class]]) { //这里判断是否为你想要跳转的页面
                target = controller;
            }
        }
        if (target) {
            [weakSelf.navigationController popToViewController:target animated:YES]; //跳转
        }
    };
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor=[UIColor backgroundGrayColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(customNav.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf.dataSource removeAllObjects];
        IndividualInfoManage *user=[IndividualInfoManage currentAccount];
        [weakSelf achieveAssetDataWith:user.customerId];
    }];
    weakSelf.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        IndividualInfoManage *user=[IndividualInfoManage currentAccount];
        [weakSelf achieveAssetDataWith:user.customerId];
    }];
    
    _backContentView = [[UIView alloc] init];
    [self.view addSubview:_backContentView];
    _backContentView.backgroundColor=[UIColor clearColor];
    [_backContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(customNav.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end



