//
//  CouponShowRootVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CouponShowRootVC.h"
#import "CouponDetailView.h"
#import "PGBanner.h"
#import "BackRebateActivityModel.h"
#import "ProductDetailRebateCell.h"

@interface CouponShowRootVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CouponShowRootVC
{
    UIView *upLayerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *overlayView=[[UIView alloc] initWithFrame:self.view.frame];
    overlayView.backgroundColor=[UIColor clearColor];
    upLayerView=[[UIView alloc] initWithFrame:self.view.frame];
    upLayerView.backgroundColor=[UIColor blackColor];
    upLayerView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [upLayerView addGestureRecognizer:tap];
    upLayerView.alpha = 0.0;
    [overlayView addSubview:upLayerView];
    [self.view addSubview:overlayView];
    [UIView animateWithDuration:0.6 animations:^{
        upLayerView.alpha=0.5;
    }];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(15, [UIScreen mainScreen].bounds.size.height / 4, [UIScreen mainScreen].bounds.size.width - 30, [UIScreen mainScreen].bounds.size.height * 500 / 1336)];
    } else {
        _topView = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 10, [UIScreen mainScreen].bounds.size.height / 4, [UIScreen mainScreen].bounds.size.width - [UIScreen mainScreen].bounds.size.width / 10 * 2, [UIScreen mainScreen].bounds.size.height * 500 / 1336)];
    }
    _topView.backgroundColor = [UIColor whiteColor];
    _topView.layer.cornerRadius = 10;
    _topView.layer.masksToBounds = YES;
    _topView.alpha = 1;
    [overlayView addSubview:_topView];
    
    _tableView = [[UITableView alloc] init];
    
    CGRect frame = _tableView.frame;
    frame.size = CGSizeMake(_topView.frame.size.width - 30, [UIScreen mainScreen].bounds.size.height * 500 / 1336 );
    _tableView.frame = frame;
    
    CGPoint center = _tableView.center;
    center.x = self.topView.frame.size.width / 2;
    center.y = self.topView.frame.size.height / 2;
    _tableView.center = center;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    [_topView addSubview:_tableView];
    
    UIImageView *colseImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detailColseImage.png"]];
    [overlayView addSubview:colseImage];
    [colseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    
    // Do any additional setup after loading the view.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIScreen mainScreen].bounds.size.height * 500 / 1336 / 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _backRebateArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailRebateCell *cell;
    static NSString *identifier=@"rebateIdentifier";
    cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ProductDetailRebateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    BackRebateActivityModel *model = [self.backRebateArr objectAtIndex:indexPath.section];
    if (!model) {
        return nil;
    }
    [cell showProductDetailRebateList:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_backRebateArr.count == 2) {
        if (section == 0) {
            return ([UIScreen mainScreen].bounds.size.height * 500 / 1336 - [UIScreen mainScreen].bounds.size.height * 500 / 1336 / 4 * self.backRebateArr.count) / 5 * 2;
        }
        if (section == 1) {
            return ([UIScreen mainScreen].bounds.size.height * 500 / 1336 - [UIScreen mainScreen].bounds.size.height * 500 / 1336 / 4 * self.backRebateArr.count) / 5;
        }
    }
    return ([UIScreen mainScreen].bounds.size.height * 500 / 1336 - [UIScreen mainScreen].bounds.size.height * 500 / 1336 / 4 * self.backRebateArr.count) / (self.backRebateArr.count + 1);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    return headerView;
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0;
        upLayerView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromParentViewController];
    }];
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
