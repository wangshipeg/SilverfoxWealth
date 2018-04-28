

#import "OneViewController.h"
#import "AlreadyBuyProductCell.h"
#import "AlreadyBuyProductDetailVC.h" //已购产品详情页面
#import "DataRequest.h"
#import "IndividualInfoManage.h"
#import "CommunalInfo.h"
#import "BlackBorderBT.h"
#import "WithoutAuthorization.h"
#import "VCAppearManager.h"
#import <SVProgressHUD.h>
#import "PromptLanguage.h"
#import "MJRefresh.h"
#import "UserInfoUpdate.h"

@interface OneViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int page;
    BOOL isHaveSend;
}
@property (strong, nonatomic) UITableView                  *tableView;
@property (nonatomic, strong) NSMutableArray               *incomeProceedDataSource;//收益中数据源
@property (nonatomic, strong) NSMutableArray               *subListDataSource;
@property (strong, nonatomic) UIView                       *backContentView;//如果未购买产品 用来显示

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    isHaveSend = NO;
    [self UIDecorate];
    [self animation];
    [self dataInitialize];
    [self achieveIncomeData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)animation
{
    [SVProgressHUD showWithStatus:PleaseWaitALittleWhile];
}

//获取数据
- (void)achieveIncomeData {
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] obtainUserAlreadyPurchaseProductWithcustomerId:user.customerId type:@"0" page:page callback:^(id obj) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        DLog(@"待回款产品加载结果====%@",obj);
        if (!isHaveSend) {
            [self sendMessageToCouponsListDataRequest];
        }
        [SVProgressHUD dismiss];
        if (obj == nil && page != 1) {
            [self clearBackContentViewSubView];
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        }else if (obj == nil && page == 1){
            [self showNoIncomeProceedProductView];
        }else if ([obj isKindOfClass:[NSArray class]]) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:obj];
            if (array.count == 0 && page == 1) {
                [self showNoIncomeProceedProductView];
            }else if (array.count == 0 && page != 1){
                [self clearBackContentViewSubView];
                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
            }else{
                if (page == 1 && array.count > 0 && array.count < 15) {
                    self.tableView.mj_footer.hidden = YES;
                }
                [self clearBackContentViewSubView];
                [self pickData:obj];
            }
        }
        //授权失败
        if ([obj isKindOfClass:[WithoutAuthorization class]]) {
            [UserInfoUpdate clearUserLocalInfo];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [VCAppearManager presentLoginVCWithCurrentVC:self];
        }
    }];
}
- (void)sendMessageToCouponsListDataRequest{
    NSNotificationCenter *messageCenter=[NSNotificationCenter  defaultCenter];
    [messageCenter postNotificationName:@"loadOverOne" object:Nil userInfo:nil];
    isHaveSend = YES;
}

-(void)pickData:(NSMutableArray *)array {
    if (!self.incomeProceedDataSource) {
        self.incomeProceedDataSource = [NSMutableArray array];
    }
    [self.incomeProceedDataSource addObjectsFromArray:array];
    [self gainDaiHuiKUanOrderListWith:self.incomeProceedDataSource];
    [self.tableView reloadData];
    return;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.subListDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *subCell=@"subCellIdentifier";
    AlreadyBuyProductCell *cell=[tableView dequeueReusableCellWithIdentifier:subCell];
    if (!cell) {
        cell=[[AlreadyBuyProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:subCell];
    }
    
    [cell  proceedSubMenuDetailWithDic:[self.subListDataSource objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AlreadyBuyProductDetailVC *detail=[[AlreadyBuyProductDetailVC alloc] init];
    AlreadyPurchaseProductModel *subModel=[self.subListDataSource objectAtIndex:indexPath.row];
    detail.infoModel=subModel;
    
    UITabBarController *control = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *VC=(UINavigationController *)control.selectedViewController;
    UIViewController *productVC=[VC topViewController];
    [productVC.navigationController pushViewController:detail animated:YES];
}

- (void)gainDaiHuiKUanOrderListWith:(id)data
{
    //如果是数组 说明获取值成功
    if ([data isKindOfClass:[NSArray class]]) {
        NSArray *array=data;
        [self.subListDataSource removeAllObjects];
        [self.subListDataSource addObjectsFromArray:array];
    }
}
#pragma -mark 无数据配置
- (void)showNoIncomeProceedProductView {
    [self clearBackContentViewSubView];
    if (self.incomeProceedDataSource.count == 0 ) {
        [self notBuyProductWithTitle:@"暂无待回款产品!"];
    }
}

- (void)notBuyProductWithTitle:(NSString *)title {
    [VCAppearManager arrengmentNotDataViewWithSuperView:_backContentView title:title];
    [self.view bringSubviewToFront:_backContentView];
}

- (void)clearBackContentViewSubView {
    if ([_backContentView subviews] != 0) {
        for (UIView *vi in [_backContentView subviews]) {
            [vi removeFromSuperview];
        }
        [self.view sendSubviewToBack:_backContentView];
    }
    _backContentView.hidden=YES;
}


#pragma -mark 初始化

- (void)dataInitialize {
    self.incomeProceedDataSource=[NSMutableArray array];
    self.subListDataSource=[NSMutableArray array];
    _backContentView.hidden = YES;
}


#pragma -mark 界面布局相关


- (void)UIDecorate {
    self.view.backgroundColor=[UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //tableView
    _tableView=[[UITableView alloc] init];
    [self.view addSubview:_tableView];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-115);
    }];
    _tableView.tableFooterView = [[UIView alloc] init];
    
    _backContentView=[[UIView alloc] init];
    [self.view addSubview:_backContentView];
    _backContentView.backgroundColor=[UIColor clearColor];
    [_backContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-115);
    }];
    
    __weak typeof(self) weakSelf = self;
    weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf.incomeProceedDataSource removeAllObjects];
        [weakSelf achieveIncomeData];
    }];
    
    weakSelf.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [weakSelf achieveIncomeData];
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

@end

