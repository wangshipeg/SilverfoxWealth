//
//  HistoryExchangeRecordVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/6/30.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HistoryExchangeRecordVC.h"
#import "HistoryAllExchangeRecordVC.h"
#import "HistoryIncomeRecordVC.h"
#import "HistoryPayRecordVC.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define titleWidth SCREEN_WIDTH/_titleArray.count
#define titleHeight 50
@interface HistoryExchangeRecordVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *controllerArray;
@property (nonatomic, strong) UIButton *buttonOne;
@property (nonatomic, strong) UIButton *buttonTwo;
@property (nonatomic, strong) UIButton *buttonThree;
@property (nonatomic, strong) CustomerNavgationController *customNav;
@end

@implementation HistoryExchangeRecordVC

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
    _customNav.titleLabel.text = @"历史数据";
    self.title = @"历史数据";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.titleArray = @[@"全部",@"收入",@"支出"];
    
    HistoryAllExchangeRecordVC *oneVC = [[HistoryAllExchangeRecordVC alloc] init];
    HistoryIncomeRecordVC *twoVC = [[HistoryIncomeRecordVC alloc] init];
    HistoryPayRecordVC *threeVC = [[HistoryPayRecordVC alloc] init];
    self.controllerArray = @[oneVC,twoVC,threeVC];
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
        
        if (!_buttonArray) {
            _buttonArray = [NSMutableArray array];
        }
        [_buttonArray addObject:titleButton];
    }
    //滑块
    UIView *sliderV=[[UIView alloc]initWithFrame:CGRectMake(0, titleHeight-2, titleWidth, 2)];
    sliderV.backgroundColor = [UIColor zheJiangBusinessRedColor];
    [titleView addSubview:sliderV];
    _sliderView=sliderV;
    [self scrollViewSelectToIndex:_buttonOne];
    
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

