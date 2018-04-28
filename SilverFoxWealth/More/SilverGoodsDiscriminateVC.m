//
//  SilverGoodsDiscriminateVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/12/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "SilverGoodsDiscriminateVC.h"
#import "ConditionChangeVC.h"
#import "HotGoodsVC.h"
#import "DataRequest.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define titleWidth SCREEN_WIDTH/_titleArray.count
#define titleHeight 50

@interface SilverGoodsDiscriminateVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *controllerArray;
@property (nonatomic, strong) UIButton *buttonOne;
@property (nonatomic, strong) UIButton *buttonTwo;
@property (nonatomic, strong) HotGoodsVC *twoVC;
@property (nonatomic, strong) ConditionChangeVC *oneVC;

@end

@implementation SilverGoodsDiscriminateVC
{
    UIButton *selectButton;
    UIView *_sliderView;
    UIViewController *_viewController;
    UIScrollView *_scrollView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self achieveVipInsterestNum];
}

- (void)achieveVipInsterestNum {
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [[DataRequest sharedClient]requestProductDetailAndSilverStoreCouponWithCustomerId:user.customerId type:@"6" callback:^(id obj) {
        DLog(@"银子商城折扣=====%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = obj;
            NSString *discountStr = dict[@"data"];
            
            _twoVC.discountStr = discountStr;
            _oneVC.discountStr = discountStr;
        }
        [self sendMessageToCouponsListDataRequest];
    }];
}

- (void)sendMessageToCouponsListDataRequest{
    NSNotificationCenter *messageCenter=[NSNotificationCenter  defaultCenter];
    [messageCenter postNotificationName:@"goodsStore" object:Nil userInfo:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    CustomerNavgationController *customNav = [[CustomerNavgationController alloc] init];
    if (IS_iPhoneX) {
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height);
    }else{
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    }
    customNav.titleLabel.text = @"银子商城";
    self.title = @"银子商城";
    [self.view addSubview:customNav];
    __weak typeof (self) weakSelf = self;
    customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.titleArray = @[@"尖货",@"热门"];
    
    _oneVC = [[ConditionChangeVC alloc] init];
    _oneVC.dataSource = _isHaveMutArr;
    _twoVC = [[HotGoodsVC alloc] init];
    _twoVC.dataSource = _noHaveMutArr;
    self.controllerArray = @[_oneVC,_twoVC];
    

}



- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    [self initWithTitleButton];
}

- (void)setControllerArray:(NSArray *)controllerArray {
    _controllerArray = controllerArray;
    [self initWithController];
}

- (void)initWithTitleButton
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, titleHeight)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    
    if (IS_iPhoneX) {
        titleView.frame = CGRectMake(0, iPhoneX_Navigition_Bar_Height, SCREEN_WIDTH, titleHeight);
    } else {
        titleView.frame = CGRectMake(0, 64, SCREEN_WIDTH, titleHeight);
    }
    
    for (int i = 0; i < _titleArray.count; i++) {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.frame = CGRectMake(titleWidth*i, 0, titleWidth, titleHeight);
        [titleButton setTitle:_titleArray[i] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor characterBlackColor] forState:UIControlStateNormal];
        titleButton.tag = 100 + i;
        [titleButton addTarget:self action:@selector(scrollViewSelectToIndex:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:titleButton];
        if (i == 0) {
            _buttonOne = titleButton;
            _buttonOne.tag = 100;
        }
        if (i == 1) {
            _buttonTwo = titleButton;
            _buttonTwo.tag = 101;
        }
        
        if (i == [_whereFrom intValue]) {
            selectButton = titleButton;
            [selectButton setTitleColor:[UIColor zheJiangBusinessRedColor] forState:UIControlStateNormal];
        }
        if (!_buttonArray) {
            _buttonArray = [NSMutableArray array];
        }
        [_buttonArray addObject:titleButton];
    }
    if ([_whereFrom intValue] == 0) {
        //滑块
        UIView *sliderV=[[UIView alloc]initWithFrame:CGRectMake(0, titleHeight-2, titleWidth, 2)];
        sliderV.backgroundColor = [UIColor zheJiangBusinessRedColor];
        [titleView addSubview:sliderV];
        _sliderView=sliderV;
        [self scrollViewSelectToIndex:_buttonOne];
    }
    if ([_whereFrom intValue] == 1) {
        //滑块
        UIView *sliderV=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2, titleHeight-2, titleWidth, 2)];
        sliderV.backgroundColor = [UIColor zheJiangBusinessRedColor];
        [titleView addSubview:sliderV];
        _sliderView=sliderV;
        [self scrollViewSelectToIndex:_buttonTwo];
    }
}

- (void)scrollViewSelectToIndex:(UIButton *)button
{
    [self selectButton:button.tag - 100];
    [UIView animateWithDuration:0 animations:^{
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH*(button.tag - 100), 0);
    }];
}

//选择某个标题
- (void)selectButton:(NSInteger)index
{
    [selectButton setTitleColor:[UIColor characterBlackColor] forState:UIControlStateNormal];
    selectButton = _buttonArray[index];
    [selectButton setTitleColor:[UIColor zheJiangBusinessRedColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        _sliderView.frame = CGRectMake(_scrollView.contentOffset.x / _titleArray.count, titleHeight-2, titleWidth, 2);
    }];
}

//监听滚动事件判断当前拖动到哪一个了
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
    [self selectButton:index];
}

- (void)initWithController
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (IS_iPhoneX) {
        scrollView.frame = CGRectMake(0, titleHeight + iPhoneX_Navigition_Bar_Height, SCREEN_WIDTH, SCREEN_HEIGHT- titleHeight);
    }else{
        scrollView.frame = CGRectMake(0, titleHeight + 64, SCREEN_WIDTH, SCREEN_HEIGHT- titleHeight);
    }
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor backgroundGrayColor];
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * _controllerArray.count, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    for (int i = 0; i < _controllerArray.count; i++) {
        UIView *viewcon = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        UIViewController *viewcontroller = _controllerArray[i];
        viewcon = viewcontroller.view;
        viewcon.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [scrollView addSubview:viewcon];
    }
    
    if ([_whereFrom intValue] == 0) {
        _scrollView.contentOffset = CGPointMake(0, 0);
    }
    if ([_whereFrom intValue] == 1) {
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end




