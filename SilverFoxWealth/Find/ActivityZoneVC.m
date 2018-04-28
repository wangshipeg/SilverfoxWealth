

#import "ActivityZoneVC.h"
#import "ActivityZoonCell.h"
#import "BlackBorderBT.h"
#import "VCAppearManager.h"
#import "DataRequest.h"
#import "UserInfoUpdate.h"
#import "ActivityZoonModel.h"
#import "UIImageView+WebCache.h"
#import "StringHelper.h"
#import "ActivityZoonWebView.h"
#import "MJRefresh.h"
#import "SCMeasureDump.h"

@interface ActivityZoneVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSourse;

@end

@implementation ActivityZoneVC
{
    int page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    self.dataSourse = [NSMutableArray array];
    [self dataRequestWithZeroMoney];
    [self requestHotActivityData];
}

- (void)requestHotActivityData
{
    [[DataRequest sharedClient] activityZoonWithPage:page size:15 callback:^(id obj) {
        DLog(@"活动专区返回结果====%@",obj);
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *array = obj;
            [self.dataSourse addObjectsFromArray:array];
        }else if(obj == nil && page == 1){
            self.collectionView.mj_footer.hidden = YES;
        }else if(obj == nil && page > 1){
            self.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
        }
        [self.collectionView reloadData];
    }];
}


- (void)dataRequestWithZeroMoney
{
    CustomerNavgationController *customNav = [[CustomerNavgationController alloc] init];
    if (IS_iPhoneX) {
       customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height);
    }else{
       customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    }
    customNav.titleLabel.text = @"活动专区";
    self.title = @"活动专区";
    __weak typeof (self) weakSelf = self;
    customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:customNav];
    self.view.backgroundColor = [UIColor backgroundGrayColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.frame.size.width, (self.view.frame.size.width - 40) * 140 / 330 + 30);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 10;
    if (IS_iPhoneX) {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, iPhoneX_Navigition_Bar_Height, self.view.frame.size.width, self.view.frame.size.height - iPhoneX_Navigition_Bar_Height) collectionViewLayout:layout];
    }else{
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) collectionViewLayout:layout];
    }
    
    _collectionView.backgroundColor = [UIColor backgroundGrayColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //注册cell
    [_collectionView registerClass:[ActivityZoonCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
    
    weakSelf.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf.dataSourse removeAllObjects];
        [weakSelf requestHotActivityData];
    }];
    weakSelf.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [weakSelf requestHotActivityData];
    }];
}

- (void)loadMyCouponDataWith:(NSMutableArray *)array
{
    [self.dataSourse addObjectsFromArray:array];
    [self.collectionView reloadData];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSourse.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ActivityZoonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    ActivityZoonModel *model=[self.dataSourse objectAtIndex:indexPath.row];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ActivityZoonWebView *detailPageVC = [[ActivityZoonWebView alloc] init];
    ActivityZoonModel *model = self.dataSourse[indexPath.row];
    detailPageVC.model = model;
    [self.navigationController pushViewController:detailPageVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end




