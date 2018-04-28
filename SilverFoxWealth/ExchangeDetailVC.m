//
//  ExchangeDetailVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/6/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ExchangeDetailVC.h"
#import "IncomeRecordVC.h"
#import "AllExchangeRecordVC.h"
#import "PayRecordVC.h"
#import "TopBottomBalckBorderView.h"
#import "HistoryExchangeRecordVC.h"
#import "UMMobClick/MobClick.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define titleWidth SCREEN_WIDTH/_titleArray.count
#define titleHeight 50
@interface ExchangeDetailVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *controllerArray;
@property (nonatomic, strong) UIButton *buttonOne;
@property (nonatomic, strong) UIButton *buttonTwo;
@property (nonatomic, strong) UIButton *buttonThree;
@property (nonatomic, strong) CustomerNavgationController *customNav;

@end

@implementation ExchangeDetailVC

{
    UIButton *selectButton;
    UIView *_sliderView;
    UIViewController *_viewController;
    UIScrollView *_scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    }
    _customNav.titleLabel.text = @"交易明细";
    self.title = @"交易明细";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    
    self.titleArray = @[@"全部",@"收入",@"支出"];
    
    AllExchangeRecordVC *oneVC = [[AllExchangeRecordVC alloc] init];
    IncomeRecordVC *twoVC = [[IncomeRecordVC alloc] init];
    PayRecordVC *threeVC = [[PayRecordVC alloc] init];
    self.controllerArray = @[oneVC,twoVC,threeVC];
    
    TopBottomBalckBorderView *bottomView = [[TopBottomBalckBorderView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@50);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"更多历史数据" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor zheJiangBusinessRedColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(clickMoreHistoryDataBT:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@49);
    }];
}

- (void)clickMoreHistoryDataBT:(UIButton *)sender
{
    [MobClick event:@"more_history_trade_record"];
    HistoryExchangeRecordVC *historyData = [[HistoryExchangeRecordVC alloc] init];
    [self.navigationController pushViewController:historyData animated:YES];
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
        titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
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
        if (i == 2) {
            _buttonThree = titleButton;
            _buttonThree.tag = 102;
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
    if ([_whereFrom intValue] == 2) {
        //滑块
        UIView *sliderV=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2, titleHeight-2, titleWidth, 2)];
        sliderV.backgroundColor = [UIColor zheJiangBusinessRedColor];
        [titleView addSubview:sliderV];
        _sliderView=sliderV;
        [self scrollViewSelectToIndex:_buttonThree];
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
    if ([_whereFrom intValue] == 2) {
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH * 2, 0);
    }
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

