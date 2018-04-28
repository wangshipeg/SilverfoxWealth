//
//  PaymentCalendarVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/10/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PaymentCalendarVC.h"
#import "PaymentCalendarView.h"
#import "DataRequest.h"
#import "AlreadyPurchaseProductModel.h"
#import "AlreadyBuyProductCell.h"
#import "AlreadyBuyProductDetailVC.h"
#import "WithoutAuthorization.h"
#import "UserInfoUpdate.h"
#import "VCAppearManager.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface PaymentCalendarVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (strong, nonatomic) PaymentCalendarView *calendarView;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableArray *loneDatasource;
@property (nonatomic, strong) AlreadyPurchaseProductModel *model;
@property (nonatomic, strong) UILabel *label;
@end

@implementation PaymentCalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
    self.date = [NSDate date];
    // Do any additional setup after loading the view.
}

- (void)requestPaymentCalendarData:(NSString *)paymentDate
{
    self.dataSource = [NSMutableArray array];
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [[DataRequest sharedClient]requestPaymentCalendarDataWithcustomerId:user.customerId paybackMonth:paymentDate callback:^(id obj) {
        if ([obj isKindOfClass:[NSArray class]]) {
            [self.dataSource addObjectsFromArray:obj];
        }
        if (obj == nil) {
            
        }
        if ([obj isKindOfClass:[WithoutAuthorization class]]) {
            [UserInfoUpdate clearUserLocalInfo];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [VCAppearManager presentLoginVCWithCurrentVC:self];
        }
        [self showPaymentCalendar];
    }];
}

- (void)showPaymentCalendar
{
    //日期状态
    //得到月份,去请求当月回款信息
    NSMutableArray *mutArr = [NSMutableArray array];
    for (AlreadyPurchaseProductModel *model in self.dataSource) {
        [mutArr addObject:model.paybackDate];
    }
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *dateStr in mutArr) {
        NSString *strNum = [dateStr substringFromIndex:8];
        [array addObject:strNum];
    }
    self.calendarView.allDaysArr = [NSArray arrayWithArray:array];
    WS(weakSelf)
    if (self.calendarView.nextMonthBlock) {
        [self.calendarView createCalendarViewWith:self.date];
        [self.loneDatasource removeAllObjects];
        [self.tableView reloadData];
        self.calendarView.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year){
            DLog(@"下月日期:%li-%li-%li", (long)year,(long)month,(long)day);
            weakSelf.loneDatasource = [NSMutableArray array];
            //点击日期响应事件
            //遍历数据源数组,得到日期(日)和数组中的到期日的后两位相等,则重新封装新的数组,刷新页面
            for (AlreadyPurchaseProductModel *model in weakSelf.dataSource) {
                NSString *strNum = [model.paybackDate substringFromIndex:8];
                if ([strNum intValue] == day) {
                    [weakSelf.loneDatasource addObject:model];
                }
            }
            [weakSelf.label removeFromSuperview];
            DLog(@"重新组装过的当天的数组===%@",weakSelf.loneDatasource);
            [weakSelf.tableView reloadData];
            if (weakSelf.loneDatasource.count == 0) {
                [weakSelf withoutProductView];
            }
        };
    }else if (self.calendarView.lastMonthBlock){
        //[self.calendarView createCalendarViewWith:self.date];
        self.calendarView.date = [NSDate date];
        self.calendarView.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year){
            DLog(@"上月日期:%li-%li-%li", (long)year,(long)month,(long)day);
        };
    }else{
        self.calendarView.date = [NSDate date];
        self.calendarView.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
            DLog(@"当月日期:%li-%li-%li", (long)year,(long)month,(long)day);
            
            weakSelf.loneDatasource = [NSMutableArray array];
            //点击日期响应事件
            //遍历数据源数组,得到日期(日)和数组中的到期日的后两位相等,则重新封装新的数组,刷新页面
            for (AlreadyPurchaseProductModel *model in weakSelf.dataSource) {
                NSString *strNum = [model.paybackDate substringFromIndex:8];
                if ([strNum intValue] == day) {
                    [weakSelf.loneDatasource addObject:model];
                }
            }
            [weakSelf.label removeFromSuperview];
            DLog(@"重新组装过的当天的数组===%@",weakSelf.loneDatasource);
            [weakSelf.tableView reloadData];
            if (weakSelf.loneDatasource.count == 0) {
                [weakSelf withoutProductView];
            }
            
        };
    }
    self.calendarView.nextMonthBlock = ^(){
        [weakSelf setupNextMonth];
    };
    self.calendarView.lastMonthBlock = ^(){
        [weakSelf setupLastMonth];
    };
}

- (void)withoutProductView
{
    _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width - 20, 20)];
    _label.text = @"当天没有到期的产品";
    _label.textColor = [UIColor zheJiangBusinessRedColor];
    _label.font = [UIFont systemFontOfSize:16];
    _label.textAlignment = NSTextAlignmentCenter;
    [self.tableView addSubview:_label];
}

- (void)UIDecorate
{
    CustomerNavgationController *customNav = [[CustomerNavgationController alloc] init];
    if (IS_iPhoneX) {
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height);
    }else{
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    }
    customNav.titleLabel.text = @"回款日历";
    self.title = @"回款日历";
    [self.view addSubview:customNav];
    __weak typeof (self) weakSelf = self;
    customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.view.backgroundColor = [UIColor backgroundGrayColor];
    
    _headerView = [[UIView alloc] init];
    _headerView.backgroundColor = [UIColor whiteColor];
    if (IS_iPhoneX) {
        _headerView.frame = CGRectMake(0, iPhoneX_Navigition_Bar_Height, [UIScreen mainScreen].bounds.size.width,  self.view.frame.size.height * 2 / 3.5);
    }else{
        _headerView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width,  self.view.frame.size.height * 2 / 3.5);
    }
    [self.view addSubview:_headerView];
    
    self.calendarView = [[PaymentCalendarView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, self.view.frame.size.width)];
    self.calendarView.date = [NSDate date];
    //得到月份,去请求当月回款信息
    [self requestPaymentCalendarData:self.calendarView.headDateStr];
    [self.headerView addSubview:self.calendarView];
    
    self.tableView=[[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(1);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.backgroundColor = [UIColor backgroundGrayColor];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.bounces = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.loneDatasource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *subCell=@"paymentCellIdentifier";
    AlreadyBuyProductCell *cell=[tableView dequeueReusableCellWithIdentifier:subCell];
    if (!cell) {
        cell=[[AlreadyBuyProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:subCell];
    }
    
    [cell  proceedSubMenuDetailWithDic:[self.loneDatasource objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AlreadyBuyProductDetailVC *detail = [[AlreadyBuyProductDetailVC alloc] init];
    AlreadyPurchaseProductModel *subModel = [self.loneDatasource objectAtIndex:indexPath.row];
    detail.infoModel=subModel;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)setupNextMonth {
    [self.calendarView removeFromSuperview];
    self.calendarView = [[PaymentCalendarView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, self.view.frame.size.width)];
    [self.headerView addSubview:self.calendarView];
    self.date = [self.calendarView nextMonth:self.date];
    [self.calendarView createCalendarViewWith:self.date];
    self.calendarView.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year){
        DLog(@"下月日期2:%li-%li-%li", (long)year,(long)month,(long)day);
    };
    //得到月份,去请求当月回款信息
    [self requestPaymentCalendarData:self.calendarView.headDateStr];
    
    WS(weakSelf)
    self.calendarView.nextMonthBlock = ^(){
        [weakSelf setupNextMonth];
    };
    self.calendarView.lastMonthBlock = ^(){
        [weakSelf setupLastMonth];
    };
    if (self.label) {
        [self.label removeFromSuperview];
    }
    [self.tableView reloadData];
}

- (void)setupLastMonth {
    [self.calendarView removeFromSuperview];
    self.calendarView = [[PaymentCalendarView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, self.view.frame.size.width)];
    [self.headerView addSubview:self.calendarView];
    self.date = [self.calendarView lastMonth:self.date];
    [self.calendarView createCalendarViewWith:self.date];
    self.calendarView.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year){
        DLog(@"上月日期:%li-%li-%li", (long)year,(long)month,(long)day);
    };
    //得到月份,去请求当月回款信息
    [self requestPaymentCalendarData:self.calendarView.headDateStr];
    WS(weakSelf)
    self.calendarView.lastMonthBlock = ^(){
        [weakSelf setupLastMonth];
    };
    self.calendarView.nextMonthBlock = ^(){
        [weakSelf setupNextMonth];
    };
    if (self.label) {
        [self.label removeFromSuperview];
    }
    [self.tableView reloadData];
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

