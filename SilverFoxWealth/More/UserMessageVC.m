//
//  UserMessageVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/9/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UserMessageVC.h"
#import "MyMessageCell.h"
#import "DataRequest.h"
#import "CommunalInfo.h"
#import <SVProgressHUD.h>
#import "PromptLanguage.h"
#import "VCAppearManager.h"
#import "BlackBorderBT.h"
#import <MJRefresh.h>
#import "SystemMessageDetailVC.h"
#import "SCMeasureDump.h"
#import "UMMobClick/MobClick.h"

@interface UserMessageVC ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UIView         *backContentView;
@property (nonatomic, strong) NSMutableArray *dataSource;//我的消息数据源
@property (strong, nonatomic) UITableView    *tableView;
@property (nonatomic, strong) UIViewController *contentViewController;
@property (nonatomic, strong) CustomerNavgationController *customNav;
@end

@implementation UserMessageVC
{
    int page;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [SCMeasureDump shareSCMeasureDump].isRead = NO;
    page = 1;
    [self UIDecorate];
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [self loadUserMessageList:user.customerId];
}

- (void)handleClickRightItem
{
    [MobClick event:@"set_all_msg_readed"];
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [[DataRequest sharedClient]obtainReadAllUserHistoryMessageWithcustomerId:user.customerId callback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] intValue] == 2000) {
                [self.dataSource removeAllObjects];
                [self loadUserMessageList:user.customerId];
            }
        }
        if ([obj isKindOfClass:[NSError class]]) {
            
        }
    }];
}

//载入用户  我的消息
- (void)loadUserMessageList:(NSString *)customerId{
    [[DataRequest sharedClient] obtainUserHistoryMessageWithcustomerId:customerId page:page callback:^(id obj) {
        DLog(@"我的消息返回结果=====%@",obj);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (!obj) {
            [self notMessageWithTitle:@"土豪，您没有消息哦!"];
            return ;
        }
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *array=obj;
            if (array.count==0) {
                [self notMessageWithTitle:@"土豪，您没有消息哦!"];
                return ;
            }
            if (!self.dataSource) {
                self.dataSource=[NSMutableArray array];
            }
            [self clearBackContentViewSubView];
            [self.dataSource addObjectsFromArray:array];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentifier=@"userMessageIndentifier";
    MyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell=[[MyMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    if (self.dataSource.count == 0) {
        return cell;
    }
    [cell showMessageWith:[self.dataSource objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserInfoModel *model=[self.dataSource objectAtIndex:indexPath.row];
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    [[DataRequest sharedClient]readUserMessageWithcustomerId:user.customerId messageId:model.idStr callback:^(id obj) {
        DLog(@"我的消息已读=======%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] intValue] == 2000) {
                [SCMeasureDump shareSCMeasureDump].isRead = YES;
                model.status = @"1";
                [self.tableView reloadData];
            }
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //根据消息内容, 自适应高度
    MyMessageCell *cell = (MyMessageCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell achieveContentHeight];
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


//没有消息数据 显示
- (void)notMessageWithTitle:(NSString *)title {
    [VCAppearManager arrengmentNotDataViewWithSuperView:_backContentView title:title];
    [self.view bringSubviewToFront:_backContentView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
//    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
//}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)UIDecorate {
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"我的消息";
    self.title = @"我的消息";
    [_customNav.rightButton setTitle:@"全设已读" forState:UIControlStateNormal];
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    _customNav.rightButtonHandle = ^{
        [weakSelf handleClickRightItem];
    };
    
    self.tableView=[[UITableView alloc] init];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNav.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    _backContentView=[[UIView alloc] init];
    [self.view addSubview:_backContentView];
    _backContentView.backgroundColor=[UIColor clearColor];
    [_backContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        if (page == [[SCMeasureDump shareSCMeasureDump].myMessagePages intValue]) {
            self.tableView.mj_footer.hidden = YES;
        }else{
            self.tableView.mj_footer.hidden = NO;
        }
        [weakSelf.dataSource removeAllObjects];
        IndividualInfoManage *user = [IndividualInfoManage currentAccount];
        [self loadUserMessageList:user.customerId];
    }];
    
    weakSelf.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        if (page > [[SCMeasureDump shareSCMeasureDump].myMessagePages intValue]) {
            page = [[SCMeasureDump shareSCMeasureDump].myMessagePages intValue] - 1;
            self.tableView.mj_footer.hidden = YES;
            return;
        }
        IndividualInfoManage *user = [IndividualInfoManage currentAccount];
        [self loadUserMessageList:user.customerId];
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


@end

