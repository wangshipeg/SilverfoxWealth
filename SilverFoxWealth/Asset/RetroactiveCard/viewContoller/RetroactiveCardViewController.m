//
//  RetroactiveCardViewController.m
//  SilverFoxWealth
//
//  Created by 丿Love_wcx丶灬丨 紫軒 on 2018/4/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RetroactiveCardViewController.h"
#import "RetroactiveCardCell.h"
#import "RetroactiveCardModel.h"
#import "DataRequest.h"
#import "IndividualInfoManage.h"
#import <MJRefresh.h>
#import <SVProgressHUD.h>

static NSString *retroactiveCardCell = @"RetroactiveCardCell";

@interface RetroactiveCardViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) CustomerNavgationController *customNav;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray <RetroactiveCardModel *>*dataSource;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation RetroactiveCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavView];
    [self creatView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [self achieveRetroactiveCardListDataWith:user.customerId];
}

- (void)achieveRetroactiveCardListDataWith:(NSString *)customerId {
    [[DataRequest sharedClient] requestRetroactiveCardListWithCusstomerId:customerId Callback:^(id obj) {
        DLog(@"%@",obj);
        [self.myTableView.mj_header endRefreshing];
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *array = obj;
            [self.dataSource addObjectsFromArray:array];
            self.myTableView.tableHeaderView = [self tableViewHeaderView];
            [self.myTableView reloadData];
        }
    }];
}

- (void)creatView {
    [self.view addSubview:self.myTableView];
    self.myTableView.tableHeaderView = [self tableViewHeaderView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(IS_iPhoneX ? iPhoneX_Navigition_Bar_Height : 64, 0, 0, 0));
    }];
    [self.myTableView registerClass:[RetroactiveCardCell class] forCellReuseIdentifier:retroactiveCardCell];
}

- (UIView *)tableViewHeaderView {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:17];
    label.text = @"补签卡可对当月漏签的日期进行不签";
    label.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:label];
    
    NSString *str = [NSString stringWithFormat:@"您有%ld张有效补签卡",self.dataSource.count];
    self.countLabel.attributedText = [self setStringColorWithStr:str];
    [self.bgView addSubview:self.countLabel];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).with.offset(0);
        make.left.equalTo(self.bgView.mas_left).with.offset(0);
        make.right.equalTo(self.bgView.mas_right).with.offset(0);
        make.height.mas_equalTo(75);
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).with.offset(0);
        make.left.equalTo(self.bgView.mas_left).with.offset(0);
        make.right.equalTo(self.bgView.mas_right).with.offset(0);
        make.height.mas_equalTo(75);
    }];
    return self.bgView;
}

- (void)setUpNavView {
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"我的补签卡";
    self.title = @"我的补签卡";
    [self.view addSubview:_customNav];
    __weak typeof(self) weakSelf = self;
    self.customNav.leftViewController = ^(){
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    weakSelf.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.dataSource removeAllObjects];
        IndividualInfoManage *user = [IndividualInfoManage currentAccount];
        [weakSelf achieveRetroactiveCardListDataWith:user.customerId];
    }];
}

#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataSource.count;
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RetroactiveCardCell *cell = [tableView dequeueReusableCellWithIdentifier:retroactiveCardCell forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[RetroactiveCardCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:retroactiveCardCell];
    }
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark ——— getter

- (UITableView *)myTableView {
    if(!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.rowHeight = 200;
        _myTableView.tableFooterView = [[UIView alloc] init];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _myTableView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150)];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont systemFontOfSize:14];
        _countLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _countLabel;
}

/** 设置颜色
 * @brief 修改指定数字颜色
 */
- (NSMutableAttributedString *)setStringColorWithStr:(NSString *)str {
    NSArray *numbers =@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str];
    for (int i = 0; i < str.length; i ++) {
        NSString *a = [str substringWithRange:NSMakeRange(i, 1)];
        if ([numbers containsObject:a]) {
            [attributeString setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor], NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(i, 1)];
        }
    }
    return attributeString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
