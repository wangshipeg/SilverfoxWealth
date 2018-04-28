//
//  HistoryIncomeRecordVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/6/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HistoryIncomeRecordVC.h"
#import <MJRefresh.h>
#import "DataRequest.h"
#import "IndividualInfoManage.h"
#import "StringHelper.h"
#import "VCAppearManager.h"
#import "SilverClearCell.h"
#import "ExchangeRecordModel.h"

@interface HistoryIncomeRecordVC ()<UITableViewDelegate,UITableViewDataSource>
{
    int page;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIView *backContentView;
@property (nonatomic, strong) NSString *silverNum;
@property (nonatomic, strong) UILabel *label;

@end

@implementation HistoryIncomeRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
    [self addIncomeRecordObserve];
    // Do any additional setup after loading the view.
}
- (void)addIncomeRecordObserve {
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(addMessageNoteWith) name:@"HistoryAllExchangeLoadOver" object:nil];
}
- (void)addMessageNoteWith
{
    [self.dataSource removeAllObjects];
    page = 1;
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [self achieveExchangeRecordDataWith:user.customerId];
}

- (void)achieveExchangeRecordDataWith:(NSString *)customerId {
    [[DataRequest sharedClient]requestExchageDetailWithCustomerId:customerId type:1 page:page history:1 mobile:1 startDate:nil endDate:nil callback:^(id obj) {
        [self.tableView.mj_header  endRefreshing];
        [self.tableView.mj_footer  endRefreshing];
        [self sendMessageToPayRecordDataRequest];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        //正常获取数据
        if ([obj isKindOfClass:[NSArray class]]) {
            if (!self.dataSource)
            {
                self.dataSource = [NSMutableArray array];
            }
            NSArray *array = obj;
            [self clearBackContentViewSubView];
            [self.dataSource addObjectsFromArray:array];
            self.tableView.mj_footer.hidden = NO;
            [self.tableView reloadData];
        }else if(obj == nil && page == 1){
            [self notHaveSilverClearList];
            self.tableView.mj_footer.hidden = YES;
        }else if(obj == nil && page > 1){
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }
    }];
}
- (void)sendMessageToPayRecordDataRequest{
    NSNotificationCenter *messageCenter=[NSNotificationCenter  defaultCenter];
    [messageCenter postNotificationName:@"HistoryPayLoadOver" object:Nil userInfo:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *silverIdentifier=@"HistoryIncomeRecord";
    SilverClearCell *cell = [tableView dequeueReusableCellWithIdentifier:silverIdentifier];
    if (!cell) {
        cell=[[SilverClearCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:silverIdentifier];
    }
    if (self.dataSource.count == 0) {
        return cell;
    }
    [cell showExchangeRecordWith:[self.dataSource objectAtIndex:indexPath.row]];
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

//没有银子明细数据 显示
- (void)notHaveSilverClearList {
    self.tableView.bounces = NO;
    [VCAppearManager arrengmentNotDataViewWithSuperView:_backContentView title:@"土豪，没有收入记录哦!"];
    [self.view bringSubviewToFront:_backContentView];
}

- (void)UIDecorate
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor typefaceGrayColor];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor backgroundGrayColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-114);
    }];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    _backContentView = [[UIView alloc] init];
    [self.tableView addSubview:_backContentView];
    _backContentView.backgroundColor = [UIColor clearColor];
    [_backContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(-200);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    __weak typeof(self) weakSelf = self;
    weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self.dataSource removeAllObjects];
        [self achieveExchangeRecordDataWith:user.customerId];
    }];
    
    weakSelf.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [self achieveExchangeRecordDataWith:user.customerId];
    }];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
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
