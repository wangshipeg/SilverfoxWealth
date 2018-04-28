

#import "RefinedCommendVC.h"
#import "DataRequest.h"
#import "PromptLanguage.h"
#import "NoneInvestView.h"
#import "AnimationHelper.h"
#import "RefinedProductCell.h"
#import "CommunalInfo.h"

#import "IndividualInfoManage.h"
#import "UserDefaultsManager.h"
#import "VCAppearManager.h"

#import "AdvertisementDetailVC.h"
#import "InspectNetwork.h"

#import "RecommendAdvertModel.h"
#import "SilverWealthProductModel.h"

#import "RefinedAdvertView.h"
#import "RegisteringView.h"
#import "RegisteringSucceedView.h"

#import "UINavigationController+DetectionNetState.h"

#import <POP.h>
#import <MJRefresh.h>
#import <SVProgressHUD.h>

#import "SCMeasureDump.h"

#import "DateHelper.h"
#import "SIgnInVC.h"
#import "SilverTraderVC.h"
#import "SilverWealthProductCell.h"
#import "CustomerSeparateTableViewCell.h"
#import "RecommendContentModel.h"
#import "CacheHelper.h"
#import "PopupModel.h"

#import "NavHeadTitleView.h"
#import "UIImageView+WebCache.h"

@interface RefinedCommendVC()<UIScrollViewDelegate,SDCycleScrollViewDelegate>

@property (nonatomic, copy) RecommendContentModel *recommendContentModel;
@property (nonatomic, copy) SilverWealthProductDetailModel *currentDispalyProduct;
@property (nonatomic, strong) NoneInvestView           *noneInvestView;
@property (nonatomic, strong) NSMutableArray      *dataSource;
@property (nonatomic, strong) RefinedAdvertView        *headerView;
@property (strong, nonatomic) RegisteringView          *registerBackView;
@property (nonatomic, strong) UIImageView *noviceGuideImg;
@property (nonatomic, strong) UILabel                  *registerTitleLB;
@property (nonatomic, strong) UITableView              *tableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) NSMutableArray *imageSourceArray;
@property (nonatomic, strong) UIImageView *imgview;
@property (nonatomic, strong) NavHeadTitleView *NavView;
@property (nonatomic, strong) UIButton *suspendBT;
@property (nonatomic, strong) NSString *outLinkOfButton;
@property (nonatomic, strong) NSString *titleOfButton;
@end

@implementation RefinedCommendVC

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self UIDecorate];
    [self dataInitialize];
    [self becomeFirstResponder];
    [self animateViewOfRound];
    [self createNav];
}

- (void)setUpUIScrollViewAndPageControl {
    int imagePage = 3;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * imagePage, self.view.frame.size.height);
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    for (int i = 1; i < imagePage + 1; i ++) {
        NSString *path;
        if (IS_iPhoneX) {
            path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"iphone%d.png",i]];
        }else{
            path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",i]];
        }
        UIImageView *_imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
        _imageView.frame = CGRectMake(self.view.frame.size.width * (i - 1), 0, self.view.frame.size.width, self.view.frame.size.height);
        if (i == imagePage) {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
            _imageView.userInteractionEnabled = YES;
            tapGesture.numberOfTapsRequired = 1;
            [_imageView addGestureRecognizer:tapGesture];
        }
        [self.scrollView addSubview:_imageView];
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender{
    [self.scrollView removeFromSuperview];
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.hidden = NO;
    [self.tableView reloadData];
}

- (void)animateViewOfRound
{
    NSUserDefaults *userDEfault = [NSUserDefaults standardUserDefaults];
    NSString *appVersionStr=[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    if ([userDEfault boolForKey:appVersionStr] == NO) {
        [self setUpUIScrollViewAndPageControl];
        [userDEfault setBool:YES forKey:appVersionStr];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.hidesBottomBarWhenPushed = NO;
    [self.tableView reloadData];
    if (!self.currentDispalyProduct) {
        [self achievePecommendData];
    }
    [self isSuspendShow];
}

- (void)createNav {
    self.title = @"精品推荐";
    if (IS_iPhoneX) {
        self.NavView = [[NavHeadTitleView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, iPhoneX_Navigition_Bar_Height)];
    } else {
        self.NavView = [[NavHeadTitleView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    }
    self.NavView.alpha = 0;
    self.NavView.title = @"精品推荐";
    [self.view addSubview:self.NavView];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 70) {
        self.NavView.alpha = scrollView.contentOffset.y/ 70;
        self.NavView.headBgView.alpha = 1;
    } else {
        self.NavView.headBgView.alpha = 1;
        self.NavView.alpha = 1;
    }
}

- (void)loadingPullDownData {
    [self achievePecommendData];
}

- (void)achievePecommendData
{
    [self requestBannerImageData];
    [self requestProductsData];
}

- (void)requestBannerImageData
{
    [[DataRequest sharedClient]perfectRecommendationWithCallback:^(id obj) {
        [_imgview removeFromSuperview];
        if ([obj isKindOfClass:[NSArray class]]) {
            _imageSourceArray = [NSMutableArray array];
            
            [_imageSourceArray addObjectsFromArray:obj];
            self.dataSourceArray = [NSMutableArray array];
            for (RecommendContentModel *model in _imageSourceArray) {
                [self.dataSourceArray addObject:model.url];
            }
            self.tableView.tableHeaderView = _headerView;
            self.headerView.advertBackSV.imageURLStringsGroup = self.dataSourceArray;
            [self.tableView reloadData];
        }
        if ([obj isKindOfClass:[NSError class]] || obj == nil) {
            _imgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AdvertDefault.png"]];
            _imgview.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 408 / 750);
            self.tableView.tableHeaderView = _imgview;
        }
    }];
}
- (void)requestProductsData
{
    if (![InspectNetwork connectedToNetwork]){
        [SVProgressHUD showErrorWithStatus:NotHaveNetwork];
    }
    [[DataRequest sharedClient]perfectRecommendationProductCallback:^(id obj) {
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *productArray = obj;
            [self.dataSource removeAllObjects];
            _dataSource = [NSMutableArray arrayWithArray:productArray];
            [self.tableView reloadData];
            [CacheHelper saveRecommendData:_dataSource];
        }
        if ([obj isKindOfClass:[NSError class]]) {
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a=[dat timeIntervalSince1970] * 1000;
            NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
            [SCMeasureDump shareSCMeasureDump].nowTime = timeString;
            NSMutableArray *dic = [CacheHelper currentRecommendData];
            if (dic) {
                self.dataSource = dic;
                [self.tableView reloadData];
            }
        }
    }];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    RecommendAdvertModel *advert = [_imageSourceArray objectAtIndex:index];
    [MobClick event:[NSString stringWithFormat:@"ad_click%ld",(long)index]];
    [[SensorsAnalyticsSDK sharedInstance] track:@"BannerClick"
                                 withProperties:@{
                                                  @"BannerIndex" : [NSNumber numberWithUnsignedLong:index],
                                                  @"BannerTitle" : advert.title,
                                                  }];
    if ([advert.type intValue] == 2 || [advert.type intValue] == 1) {
        AdvertisementDetailVC *advertisementVC = [[AdvertisementDetailVC alloc] init];
        advertisementVC.hidesBottomBarWhenPushed=YES;
        advertisementVC.advertModel = advert;
        [self.navigationController pushViewController:advertisementVC animated:YES];
    }
}

#pragma -mark Tableview代理和数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 70;
    }
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RefinedProductCell *cell;
    if (indexPath.section == 0) {
        static NSString *identifier = @"babyIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[RefinedProductCell alloc] initWithFourReuseIdentifier:identifier];
        }
        [cell showFourDaraWithDic];
        __weak id safeSelf = self;
        IndividualInfoManage *user=[IndividualInfoManage currentAccount];
        cell.noviceBlock = ^(){
            [MobClick event:@"recommend_newer_lead"];
            [safeSelf noviceInfo];
        };
        
        cell.signInBlock = ^(){
            [MobClick event:@"recommend_sign_has_prize"];
            if (!user) {
                [VCAppearManager presentLoginVCWithCurrentVC:self];
                return;
            }
            [safeSelf signInInfo];
        };

        cell.silverBlock = ^(){
            [MobClick event:@"recommend_invite_friend"];
            [safeSelf silverInfo];
        };
        
        cell.safeBlock = ^(){
            [MobClick event:@"recommend_info_out"];
            [safeSelf safeInfo];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 1) {
        SilverWealthProductCell *cell;
        static NSString *identifier=@"Identifier";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
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
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![InspectNetwork connectedToNetwork]){
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        [self entryNextPageWith:indexPath];
    }
}

- (void)entryNextPageWith:(NSIndexPath *)indexPath
{
    [MobClick event:@"product_detail"];
    RecommendContentModel *model=[self.dataSource objectAtIndex:indexPath.row];
    [VCAppearManager pushSilverWealthProductDetailWithCurrentVC:self model:model.productId];
}

- (void)noviceInfo
{
    [VCAppearManager pushNewH5VCWithCurrentVC:self workS:noviceGuide];
}

- (void)signInInfo
{
    SIgnInVC *signInVC = [[SIgnInVC alloc] init];
    signInVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:signInVC animated:YES];
}

- (void)silverInfo
{
    [VCAppearManager pushNewH5VCWithCurrentVC:self workS:invitorFriend];
}

- (void)safeInfo
{
    [VCAppearManager pushNewH5VCWithCurrentVC:self workS:safeEnsure];
}

- (void)UIDecorate {
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
    }
    self.tableView.backgroundColor = [UIColor backgroundGrayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGFloat screenWidth = window.bounds.size.width;
    _headerView = [[RefinedAdvertView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth * 408 / 750)];
    self.tableView.tableHeaderView = _headerView;
    self.tableView.tableHeaderView.backgroundColor = [UIColor redColor];
    self.headerView.advertBackSV.delegate = self;
    self.headerView.advertBackSV.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    
    __weak RefinedCommendVC *weakSelf = self;
    weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadingPullDownData];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
    _suspendBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_suspendBT];
//    _suspendBT.imageView.contentMode = UIViewContentModeCenter;
    [_suspendBT addTarget:self action:@selector(clickSuspendBT:) forControlEvents:UIControlEventTouchUpInside];
    [_suspendBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-100);
        make.height.equalTo(@60);
        make.width.equalTo(@60);
    }];
    _suspendBT.hidden = YES;
}

- (void)clickSuspendBT:(UIButton *)sender
{
    AdvertisementDetailVC *detailVC = [[AdvertisementDetailVC alloc] init];
    detailVC.productDetailActivityUrl = _outLinkOfButton;
    detailVC.productDetailActivityTitle = _titleOfButton;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)isSuspendShow
{
    [[DataRequest sharedClient]requestIsSuspendShowWithCategory:@"7" callback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = obj;
            NSString *remarkStr = dict[@"remark"];
            if (remarkStr.length > 0) {
                _suspendBT.hidden = NO;
                NSURL *url = [NSURL URLWithString:dict[@"remark"]];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                [_suspendBT setImage:image forState:UIControlStateNormal];
                _outLinkOfButton = dict[@"outLink"];
                _titleOfButton = dict[@"title"];
            }
        }
    }];
}

- (void)dataInitialize {
    self.dataSource = [NSMutableArray array];
    NSNotificationCenter *center = [NSNotificationCenter  defaultCenter];
    [center addObserver:self selector:@selector(entryActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    [center addObserver:self selector:@selector(updateCurrentNetState:) name:Network_State_name object:nil];
}

- (void)entryActive {
    [self achievePecommendData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateCurrentNetState:(NSNotification *)note {
    BOOL isnet = [[note.userInfo objectForKey:@"state"] boolValue];
    [self.navigationController detectionCurrentNetWith:isnet];
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




