//
//  EndViewController.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/9/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "EndViewController.h"
#import "MyIndianaCell.h"
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
#import "SCMeasureDump.h"

@interface EndViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSourse;
@property (strong, nonatomic) UIView         *backContentView;

@end

@implementation EndViewController
{
    int page;//分页
    BOOL isHaveFooter; //是否已近添加了 上拉刷新视图
}

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    isHaveFooter = YES;
    [self UIDecorate];
    [self addNewMessageObserve];
}
- (void)addNewMessageObserve {
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(addMessageNoteWith) name:@"BeingLoadOver" object:nil];
}

- (void)addMessageNoteWith
{
    self.dataSourse = [NSMutableArray array];
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    [self dataRequestWithZeroMoney:user.customerId];
}

- (void)dataRequestWithZeroMoney:(NSString *)customerId
{
    [[DataRequest sharedClient] obtainUserIndianaWithcustomerId:customerId page:page category:1 callback:^(id obj) {
        DLog(@"获取我的夺宝结果====%@",obj);
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (obj == nil && page != 1) {
            self.collectionView.mj_footer.hidden = YES;
        }else if (obj == nil && page == 1){
            [self notHaveBeingProduct];
        }else if ([obj isKindOfClass:[NSArray class]]) {
            self.collectionView.mj_footer.hidden = NO;
            [self clearBackContentViewSubView];
            [self loadMyCouponDataWith:obj];
        }
    }];
}

- (void)loadMyCouponDataWith:(NSMutableArray *)array
{
    [self.dataSourse addObjectsFromArray:array];
    [self.collectionView reloadData];
}


//没有数据 显示
- (void)notHaveBeingProduct
{
    [VCAppearManager arrengmentNotDataViewWithSuperView:_backContentView title:@"土豪，您目前没有已开奖的夺宝!"];
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
    self.view.backgroundColor = [UIColor backgroundGrayColor];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.frame.size.width , self.view.frame.size.width * 180 / 375);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 15;
    layout.minimumLineSpacing = 10;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0 , 0, self.view.frame.size.width, self.view.frame.size.height - 64 - 50) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor backgroundGrayColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    __weak typeof(self) weakSelf = self;
    weakSelf.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf.dataSourse removeAllObjects];
        IndividualInfoManage *user=[IndividualInfoManage currentAccount];
        [weakSelf dataRequestWithZeroMoney:user.customerId];
    }];
    
    weakSelf.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        IndividualInfoManage *user=[IndividualInfoManage currentAccount];
        [weakSelf dataRequestWithZeroMoney:user.customerId];
    }];
    
    [_collectionView registerClass:[MyIndianaCell class] forCellWithReuseIdentifier:@"cellC"];
    [self.view addSubview:_collectionView];
    
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSourse.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyIndianaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellC" forIndexPath:indexPath];
    if (self.dataSourse.count == 0) {
        return cell;
    }
    ZeroIndianaModel *model=[self.dataSourse objectAtIndex:indexPath.row];
    cell.nameLB.text = model.goodsName;
    if ([model.stock intValue] - [model.joinNum intValue] == 0) {
        cell.residueLB.attributedText = nil;
    }else{
        cell.residueLB.attributedText = [StringHelper renderFrontAndAfterDifferentFontWithValue:@"差" frontFont:13 frontColor:[UIColor characterBlackColor] afterStr:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%d",[model.stock intValue] - [model.joinNum intValue]]]  afterFont:13 afterColor:[UIColor zheJiangBusinessRedColor] lastStr:@"份" lastFont:13 lastColor:[UIColor characterBlackColor]];
    }

    NSURL *url = [NSURL URLWithString:model.url];
    [cell.phoneImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"AdvertDefault.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.phoneImg.image = image;
    }];
    cell.statusLB.text = @"已开奖";
    cell.viewAlpha.alpha = 0.5;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MyIndianaDetailVC *detailPageVC = [[MyIndianaDetailVC alloc] init];
    ZeroIndianaModel *model = self.dataSourse[indexPath.row];
    detailPageVC.idStr = model.idStr;
    detailPageVC.joinNum = model.joinNum;
    detailPageVC.stock = model.stock;
    
    UITabBarController *control = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *VC=(UINavigationController *)control.selectedViewController;
    UIViewController *productVC=[VC topViewController];
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
