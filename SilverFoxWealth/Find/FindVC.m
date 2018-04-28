//
//  FindVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/12/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "FindVC.h"
#import "DataRequest.h"
#import "FindSIlverGoodsCell.h"
#import "FindViewOneCell.h"
#import "UMMobClick/MobClick.h"
#import "VCAppearManager.h"
#import "ZeroMoneyIndianaVC.h"
#import "EarnSilverVC.h"
#import "FindSilverTraderModel.h"
#import "SilverTraderVC.h"
#import "FindHotActivityCell.h"
#import "ActivityZoonModel.h"
#import "UIImageView+WebCache.h"
#import "SCMeasureDump.h"
#import "XLsn0wTextCarousel.h"
#import "DataSourceModel.h"
#import "SilverDetailPageVC.h"
#import <MJRefresh.h>
#import "CommunalInfo.h"
#import "UINavigationController+DetectionNetState.h"
#import "CacheHelper.h"
#import "PromptLanguage.h"
#import "InspectNetwork.h"
#import "FinancialColumnModel.h"
#import "FindSilverTraderModel.h"
#import "ActivityZoonWebView.h"
#import "ActivityZoneVC.h"
#import "FinancialColumnVC.h"
#import "SVProgressHUD.h"

#define kWidth [UIScreen mainScreen].bounds.size.width

@interface FindVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,TextInfoViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *activitySource;
@property (nonatomic, strong) NSMutableArray *goodsSource;
@property (nonatomic, strong) NSMutableArray *extrasSource;
@property (nonatomic, strong) UIView *tableViewHeadView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) CustomerNavgationController *custumerNav;
@property (nonatomic, strong) UIImageView *imageLine;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) NSString *discountStr;
@end

@implementation FindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestFindData];
    [self UIDecorate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentNetState:) name:Network_State_name object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self achieveVipInsterestNum];
}

- (void)updateCurrentNetState:(NSNotification *)note {
    BOOL isnet=[[note.userInfo objectForKey:@"state"] boolValue];
    [self.navigationController detectionCurrentNetWith:isnet];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_goodsSource.count == 0) {
        return 4;
    }
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_goodsSource.count == 0) {
        if (indexPath.section == 0) {
            return (kWidth - 15) / 2 + 55;
        }
        if (indexPath.section == 1) {
            return 60;
        }
        if (indexPath.section == 2) {
            return (kWidth - 40) * 140 / 330 + 30;
        }
        return 15;
    }
    
    if (indexPath.section == 0) {
        return (kWidth - 15) / 2 + 55;
    }
    if (indexPath.section == 1) {
        return 60;
    }
    if (indexPath.section == 2) {
        return (kWidth - 40) * 140 / 330 + 30;
    }
    if (indexPath.section == 3) {
        return kWidth * 145 / 375 + 50;
    }
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_goodsSource.count == 0) {
        if (section == 2) {
            return 40;
        }
        return 0;
    }
    if (section == 1 || section == 0 || section == 4) {
        return 0;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_goodsSource.count == 0) {
        if (section == 2 || section == 3) {
            return 0;
        }
    }
    if (section == 4 || section == 3) {
        return 0;
    }
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor backgroundGrayColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_goodsSource.count == 0) {
        if (section == 2) {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor whiteColor];
            if (self.extrasSource.count == 0) {
                return view;
            }
            UIButton *moreBT = [UIButton buttonWithType:UIButtonTypeCustom];
            [moreBT setImage:[UIImage imageNamed:@"find_activity.png"] forState:UIControlStateNormal];
            moreBT.frame = CGRectMake(0, 0, kWidth, 40);
            moreBT.titleLabel.font = [UIFont systemFontOfSize:14];
            [moreBT addTarget:self action:@selector(handleMoreBT:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:moreBT];
            return view;
        }
    } else {
        if (section == 2) {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor whiteColor];
            if (self.extrasSource.count == 0) {
                return view;
            }
            UIButton *moreBT = [UIButton buttonWithType:UIButtonTypeCustom];
            [moreBT setImage:[UIImage imageNamed:@"find_activity.png"] forState:UIControlStateNormal];
            moreBT.frame = CGRectMake(0, 0, kWidth, 40);
            moreBT.titleLabel.font = [UIFont systemFontOfSize:14];
            [moreBT addTarget:self action:@selector(handleMoreBT:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:moreBT];
            return view;
        }
        if (section == 3) {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor whiteColor];
            UIButton *moreBT = [UIButton buttonWithType:UIButtonTypeCustom];
            [moreBT setImage:[UIImage imageNamed:@"find_goods.png"] forState:UIControlStateNormal];
            moreBT.frame = CGRectMake(0, 0, kWidth, 40);
            moreBT.titleLabel.font = [UIFont systemFontOfSize:14];
            [moreBT addTarget:self action:@selector(handleSilverGoodsBT:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:moreBT];
            return view;
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FindViewOneCell *cell = [[FindViewOneCell alloc] initWithOtherReuseIdentifier:@"everydayCell"];
        [cell zeroIndianaWith:^{
            [MobClick event:@"zero_prize"];
            ZeroMoneyIndianaVC *indianaVC = [[ZeroMoneyIndianaVC alloc] init];
            indianaVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:indianaVC animated:YES];
        }];
        
        [cell luckDrawWith:^{
            [MobClick event:@"lottery"];
            [VCAppearManager pushNewH5VCWithCurrentVC:self workS:LuckDraw];
        }];
        
        [cell earnSilverWith:^{
            [MobClick event:@"earn_silver"];
            EarnSilverVC *earnSilverVC = [[EarnSilverVC alloc] init];
            earnSilverVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:earnSilverVC animated:YES];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.extrasSource.count == 0) {
            return cell;
        }
        _image.frame = CGRectMake(15, 10, 40, 40);
        [cell addSubview:_image];
        _imageLine.frame = CGRectMake(70, 10, 1, 40);
        [cell addSubview:_imageLine];
        
        NSMutableArray *dataSourceArray = [NSMutableArray array];
        
        for (int i = 0; i < _extrasSource.count; i++) {
            NSString *title = [_extrasSource objectAtIndex:i];
            DataSourceModel *model = [DataSourceModel dataSourceModelWithType:nil title:title URLString:nil];
            [dataSourceArray addObject:model];
        }
        
        XLsn0wTextCarousel *view = [[XLsn0wTextCarousel alloc] initWithFrame:CGRectMake(90 ,0, [UIScreen mainScreen].bounds.size.width - 100, 60)];
        view.dataSourceArray = dataSourceArray;
        view.currentTextInfoView.xlsn0wDelegate = self;
        view.hiddenTextInfoView.xlsn0wDelegate = self;
        view.backgroundColor =[UIColor whiteColor];
        [cell addSubview:view];
        return cell;
    }
    if (_goodsSource.count == 0) {
        if (indexPath.section == 2) {
            FindHotActivityCell *cell;
            static NSString *identifier=@"findIdentifier";
            cell=[tableView dequeueReusableCellWithIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell) {
                cell=[[FindHotActivityCell alloc] initWithOtherReuseIdentifier:identifier];
            }
            if (self.activitySource.count == 0) {
                return cell;
            }
            ActivityZoonModel *model=[self.activitySource objectAtIndex:indexPath.row];
            cell.nameLB.text = model.title;
            NSURL *url = [NSURL URLWithString:model.imgUrl];
            [cell.phoneImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"AdvertDefault.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                cell.phoneImg.image = image;
            }];
            NSString *currentTime = [SCMeasureDump shareSCMeasureDump].dateActivity;
            NSString *currentTimeStr = [currentTime substringToIndex:10];
            NSString *currentTimeNum=[currentTimeStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *beginTimeNum = [model.beginDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *endTimeNum = [model.endDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
            if ([currentTimeNum intValue] >= [beginTimeNum intValue] && [currentTimeNum intValue] <= [endTimeNum intValue]) {
                cell.statusLB.text = @"进行中";
                cell.viewAlpha.alpha = 0;
            }
            else if([currentTimeNum intValue] < [beginTimeNum intValue])
            {
                cell.statusLB.text = @"未开始";
                cell.viewAlpha.alpha = 0;
            } else if([currentTimeNum intValue] > [endTimeNum intValue]){
                cell.statusLB.text = @"已结束";
                cell.viewAlpha.alpha = .7;
            }
            cell.backgroundColor = [UIColor whiteColor];
            return cell;
        }
        if (indexPath.section == 3) {
            UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.backgroundColor=[UIColor backgroundGrayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        if (indexPath.section == 2) {
            FindHotActivityCell *cell;
            static NSString *identifier=@"findIdentifier";
            cell=[tableView dequeueReusableCellWithIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell) {
                cell=[[FindHotActivityCell alloc] initWithOtherReuseIdentifier:identifier];
            }
            if (self.activitySource.count == 0) {
                return cell;
            }
            ActivityZoonModel *model=[self.activitySource objectAtIndex:indexPath.row];
            cell.nameLB.text = model.title;
            NSURL *url = [NSURL URLWithString:model.imgUrl];
            [cell.phoneImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"AdvertDefault.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                cell.phoneImg.image = image;
            }];
            NSString *currentTime = [SCMeasureDump shareSCMeasureDump].dateActivity;
            NSString *currentTimeStr = [currentTime substringToIndex:10];
            NSString *currentTimeNum=[currentTimeStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
            DLog(@"currentTime====%@",currentTimeNum);
            NSString *beginTimeNum = [model.beginDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *endTimeNum = [model.endDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
            if ([currentTimeNum intValue] >= [beginTimeNum intValue] && [currentTimeNum intValue] <= [endTimeNum intValue]) {
                cell.statusLB.text = @"进行中";
                cell.viewAlpha.alpha = 0;
            }
            else if([currentTimeNum intValue] < [beginTimeNum intValue])
            {
                cell.statusLB.text = @"未开始";
                cell.viewAlpha.alpha = 0;
            } else if([currentTimeNum intValue] > [endTimeNum intValue]){
                cell.statusLB.text = @"已结束";
                cell.viewAlpha.alpha = .7;
            }
            cell.backgroundColor = [UIColor whiteColor];
            return cell;
        }
        
        if (indexPath.section == 3) {
            UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.backgroundColor=[UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            _layout.itemSize = CGSizeMake(self.view.frame.size.width / 2 - 7.5, kWidth * 145 / 375 + 50);
            _layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
            _layout.minimumInteritemSpacing = 5;
            _layout.minimumLineSpacing = 0;
            self.collectionView.frame = CGRectMake(0, 0, kWidth, kWidth * 145 / 375 + 50);
            _collectionView.backgroundColor = [UIColor whiteColor];
            self.collectionView.showsVerticalScrollIndicator = NO;
            self.collectionView.bounces = NO;
            self.collectionView.dataSource = self;
            self.collectionView.delegate = self;
            self.collectionView.alwaysBounceVertical = YES;
            [_collectionView registerClass:[FindSIlverGoodsCell class] forCellWithReuseIdentifier:@"headCell"];
            [cell addSubview:self.collectionView];
            return cell;
        }
        if (indexPath.section == 4) {
            UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.backgroundColor=[UIColor backgroundGrayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor=[UIColor backgroundGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([InspectNetwork connectedToNetwork]) {
        if (indexPath.section == 1) {
            [MobClick event:@"find_finance_new"];
            FinancialColumnVC *financiaVC = [[FinancialColumnVC alloc] init];
            financiaVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:financiaVC animated:YES];
        }
        if (indexPath.section == 2) {
            [MobClick event:@"find_go_active_detail"];
            ActivityZoonWebView *detailPageVC = [[ActivityZoonWebView alloc] init];
            NSArray *array = [NSArray array];
            array = self.activitySource;
            if (array.count == 0) {
                return;
            }
            ActivityZoonModel *model = array[indexPath.row];
            detailPageVC.model = model;
            detailPageVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailPageVC animated:YES];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:NotHaveNetwork];
    }
}
#pragma -mark 理财专栏代理
- (void)handleTopEventWithURLString:(NSString *)URLString
{
    [MobClick event:@"find_finance_new"];
    if ([InspectNetwork connectedToNetwork])
    {
        FinancialColumnVC *financiaVC = [[FinancialColumnVC alloc] init];
        financiaVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:financiaVC animated:YES];
    }else
    {
        [SVProgressHUD showErrorWithStatus:NotHaveNetwork];
    }
}


- (void)handleMoreBT:(UIButton *)sender
{
    ActivityZoneVC *activityVC = [[ActivityZoneVC alloc] init];
    activityVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:activityVC animated:YES];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.goodsSource.count == 0) {
        return 0;
    }
    return _goodsSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arrayData = [NSArray array];
    FindSIlverGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headCell" forIndexPath:indexPath];
    arrayData = self.goodsSource;
    if (arrayData.count == 0) {
        return cell;
    }
    FindSilverTraderModel *model = [[FindSilverTraderModel alloc] init];
    model = [self.goodsSource objectAtIndex:indexPath.row];
    [cell setUpSilverGoodsListData:model discountStr:_discountStr];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [MobClick event:@"find_go_goods_detail"];
    if ([InspectNetwork connectedToNetwork])
    {
        SilverDetailPageVC *DetailPageVC = [[SilverDetailPageVC alloc] init];
        FindSilverTraderModel *_silverTraderModel = [self.goodsSource objectAtIndex:indexPath.row];
        DetailPageVC.title = _silverTraderModel.name;
        DetailPageVC.url =  [NSString stringWithFormat:@"%@",_silverTraderModel.url];
        float newPrice = [_silverTraderModel.consumeSilver intValue] * [_discountStr floatValue] /10;
        int resultPrice = (int)ceilf(newPrice);
        DetailPageVC.consumeSilver = [NSString stringWithFormat:@"%d",resultPrice];
        DetailPageVC.idStr = _silverTraderModel.idStr;
        DetailPageVC.type = _silverTraderModel.type;
        DetailPageVC.nameStr = _silverTraderModel.name;
        DetailPageVC.stockNumber = _silverTraderModel.stock;
        //隐藏tabBar
        DetailPageVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:DetailPageVC animated:YES];
    }else
    {
        [SVProgressHUD showErrorWithStatus:NotHaveNetwork];
    }
}

- (void)handleSilverGoodsBT:(UIButton *)sender
{
    SilverTraderVC *goodsVC = [[SilverTraderVC alloc] init];
    goodsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsVC animated:YES];
}

- (void)requestFindData
{
    [self requestSilverGoodsData];
    [self requestHotActivityData];
    [self requestFinancingColumnData];
    [self.tableView.mj_header endRefreshing];
}

- (void)requestHotActivityData
{
    [[DataRequest sharedClient] activityZoonWithPage:1 size:15 callback:^(id obj) {
        DLog(@"热门活动返回数据=====%@",obj)
        if (!_activitySource) {
            _activitySource = [NSMutableArray array];
        }
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *array = obj;
            NSMutableArray *dataArray = [NSMutableArray array];
            if (array.count > 0) {
                [dataArray addObject:array[0]];
            }
            [self.activitySource addObjectsFromArray:dataArray];
            [CacheHelper saveFindPageDataSource:self.activitySource];
        }
        if ([obj isKindOfClass:[NSError class]]) {
            NSMutableArray *dic = [CacheHelper currentFindPageDataSource];
            if (dic) {
                [self.activitySource addObjectsFromArray:dic];
            }
        }
        [self.tableView reloadData];
    }];
}

- (void)requestSilverGoodsData
{
    [[DataRequest sharedClient] requestSilverGoodsDataWithCallback:^(id obj) {
        DLog(@"银子商城返回数据======%@",obj);
        if ([obj isKindOfClass:[NSArray class]]) {
            if(!_goodsSource){
                _goodsSource = [NSMutableArray array];
            }
            NSArray *array = obj;
            NSMutableArray *hotArray = [NSMutableArray array];
            if (array.count > 2) {
                for (int i = 0; i < 2; i ++) {
                    [hotArray addObject:array[i]];
                }
                [self.goodsSource addObjectsFromArray:hotArray];
            }else{
                [self.goodsSource addObjectsFromArray:array];
            }
            [CacheHelper saveFindOfGoodsDataSource:self.goodsSource];
            //获取折扣
            [self achieveVipInsterestNum];
        }
        if ([obj isKindOfClass:[NSError class]]) {
            NSMutableArray *dic = [CacheHelper currentFindGoodsDataSource];
            if (dic) {
                [self.goodsSource addObjectsFromArray:dic];
            }
        }
        [self.tableView reloadData];
        [self.collectionView reloadData];
    }];
}

- (void)achieveVipInsterestNum {
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    if (!user) {
        return;
    }
    [[DataRequest sharedClient]requestProductDetailAndSilverStoreCouponWithCustomerId:user.customerId type:@"6" callback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = obj;
            _discountStr = dict[@"data"];
        }else{
            _discountStr = nil;
        }
        [self.collectionView reloadData];
    }];
}

- (void)requestFinancingColumnData
{
    [[DataRequest sharedClient] finaacialColumnListWithPage:1 callback:^(id obj) {
        if ([obj isKindOfClass:[NSArray class]]) {
            if (!_extrasSource) {
                _extrasSource = [NSMutableArray array];
            }
            NSArray *arrray = obj;
            if (arrray.count < 6 && arrray.count > 0) {
                NSMutableArray *dataArray = [NSMutableArray array];
                for (int i = 0; i < arrray.count; i ++) {
                    FinancialColumnModel *model = arrray[i];
                    [dataArray addObject:model.title];
                }
                [self.extrasSource addObjectsFromArray:dataArray];
            } else if (arrray.count > 5) {
                NSMutableArray *dataArray = [NSMutableArray array];
                for (int i = 0; i < 5; i ++) {
                    FinancialColumnModel *model = arrray[i];
                    [dataArray addObject:model.title];
                }
                [self.extrasSource addObjectsFromArray:dataArray];
            }
            [CacheHelper saveFindExtrasDataSouurce:self.extrasSource];
        }
        if ([obj isKindOfClass:[NSError class]]) {
            NSMutableArray *dic = [CacheHelper currentExtrasDataSource];
            if (dic) {
                [self.extrasSource addObjectsFromArray:dic];
            }
        }
        [self.tableView reloadData];
    }];
}

- (void)UIDecorate
{
    if (IS_iPhoneX) {
        _custumerNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _custumerNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    
    _custumerNav.titleLabel.text = @"发现";
    [_custumerNav.leftButton setImage:nil forState:UIControlStateNormal];
    [self.view addSubview:_custumerNav];
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.custumerNav.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    __weak typeof(self) weakSelf = self;
    weakSelf.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.goodsSource removeAllObjects];
        [weakSelf.extrasSource removeAllObjects];
        [weakSelf requestFindData];
    }];
    
    _layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    
    _image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FinancialColumn.png"]];
    _imageLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"financialLine.png"]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end


