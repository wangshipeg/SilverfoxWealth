//
//  BeingViewController.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/9/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BeingViewController.h"
#import "ZeroMoneyIndianaViewCell.h"
#import "ZeroIndianaModel.h"
#import "StringHelper.h"
#import "UIImageView+WebCache.h"
#import "IndividualInfoManage.h"
#import "DataRequest.h"
#import "VCAppearManager.h"
#import "WithoutAuthorization.h"
#import "ZeroIndianaModel.h"
#import "MJRefresh.h"
#import "MyIndianaDetailVC.h"
#import "ZeroIndianaDetailVC.h"
#import "SCMeasureDump.h"
#import "CalculateProductInfo.h"

@interface BeingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourse;
@property (strong, nonatomic) UIView         *backContentView;

@end

@implementation BeingViewController
{
    int page;//分页
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSourse = [NSMutableArray array];
    [self UIDecorate];
    page = 1;
    [self dataRequestWithZeroMoney];
}

- (void)dataRequestWithZeroMoney
{
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] obtainUserIndianaWithcustomerId:user.customerId page:page category:0 callback:^(id obj) {
        DLog(@"获取我的夺宝进行中结果====%@",obj);
        [self sendMessageToCouponsListDataRequest];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (obj == nil && page != 1) {
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }else if (obj == nil && page == 1){
            [self notHaveBeingProduct];
        }else if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *array = [NSArray arrayWithObject:obj];
            if (array.count > 0 && array.count < 15 && page == 1) {
                self.tableView.mj_footer.hidden = YES;
            }
            [self clearBackContentViewSubView];
            [self loadMyCouponDataWith:obj];
        }
    }];
}

- (void)sendMessageToCouponsListDataRequest{
    NSNotificationCenter *messageCenter=[NSNotificationCenter  defaultCenter];
    [messageCenter postNotificationName:@"BeingLoadOver" object:Nil userInfo:nil];
}

- (void)loadMyCouponDataWith:(NSMutableArray *)array
{
    if (!_dataSourse) {
        self.dataSourse = [NSMutableArray array];
    }
    [self.dataSourse addObjectsFromArray:array];
    [self.tableView reloadData];
}

//没有数据 显示
- (void)notHaveBeingProduct
{
    [VCAppearManager arrengmentNotDataViewWithSuperView:_backContentView title:@"土豪，您目前没有进行中的夺宝!"];
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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView=[[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor backgroundGrayColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-114);
    }];
    
    __weak typeof(self) weakSelf = self;
    weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page=1;
        [self.dataSourse removeAllObjects];
        [weakSelf dataRequestWithZeroMoney];
    }];
    
    weakSelf.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf dataRequestWithZeroMoney];
    }];
    
    _backContentView=[[UIView alloc] init];
    [self.view addSubview:_backContentView];
    _backContentView.backgroundColor=[UIColor clearColor];
    [_backContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(-100);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
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
    ZeroIndianaModel *model=[self.dataSourse objectAtIndex:indexPath.section];
    if ([model.stock intValue] - [model.joinNum intValue] > 0) {
        return self.view.frame.size.width * 210 / 375;
    }else{
        return self.view.frame.size.width * 180 / 375;
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
    cell.nameLB.text = model.goodsName;
    if ([model.stock intValue] - [model.joinNum intValue] == 0) {
        cell.residueLB.attributedText = nil;
    }else{
        cell.residueLB.attributedText = [StringHelper renderFrontAndAfterDifferentFontWithValue:@"差" frontFont:13 frontColor:[UIColor characterBlackColor] afterStr:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%d",[model.stock intValue] - [model.joinNum intValue]]]  afterFont:13 afterColor:[UIColor zheJiangBusinessRedColor] lastStr:@"份" lastFont:13 lastColor:[UIColor characterBlackColor]];
    }
    //给图片赋值
    NSURL *url = [NSURL URLWithString:model.url];
    [cell.phoneImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"AdvertDefault.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //当网络请求到图片时, 会执行此block回调方法
        cell.phoneImg.image = image;
    }];
    cell.statusLB.attributedText = [StringHelper renderFrontAndAfterDifferentFontWithValue:@"" frontFont:13 frontColor:[UIColor characterBlackColor] afterStr:[NSString stringWithFormat:@"%@",model.consumeSilver]  afterFont:13 afterColor:[UIColor zheJiangBusinessRedColor] lastStr:@"两/次" lastFont:13 lastColor:[UIColor characterBlackColor]];
    cell.viewAlpha.alpha = 0;
    cell.purchasePregress.progress=[[CalculateProductInfo calculateZeroChangeProgressWith:model] doubleValue];
    [cell.purchasePregress setProgress:cell.purchasePregress.progress animated:YES];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyIndianaDetailVC *detailPageVC = [[MyIndianaDetailVC alloc] init];
    ZeroIndianaModel *model = self.dataSourse[indexPath.section];
    detailPageVC.idStr = model.idStr;
    detailPageVC.joinNum = model.joinNum;
    detailPageVC.stock = model.stock;
    //添加导航栏
    UITabBarController *control = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *VC = (UINavigationController *)control.selectedViewController;
    UIViewController *productVC = [VC topViewController];
    [productVC.navigationController pushViewController:detailPageVC animated:YES];
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
