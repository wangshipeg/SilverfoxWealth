//
//  HotGoodsVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/12/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HotGoodsVC.h"
#import "CustomViewCell.h"
#import "FindSilverTraderModel.h"
#import "SilverDetailPageVC.h"

@interface HotGoodsVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HotGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNewMessageObserve];
    // Do any additional setup after loading the view.
}
- (void)addNewMessageObserve {
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(addMessageNoteWith) name:@"goodsStore" object:nil];
}

- (void)addMessageNoteWith
{
    [self setUpViewController];
}

- (void)setUpViewController{
    self.view.backgroundColor = [UIColor backgroundGrayColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.frame.size.width / 2 - 2.5, (self.view.frame.size.width / 2 - 2.5) / 1.2 + 50);
    //上 左 下 右 平移像素
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 10;
    if (IS_iPhoneX) {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 174) collectionViewLayout:layout];
    }else{
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 110) collectionViewLayout:layout];
    }
    
    _collectionView.backgroundColor = [UIColor backgroundGrayColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    //注册cell
    [_collectionView registerClass:[CustomViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CustomViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    FindSilverTraderModel *_silverTraderModel = [self.dataSource objectAtIndex:indexPath.row];
    [cell setUpSilverGoodsListData:_silverTraderModel discountStr:_discountStr];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SilverDetailPageVC *DetailPageVC = [[SilverDetailPageVC alloc] init];
    FindSilverTraderModel *_silverTraderModel = [self.dataSource objectAtIndex:indexPath.row];
    DetailPageVC.title = _silverTraderModel.name;
    DetailPageVC.url =  [NSString stringWithFormat:@"%@",_silverTraderModel.url];
    float newPrice = [_silverTraderModel.consumeSilver intValue] * [_discountStr floatValue] /10;
    int resultPrice = (int)ceilf(newPrice);
    
    DetailPageVC.consumeSilver = [NSString stringWithFormat:@"%d",resultPrice];
    DetailPageVC.idStr = _silverTraderModel.idStr;
    DetailPageVC.type = _silverTraderModel.type;
    DetailPageVC.nameStr = _silverTraderModel.name;
    DetailPageVC.stockNumber = _silverTraderModel.stock;
    //添加导航栏
    UITabBarController *control = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *VC=(UINavigationController *)control.selectedViewController;
    UIViewController *productVC=[VC topViewController];
    [productVC.navigationController pushViewController:DetailPageVC animated:YES];
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
