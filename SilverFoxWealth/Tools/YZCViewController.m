

#import "YZCViewController.h"
#import "UMMobClick/MobClick.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define titleWidth SCREEN_WIDTH/_titleArray.count
#define titleHeight 50

@interface YZCViewController ()<UIScrollViewDelegate>
{
    UIButton *selectButton;
    UIView *_sliderView;
    UIViewController *_viewController;
    UIScrollView *_scrollView;
}
@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation YZCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _buttonArray = [NSMutableArray array];
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
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor whiteColor];
    if (IS_iPhoneX) {
        titleView.frame = CGRectMake(0, 88, SCREEN_WIDTH, titleHeight);
    } else {
        titleView.frame = CGRectMake(0, 64, SCREEN_WIDTH, titleHeight);
    }
    [self.view addSubview:titleView];
    for (int i = 0; i < _titleArray.count; i++) {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.titleLabel.numberOfLines = 0;
        if (self.tabBarHeight == 64) {
            titleButton.frame = CGRectMake(titleWidth*i, 0, titleWidth, 64);
            [titleButton setTitle:[NSString stringWithFormat:@"\n%@",_titleArray[i]] forState:UIControlStateNormal];
        }else{
            titleButton.frame = CGRectMake(titleWidth*i, 0, titleWidth, titleHeight);
            [titleButton setTitle:[NSString stringWithFormat:@"%@",_titleArray[i]] forState:UIControlStateNormal];
        }
        [titleButton setTitleColor:[UIColor characterBlackColor] forState:UIControlStateNormal];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:16];
        titleButton.tag = 100+i;
        [titleButton addTarget:self action:@selector(scrollViewSelectToIndex:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:titleButton];
        if (i == 0) {
            selectButton = titleButton;
            [selectButton setTitleColor:[UIColor zheJiangBusinessRedColor] forState:UIControlStateNormal];
        }
        [_buttonArray addObject:titleButton];
    }
    NSInteger height;
    //滑块
    if (self.tabBarHeight == 64) {
        height = 64;
    } else {
        height = 50;
    }
    UIView *sliderV=[[UIView alloc]initWithFrame:CGRectMake(15, height - 2, titleWidth - 30, 2)];
    sliderV.backgroundColor = [UIColor zheJiangBusinessRedColor];
    [titleView addSubview:sliderV];
    _sliderView=sliderV;
}

- (void)scrollViewSelectToIndex:(UIButton *)button
{
    if (button.tag == 100) {
        [MobClick event:@"message_0"];
    }
    if (button.tag == 101) {
        [MobClick event:@"message_1"];
    }
    [self selectButton:button.tag - 100];
    [UIView animateWithDuration:0 animations:^{
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH*(button.tag-100), 0);
    }];
}

//选择某个标题
- (void)selectButton:(NSInteger)index
{
    [selectButton setTitleColor:[UIColor characterBlackColor] forState:UIControlStateNormal];
    selectButton = _buttonArray[index];
    [selectButton setTitleColor:[UIColor zheJiangBusinessRedColor] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        if (IS_iPhoneX) {
            _sliderView.frame = CGRectMake(_scrollView.contentOffset.x / _titleArray.count + 15, titleHeight - 2, titleWidth - 30, 2);
        }else{
            _sliderView.frame = CGRectMake(_scrollView.contentOffset.x / _titleArray.count + 15, titleHeight-2, titleWidth - 30, 2);
        }
    }];
}

//监听滚动事件判断当前拖动到哪一个了
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSInteger index = scrollView.contentOffset.x / SCREEN_WIDTH;
    [self selectButton:index];
}

- (void)initWithController
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (IS_iPhoneX) {
        scrollView.frame = CGRectMake(0, titleHeight + iPhoneX_Navigition_Bar_Height, SCREEN_WIDTH, SCREEN_HEIGHT - iPhoneX_Navigition_Bar_Height);
    } else {
        scrollView.frame = CGRectMake(0, titleHeight + 64, SCREEN_WIDTH, SCREEN_HEIGHT-titleHeight);
    }
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor colorWithWhite:0.900 alpha:1.000];
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
        viewcon.frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [scrollView addSubview:viewcon];
    }
}

@end

