

#import "ProductVC.h"
#import "DataRequest.h"
#import "CommunalInfo.h"
#import <MJRefresh.h>
#import "ProductDetailVC.h"
#import "SilverWealthProductCell.h"
#import "UINavigationController+DetectionNetState.h"
#import <SVProgressHUD.h>
#import "InspectNetwork.h"
#import "PromptLanguage.h"
#import "UMMobClick/MobClick.h"
#import "VCAppearManager.h"
#import "SCMeasureDump.h"
#import "SXMarquee.h"
#import "CacheHelper.h"
#import "ProductListVipInteresteBombBoxView.h"
#import "V1ToV3SuspendView.h"

@interface ProductVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) SXMarquee *marquee;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary  *leightDic;
@property (nonatomic, strong) CustomerNavgationController *customNav;

@property (nonatomic, strong) NSString *vipInsterestStr;

@property (nonatomic, strong) UIButton *suspendBT;
@property (nonatomic, strong) NSString *btImg;

@end

@implementation ProductVC
{
    int page;
    BOOL isDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    [self dataInitialize];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    page = 1;
    if (self.dataSource) {
        [self.dataSource removeAllObjects];
        [self achieveProductListData];
    } else {
        self.dataSource = [NSMutableArray array];
    }
    [self marqueeRequsetData];
}

- (void)marqueeRequsetData
{
    [[DataRequest sharedClient] leightSilverWealthWithListCallback:^(id obj) {
        if ([obj isKindOfClass: [NSDictionary class]]) {
            if ([obj[@"code"] intValue] == 2000) {
                _leightDic = obj[@"data"];
                if (![_leightDic isEqual:[NSNull null]]) {
                    [self leightWithList];
                }
            }
        }
        if (!obj) {
            [self handleRemoveMar];
        }
    }];
    if (![InspectNetwork connectedToNetwork]){
        [SVProgressHUD showErrorWithStatus:NotHaveNetwork];
    }
}

- (void)leightWithList
{
    if (IS_iPhoneX) {
        _marquee = [[SXMarquee alloc]initWithFrame:CGRectMake(0, iPhoneX_Navigition_Bar_Height, self.view.bounds.size.width, 25) speed:4 Msg:_leightDic[@"remark"] bgColor:[UIColor iconBlueColor] txtColor:[UIColor whiteColor]];
    } else {
        _marquee = [[SXMarquee alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 25) speed:4 Msg:_leightDic[@"remark"] bgColor:[UIColor iconBlueColor] txtColor:[UIColor whiteColor]];
    }
    [_marquee changeMarqueeLabelFont:[UIFont systemFontOfSize:14]];
    [_marquee changeTapMarqueeAction:^{
        [MobClick event:@"product_list_click_marquee"];
        if ([_leightDic[@"type"] intValue] == 1) {
            [SCMeasureDump shareSCMeasureDump].productListId = _leightDic[@"outLink"];
            [VCAppearManager pushNewH5VCWithCurrentVC:self workS:productAdContent];
        }else{
            [SCMeasureDump shareSCMeasureDump].productListId = _leightDic[@"id"];
            [VCAppearManager pushNewH5VCWithCurrentVC:self workS:productAdPage];
        }
    }];
    [self.view addSubview:_marquee];
    [_marquee start];
    
    UIButton *deleteBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBT setImage:[UIImage imageNamed:@"closeLight.png"] forState:UIControlStateNormal];
    [_marquee addSubview:deleteBT];
    deleteBT.frame = CGRectMake(self.view.frame.size.width - 30, 0, 30, 25);
    [deleteBT addTarget:self action:@selector(handleRemoveMar) forControlEvents:UIControlEventTouchUpInside];
}

- (void)handleRemoveMar
{
    for(UIView *subv in [self.view subviews])
    {
        if ([subv isKindOfClass:[SXMarquee class]]) {
            [subv removeFromSuperview];
        }
    }
}

- (void)achieveProductListData
{
    [[DataRequest sharedClient] achieveSilverWealthWithPage:page categoryId:nil status:nil period:nil callback:^(id obj) {
        DLog(@"产品列表数据加载结果=====%@",obj);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([obj isKindOfClass:[NSArray class]]) {
            self.tableView.mj_footer.hidden = NO;
            NSArray *array = obj;
            [self.dataSource addObjectsFromArray:array];
            [CacheHelper saveFinancingProductList:array];
            [self achieveUserInfo];
            [self.tableView reloadData];
        }
        if ([obj isKindOfClass:[NSError class]] || !obj)
        {
            self.tableView.mj_footer.hidden = YES;
            NSMutableArray *dic = [CacheHelper currentFinancingProductList];
            if (dic) {
                self.dataSource = dic;
                [self.tableView reloadData];
            }
        }
    }];
}

- (void)achieveUserInfo
{
    [[DataRequest sharedClient]requestIsSuspendShowWithCategory:@"8" callback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = obj;
            NSString *remarkStr = dict[@"remark"];
            if (remarkStr.length > 0) {
                _btImg = remarkStr;
            }
        }else{
            _suspendBT.hidden = YES;
        }
        [self achieveCustomerUserInfo];
    }];
}

- (void)achieveCustomerUserInfo
{
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    if (!user) {
        if (_suspendBT) {
            _suspendBT.hidden = YES;
        }
        return;
    }else{
        _suspendBT.hidden = NO;
    }
    [[DataRequest sharedClient] achieveCustomerUserInfoWithcustomerId:user.customerId callback:^(id obj) {
        if ([obj isKindOfClass:[IndividualInfoManage class]]) {
            IndividualInfoManage *userInfo = obj;
            [IndividualInfoManage updateAccountWith:userInfo];
            NSUserDefaults *userDEfault = [NSUserDefaults standardUserDefaults];
            if (![userDEfault objectForKey:[NSString stringWithFormat:@"%@vipLevel",userInfo.customerId]]) {
                isDefault = YES;
            } else if ([userDEfault objectForKey:[NSString stringWithFormat:@"%@vipLevel",userInfo.customerId]]) {
                if ([[userDEfault objectForKey:[NSString stringWithFormat:@"%@vipLevel",userInfo.customerId]] intValue] < [userInfo.vipLevel intValue]) {
                    isDefault = YES;
                } else {
                    isDefault = NO;
                }
            }
            [userDEfault setObject:userInfo.vipLevel forKey:[NSString stringWithFormat:@"%@vipLevel",userInfo.customerId]];
            [self achieveVipInsterestNum:userInfo];
        }
    }];
}

- (void)achieveVipInsterestNum : (IndividualInfoManage *)user{
    [[DataRequest sharedClient]requestProductDetailAndSilverStoreCouponWithCustomerId:user.customerId type:@"7" callback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            _vipInsterestStr = obj[@"data"];
            if (isDefault && _btImg.length > 0) {
                [self clickSuspendBTEvent];
                [self handleSuspendBT:_suspendBT];
            } else if (!isDefault && _btImg.length > 0){
                [self clickSuspendBTEvent];
            }
        }
    }];
}

- (void)clickSuspendBTEvent
{
    NSURL *url = [NSURL URLWithString:_btImg];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    [_suspendBT setImage:image forState:UIControlStateNormal];
    [self.view addSubview:_suspendBT];
    [_suspendBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@70);
        make.width.equalTo(@70);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SilverWealthProductCell *cell;
    static NSString *identifier=@"experienceIdentifier";
    cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[SilverWealthProductCell alloc] initWithOtherReuseIdentifier:identifier];
    }
    if (self.dataSource.count == 0) {
        return cell;
    }
    SilverWealthProductModel *model=[self.dataSource objectAtIndex:indexPath.row];
    if (!model) {
        return nil;
    }
    [cell showOtherDataWithDic:model];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([InspectNetwork connectedToNetwork]) {
        [self entryNextPageWith:indexPath];
    } else {
        [SVProgressHUD showErrorWithStatus:NotHaveNetwork];
    }
}

- (void)entryNextPageWith:(NSIndexPath *)indexPath
{
    [MobClick event:@"product_detail"];
    if (self.dataSource.count == 0) {
        return;
    }
    SilverWealthProductDetailModel *model = [self.dataSource objectAtIndex:indexPath.row];
    [VCAppearManager pushSilverWealthProductDetailWithCurrentVC:self model:model.productId];
}

- (void)dataInitialize
{
    self.title = @"理财";
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"理财";
    [_customNav.leftButton setImage:nil forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    NSArray *viewControllers=self.navigationController.viewControllers;
    if (viewControllers.count > 1){
        [_customNav.leftButton setImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
        weakSelf.customNav.leftViewController = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    [self.view addSubview:_customNav];
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNav.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf.dataSource removeAllObjects];
        [weakSelf marqueeRequsetData];
        [weakSelf achieveProductListData];
    }];
    
    weakSelf.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [weakSelf achieveProductListData];
    }];
    
    _suspendBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _suspendBT.backgroundColor = [UIColor clearColor];
//    _suspendBT.layer.cornerRadius = 35;
//    _suspendBT.layer.shadowColor=[UIColor grayColor].CGColor;
//    _suspendBT.layer.shadowOffset=CGSizeMake(1, 1);
//    _suspendBT.layer.shadowOpacity=0.5;
//    _suspendBT.layer.shadowRadius=5;
    
    [_suspendBT addTarget:self action:@selector(handleSuspendBT:) forControlEvents:UIControlEventTouchUpInside];
    
    NSNotificationCenter *center=[NSNotificationCenter  defaultCenter];
    [center addObserver:self selector:@selector(entryActiveLoadProductListData) name:UIApplicationWillEnterForegroundNotification  object:nil];
    [center addObserver:self selector:@selector(updateCurrentNetState:) name:Network_State_name object:nil];
}

- (void)handleSuspendBT:(UIButton *)sender
{
    if ([_vipInsterestStr doubleValue] == 0) {
        V1ToV3SuspendView *successView = [[[NSBundle mainBundle] loadNibNamed:@"CommenCell" owner:self options:nil] objectAtIndex:8];
        [successView showVipIntersterBombBoxView];
    } else {
        IndividualInfoManage *user = [IndividualInfoManage currentAccount];
        ProductListVipInteresteBombBoxView *successView = [[[NSBundle mainBundle] loadNibNamed:@"CommenCell" owner:self options:nil] objectAtIndex:7];
        successView.gradeLB.text = [NSString stringWithFormat:@"恭喜您成为V%@会员",user.vipLevel];
        successView.vipInterest.text = [NSString stringWithFormat:@"%@%%会员加息",_vipInsterestStr];
        [successView showVipIntersterBombBoxView];
    }
}

- (void)entryActiveLoadProductListData
{
    if (_dataSource) {
        [_dataSource removeAllObjects];
    }
    [self.tableView.mj_header beginRefreshing];
    [self marqueeRequsetData];
}

- (void)updateCurrentNetState:(NSNotification *)note
{
    BOOL isnet=[[note.userInfo objectForKey:@"state"] boolValue];
    [self.navigationController detectionCurrentNetWith:isnet];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if (self.isViewLoaded && !self.view.window)
    {
        self.view = nil;
    }
}

@end


