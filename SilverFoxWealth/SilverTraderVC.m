//
//  SilverTraderVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/3/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SilverTraderVC.h"
#import "CustomViewCell.h"
#import "HeadViewCell.h"
#import "VCAppearManager.h"
#import "MySilverVC.h"
#import "DataRequest.h"
#import "StringHelper.h"
#import "SilverDetailPageVC.h"
#import "FindSilverTraderModel.h"
#import "MoreVC.h"
#import "ZeroMoneyIndianaVC.h"
#import "EarnSilverVC.h"
#import "ChangerRecordVC.h"
#import "PromptLanguage.h"
#import "SXMarquee.h"
#import "InspectNetwork.h"
#import "SilverGoodsLeightModel.h"
#import "SilverGoodsDiscriminateVC.h"
#import <MJRefresh.h>
#import "SCMeasureDump.h"
#import "UIImageView+WebCache.h"
#import "SilverGoodsBannerModel.h"
#import "SVProgressHUD.h"
#import "UMMobClick/MobClick.h"

@interface SilverTraderVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSString *silverStr;
@property (nonatomic, strong) SXMarquee *mar;//跑马灯
@property (nonatomic, strong) NSMutableArray *leightDataSource;
@property (nonatomic, strong) NSString *marStr;
@property (nonatomic, strong) NSMutableArray *isHaveConditionSource;
@property (nonatomic, strong) NSMutableArray *noHaveConditionSource;
@property (nonatomic, strong) FindSilverTraderModel *silverTraderModel;
@property (nonatomic, strong) UILabel *goodsNameLB;
@property (nonatomic, strong) UIButton *moreBT;
@property (nonatomic, strong) NSString *cellphoneStr;
@property (nonatomic, strong) SilverGoodsBannerModel *bannerModel;
@property (nonatomic, strong) CustomerNavgationController *customNav;
@property (nonatomic, strong) NSString *discountStr;
@end

@implementation SilverTraderVC
{
    BOOL isHaveLeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViewController];
    [self barStyle];
    isHaveLeight = YES;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadPullDownData)];
}

-(void)loadPullDownData
{
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    [self paomadengRequsetData:user.customerId];
    if (user) {
        [self achieveAssetDataWith:user.customerId];
    }else {
        [self achieveAssetDataWith:@""];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [self paomadengRequsetData:user.customerId];
    if (user) {
        [self achieveAssetDataWith:user.customerId];
    }else {
        [self achieveAssetDataWith:@""];
    }
    [self achieveVipInsterestNum];
}

- (void)achieveVipInsterestNum {
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [[DataRequest sharedClient]requestProductDetailAndSilverStoreCouponWithCustomerId:user.customerId type:@"6" callback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = obj;
            _discountStr = dict[@"data"];
        }
    }];
}


- (void)paomadengRequsetData:(NSString *)customerId
{
    [[DataRequest sharedClient] leightForSilverGoodsWithCustomerId:customerId callback:^(id obj)
     {
         if ([obj isKindOfClass:[NSDictionary class]]) {
             if ([obj[@"code"] intValue] == 2000) {
                 NSDictionary *dict = obj[@"data"];
                 _silverStr = dict[@"silvers"];
                 NSArray *array = dict[@"marquee"];
                 if (![array isEqual:[NSNull null]]) {
                     if (array.count != 0) {
                         NSMutableArray *resultArray=[NSMutableArray array];
                         NSError *error=nil;
                         for (NSDictionary *subDic in array) {
                             SilverGoodsLeightModel *model=[MTLJSONAdapter modelOfClass:[SilverGoodsLeightModel class] fromJSONDictionary:subDic error:&error];
                             [resultArray addObject:model];
                         }
                         if (!_leightDataSource) {
                             _leightDataSource = [NSMutableArray array];
                         }
                         [_leightDataSource addObjectsFromArray:resultArray];
                         if (_mar) {
                             [_mar removeFromSuperview];
                         }
                         [self leightWithList];
                     }
                 }else{
                     [self handleRemoveMar];
                 }
                 
                 NSDictionary *bannerDict = dict[@"banner"];
                 if (![bannerDict isEqual:[NSNull null]]) {
                     _bannerModel = [MTLJSONAdapter modelOfClass:[SilverGoodsBannerModel class] fromJSONDictionary:bannerDict error:nil];
                 }
             } else {
                 [self handleRemoveMar];
             }
         }
         [self.collectionView reloadData];
         if (!obj || [obj isKindOfClass:[NSError class]]) {
             if (IS_iPhoneX) {
                 self.collectionView.frame = CGRectMake(0, iPhoneX_Navigition_Bar_Height, self.view.frame.size.width, self.view.frame.size.height - iPhoneX_Navigition_Bar_Height);
             }else{
                 self.collectionView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
             }
         }
     }];
    if (![InspectNetwork connectedToNetwork]){
        [SVProgressHUD showErrorWithStatus:NotHaveNetwork];
    }
}

- (void)leightWithList
{
    _marStr = [NSString string];
    NSString *nameStr = [NSString string];
    for (int i = 0; i < _leightDataSource.count; i ++) {
        if ([_leightDataSource[i] isKindOfClass:[SilverGoodsLeightModel class]] )
        {
            SilverGoodsLeightModel *model = _leightDataSource[i];
            if (model.name.length == 0) {
                nameStr = @"";
            }else{
                nameStr = model.name;
            }
            if (model.cellphone.length == 0) {
                _cellphoneStr = @"";
            }else{
                _cellphoneStr = [model.cellphone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            }
            NSString *str = [NSString stringWithFormat:@"%@用户兑换了%@    ",_cellphoneStr,nameStr];
            _marStr = [_marStr stringByAppendingString:str];
        }
    }
    if (IS_iPhoneX) {
        _mar = [[SXMarquee alloc]initWithFrame:CGRectMake(0, iPhoneX_Navigition_Bar_Height, self.view.bounds.size.width, 25) speed:2 Msg:_marStr bgColor:[UIColor iconBlueColor] txtColor:[UIColor whiteColor]];
    }else{
        _mar = [[SXMarquee alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 25) speed:2 Msg:_marStr bgColor:[UIColor iconBlueColor] txtColor:[UIColor whiteColor]];
    }
    [_mar changeMarqueeLabelFont:[UIFont systemFontOfSize:14]];
    [_mar changeTapMarqueeAction:^{
        
    }];
    [self.view addSubview:_mar];
    [_mar start];
    
    [UIView animateWithDuration:0.5 animations:^{
        if (IS_iPhoneX) {
            self.collectionView.frame = CGRectMake(0, 25 + iPhoneX_Navigition_Bar_Height, self.view.frame.size.width, self.view.frame.size.height - 25 - iPhoneX_Navigition_Bar_Height);
        }else{
            self.collectionView.frame = CGRectMake(0, 25 + 64, self.view.frame.size.width, self.view.frame.size.height - 25 - 64);
        }
        
    } completion:^(BOOL finished) {
        
    }];
    
    UIButton *deleteBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBT setImage:[UIImage imageNamed:@"closeLight.png"] forState:UIControlStateNormal];
    [_mar addSubview:deleteBT];
    deleteBT.frame = CGRectMake(self.view.frame.size.width - 30, 0, 30, 25);
    [deleteBT addTarget:self action:@selector(handleRemoveMar) forControlEvents:UIControlEventTouchUpInside];
}

- (void)handleRemoveMar
{
    isHaveLeight = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _mar.alpha=0;
        if (IS_iPhoneX) {
            self.collectionView.frame = CGRectMake(0, iPhoneX_Navigition_Bar_Height, self.view.frame.size.width, self.view.frame.size.height - iPhoneX_Navigition_Bar_Height);
        }else{
            self.collectionView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
        }
    } completion:^(BOOL finished) {
        [_mar removeFromSuperview];
    }];
}

-(void)achieveAssetDataWith:(NSString *)customerId {
    [[DataRequest sharedClient]requestSilverGoodsDataWithCallback:^(id obj) {
        [self.collectionView.mj_header endRefreshing];
        if (!_isHaveConditionSource) {
            _isHaveConditionSource = [NSMutableArray array];
        }
        if (!_noHaveConditionSource) {
            _noHaveConditionSource = [NSMutableArray array];
        }
        [self.isHaveConditionSource removeAllObjects];
        [self.noHaveConditionSource removeAllObjects];
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *array = obj;
            for (FindSilverTraderModel *model in array) {
                if ([model.achieveAmount intValue] > 0) {
                    [_isHaveConditionSource addObject:model];
                } else {
                    [_noHaveConditionSource addObject:model];
                }
            }
            [_collectionView reloadData];
        }
    }];
}

- (void)barStyle
{
    UIButton *shareBt=[UIButton buttonWithType:UIButtonTypeCustom];
    shareBt.frame=CGRectMake(0, 5, 60, 20);
    [shareBt setTitle:@"银子说明" forState:UIControlStateNormal];
    [shareBt setTitleColor:[UIColor iconBlueColor] forState:UIControlStateNormal];
    shareBt.titleLabel.font = [UIFont systemFontOfSize:14];
    [shareBt addTarget:self action:@selector(quotaInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBT=[[UIBarButtonItem alloc] initWithCustomView:shareBt];
    self.navigationItem.rightBarButtonItem=barBT;
}

- (void)quotaInfo
{
    [MobClick event:@"silver_use_instruct"];
    [VCAppearManager pushH5VCWithCurrentVC:self workS:silverUseInfo];
}

- (void)setUpViewController{
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"银子商城";
    self.title = @"银子商城";
    [_customNav.rightButton setTitle:@"银子说明" forState:UIControlStateNormal];
    [self.view addSubview:_customNav];
    __weak typeof(self) weakSelf = self;
    _customNav.leftViewController = ^{
        if ([weakSelf.whereFrom isEqualToString:@"banner"]) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }else
        {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    _customNav.rightButtonHandle = ^{
        [MobClick event:@"silver_use_instruct"];
        [VCAppearManager pushH5VCWithCurrentVC:weakSelf workS:silverUseInfo];
    };
    self.view.backgroundColor = [UIColor backgroundGrayColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.frame.size.width / 2 - 2.5, (self.view.frame.size.width / 2 - 2.5) / 1.2 + 50);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 10;
    if (IS_iPhoneX) {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 25 + iPhoneX_Navigition_Bar_Height, self.view.frame.size.width, self.view.frame.size.height - 25 - iPhoneX_Navigition_Bar_Height) collectionViewLayout:layout];
    }else{
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 25 + 64, self.view.frame.size.width, self.view.frame.size.height - 25 - 64) collectionViewLayout:layout];
    }
    _collectionView.backgroundColor = [UIColor backgroundGrayColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //注册cell
    [_collectionView registerClass:[CustomViewCell class] forCellWithReuseIdentifier:@"cell"];
    //注册页眉
    [_collectionView registerClass:[HeadViewCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headCel"];
    [self.view addSubview:_collectionView];
    
    _goodsNameLB = [[UILabel alloc] init];
    _goodsNameLB.font = [UIFont systemFontOfSize:16];
    _goodsNameLB.frame = CGRectMake(15, 15, 100, 15);
    _goodsNameLB.text = @"热门专区";
    _goodsNameLB.textColor = [UIColor characterBlackColor];
    _goodsNameLB.font = [UIFont systemFontOfSize:14];
    _moreBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreBT.titleLabel.font=[UIFont systemFontOfSize:13];
    [_moreBT addTarget:self action:@selector(clickMoreBt:) forControlEvents:UIControlEventTouchUpInside];
    _moreBT.contentMode=UIViewContentModeScaleAspectFit;
    [_moreBT setImage:[UIImage imageNamed:@"AllowRight.png"] forState:UIControlStateNormal];
    [_moreBT setTitleColor:[UIColor iconBlueColor] forState:UIControlStateNormal];
    _moreBT.frame = CGRectMake(self.view.frame.size.width - 40, 10, 40, 25);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        if (!_isHaveConditionSource || _isHaveConditionSource.count == 0) {
            return 0;
        }else if(_isHaveConditionSource.count > 2){
            return 2;
        }else{
            return _isHaveConditionSource.count;
        }
    }
    if (section == 1) {
        if (!_noHaveConditionSource || _noHaveConditionSource.count == 0) {
            return 0;
        }else if(_noHaveConditionSource.count > 2){
            return 2;
        }else{
            return _noHaveConditionSource.count;
        }
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CustomViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        NSMutableArray *array = [NSMutableArray array];
        if (_isHaveConditionSource) {
            if (_isHaveConditionSource.count > 2) {
                for (int i = 0; i < 2; i ++) {
                    [array addObject:self.isHaveConditionSource[i]];
                }
                _silverTraderModel = [array objectAtIndex:indexPath.row];
            }else{
                _silverTraderModel = [self.isHaveConditionSource objectAtIndex:indexPath.row];
            }
        }
    }
    if (indexPath.section == 1) {
        NSMutableArray *array = [NSMutableArray array];
        if (_noHaveConditionSource.count > 0) {
            if (_noHaveConditionSource.count > 2) {
                for (int i = 0; i < 2; i ++) {
                    [array addObject:self.noHaveConditionSource[i]];
                }
                _silverTraderModel = [array objectAtIndex:indexPath.row];
            }else{
                _silverTraderModel = [self.noHaveConditionSource objectAtIndex:indexPath.row];
            }
        }
    }
    [cell setUpSilverGoodsListData:_silverTraderModel discountStr:_discountStr];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (kind == UICollectionElementKindSectionHeader) {
            HeadViewCell *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headCell" forIndexPath:indexPath];
            header.backgroundColor = [UIColor whiteColor];
            
            NSURL *url = [NSURL URLWithString:_bannerModel.url];
            [header.bannerImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"AdvertDefault.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    
                    header.bannerImage.image = image;
                }else{
                    header.bannerImage.image = [UIImage imageNamed:@"AdvertDefault.png"];
                }
            }];
            IndividualInfoManage *user=[IndividualInfoManage currentAccount];
            if (user){
                if (_silverStr == nil) {
                    _silverStr = @" ";
                }
                header.headLB.attributedText = [StringHelper renderFrontAndAfterDifferentFontWithValue:@"我的银子: " frontFont:15 frontColor:[UIColor characterBlackColor] afterStr:[NSString stringWithFormat:@"%@两",_silverStr]  afterFont:15 afterColor:[UIColor zheJiangBusinessRedColor]];
                [header.headBT setTitle:@"兑换记录" forState:UIControlStateNormal];
                [header userSilverNumWith:^{
                    [MobClick event:@"silver_store_exchange_history"];
                    ChangerRecordVC *changerVC = [[ChangerRecordVC alloc] init];
                    [self.navigationController pushViewController:changerVC animated:YES];
                }];
            }else {
                header.headLB.text = @"登录后查看银子数量";
                header.headLB.textColor = [UIColor characterBlackColor];
                [header.headBT setTitle:@"去登录" forState:UIControlStateNormal];
                [header userSilverNumWith:^{
                    [VCAppearManager presentLoginVCWithCurrentVC:self];
                }];
            }
            
            [header moreGoodsWith:^{
                SilverGoodsDiscriminateVC *goodsVC = [[SilverGoodsDiscriminateVC alloc] init];
                goodsVC.noHaveMutArr = _noHaveConditionSource;
                goodsVC.isHaveMutArr = _isHaveConditionSource;
                goodsVC.whereFrom = @"0";
                [self.navigationController pushViewController:goodsVC animated:YES];
            }];
            
            [header bannerImageWith:^{
                [MobClick event:@"silver_store_click_banner"];
                if ([_bannerModel.category intValue] == 1) {
                    [SCMeasureDump shareSCMeasureDump].productListId = _bannerModel.link;
                    [SCMeasureDump shareSCMeasureDump].silverGoodsImageBack = @"100";
                    [VCAppearManager pushNewH5VCWithCurrentVC:self workS:productAdContent];
                }else if ([_bannerModel.category intValue] == 2){
                    [SCMeasureDump shareSCMeasureDump].productListId = _bannerModel.idStr;
                    [VCAppearManager pushNewH5VCWithCurrentVC:self workS:productAdPage];
                }
            }];
            return header;
        }
    }else if (indexPath.section == 1){
        if (kind == UICollectionElementKindSectionHeader) {
            UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headCel" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor backgroundGrayColor];
            [cell addSubview:_goodsNameLB];
            [cell addSubview:_moreBT];
            return cell;
        }
    }
    return nil;
}

- (void)clickMoreBt:(UIButton *)sender
{
    [MobClick event:@"silver_store_hot_more"];
    SilverGoodsDiscriminateVC *goodsVC = [[SilverGoodsDiscriminateVC alloc] init];
    goodsVC.isHaveMutArr = _isHaveConditionSource;
    goodsVC.noHaveMutArr = _noHaveConditionSource;
    goodsVC.whereFrom = @"1";
    [self.navigationController pushViewController:goodsVC animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [MobClick event:@"silver_goods_detail_total"];
    SilverDetailPageVC *DetailPageVC = [[SilverDetailPageVC alloc] init];
    if (indexPath.section == 0) {
        NSMutableArray *array = [NSMutableArray array];
        if (_isHaveConditionSource.count > 1) {
            for (int i = 0; i < 2; i ++) {
                [array addObject:self.isHaveConditionSource[i]];
            }
        } else {
            [array addObject:_isHaveConditionSource[0]];
        }
        _silverTraderModel = [array objectAtIndex:indexPath.row];
    }
    if (indexPath.section == 1) {
        NSMutableArray *array = [NSMutableArray array];
        if (_noHaveConditionSource.count > 1) {
            for (int i = 0; i < 2; i ++) {
                [array addObject:self.noHaveConditionSource[i]];
            }
        } else {
            [array addObject:self.noHaveConditionSource[0]];
        }
        _silverTraderModel = [array objectAtIndex:indexPath.row];
    }
    DetailPageVC.title = _silverTraderModel.name;
    DetailPageVC.url =  [NSString stringWithFormat:@"%@",_silverTraderModel.url];
    float newPrice = [_silverTraderModel.consumeSilver intValue] * [_discountStr floatValue] /10;
    int resultPrice = (int)ceilf(newPrice);
    DetailPageVC.consumeSilver = [NSString stringWithFormat:@"%d",resultPrice];
    DetailPageVC.idStr = _silverTraderModel.idStr;
    DetailPageVC.type = _silverTraderModel.type;
    DetailPageVC.nameStr = _silverTraderModel.name;
    DetailPageVC.stockNumber = _silverTraderModel.stock;
    DetailPageVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:DetailPageVC animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(0, [UIScreen mainScreen].bounds.size.width * 140 / 375 + 50 + 35);
    }else{
        return CGSizeMake(0, 35);
    }
    return CGSizeMake(0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


