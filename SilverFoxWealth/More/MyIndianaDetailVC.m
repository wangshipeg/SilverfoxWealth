//
//  MyIndianaDetailVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MyIndianaDetailVC.h"
#import "TopBlackLineView.h"
#import "DataRequest.h"
#import "UILabel+LabelStyle.h"
#import "IndianaRecordsModel.h"
#import "SilverClearCell.h"
#import "StringHelper.h"
#import "OneProductIndianaRecordVC.h"
#import "TopBottomBalckBorderAndArrowView.h"
#import "CommunalInfo.h"
#import "IndianaRuleVC.h"

@interface MyIndianaDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) TopBlackLineView *purchaseIndianaNumView;
@property (nonatomic, strong) NSString *indianaNum;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *randomStr;
@property (nonatomic, strong) UIView *viewAlpha;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) CustomerNavgationController *customNav;
////////////////////
////
@property (nonatomic, strong) UILabel *labelNumLB;
@property (nonatomic, strong) NSString *lotteryNum;
@end

@implementation MyIndianaDetailVC
{
    int page;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _customNav = [[CustomerNavgationController alloc] init];
    if (IS_iPhoneX) {
        _customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height);
    }else{
        _customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    }
    _customNav.titleLabel.text = @"我的夺宝";
    self.title = @"我的夺宝";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.view.backgroundColor = [UIColor backgroundGrayColor];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    _dataSource = [NSMutableArray array];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self achieveIndianaAData];
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    [self achieveAssetDataWith:user.customerId];
}

- (void)achieveAssetDataWith:(NSString *)customerId
{
    [[DataRequest sharedClient] MyIndianaDetailPagecustomerId:customerId goodsId:_idStr  callback:^(id obj) {
        DLog(@"我的夺宝详情页===%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] intValue] == 2000) {
                NSDictionary *dict = obj[@"data"];
                if (![dict isEqual:[NSNull null]]) {
                    _indianaNum = dict[@"joinCodes"];
                    [self UIDecorate];
                    
                    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:Wait_Time]];
                    [_viewAlpha removeFromSuperview];
                    [_imgView removeFromSuperview];
                }
            }else{
                DLog(@"我的夺宝详情页夺宝号码加载结果错误");
            }
        }
    }];
}

//我的夺宝 A值
- (void)achieveIndianaAData
{
    [[DataRequest sharedClient] MyIndianaAWithDetailPageGoodsId:_idStr callback:^(id obj) {
        DLog(@"我的夺宝详情页获取A值===%@",obj);
        if ([obj[@"code"] integerValue] == 2000) {
            NSDictionary *dict = obj[@"data"];
            if (![dict[@"random"] isEqual:[NSNull null]]) {
                _randomStr = dict[@"random"];
            }
        }else{
            DLog(@"我的夺宝详情页获取A值加载结果错误");
        }
        [self.tableView reloadData];
    }];
}

- (void)UIDecorate
{
    self.tableView=[[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.bounces = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNav.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator=NO;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSArray *NumArr = [_indianaNum componentsSeparatedByString:@","];
        if (NumArr.count % 4 == 0) {
            return 40 + 30 * (NumArr.count / 4);
        }else{
            return 40 + 30 * ((int)(NumArr.count / 4) + 1);
        }
    }
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        //将接口返回的夺宝字符串 切割成单个的夺宝号码 , 然后放进数组
        NSArray *NumArr = [_indianaNum componentsSeparatedByString:@","];
        //显示所有夺宝号码
        _purchaseIndianaNumView=[[TopBlackLineView alloc] init];
        _purchaseIndianaNumView.backgroundColor=[UIColor whiteColor];
        if (NumArr.count % 4 == 0) {
            _purchaseIndianaNumView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40 + 30 * (NumArr.count / 4));
        }else{
            _purchaseIndianaNumView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40 + 30 * ((int)(NumArr.count / 4) + 1));
        }
        [cell addSubview:_purchaseIndianaNumView];
        
        //已开奖才显示计算规则
        if ([_stock integerValue] <= [_joinNum integerValue]) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(_purchaseIndianaNumView.frame.size.width - 90, 0, 85, 45);
            button.titleLabel.textAlignment = NSTextAlignmentRight;
            [button setTitle:@"计算规则" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor iconBlueColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button addTarget:self action:@selector(handleRuleBT:) forControlEvents:UIControlEventTouchUpInside];
            [_purchaseIndianaNumView addSubview:button];
        }
        
        UILabel *numTextLB = [[UILabel alloc] init];
        numTextLB.frame = CGRectMake(15, 15, 80, 15);
        numTextLB.text = @"参与号码";
        numTextLB.font = [UIFont systemFontOfSize:16];
        numTextLB.textColor = [UIColor characterBlackColor];
        [_purchaseIndianaNumView addSubview:numTextLB];
        
        for (int i = 0; i < NumArr.count; i ++) {
            _labelNumLB = [[UILabel alloc] init];
            if ([UIScreen mainScreen].bounds.size.width == 320) {
                _labelNumLB.font = [UIFont systemFontOfSize:12];
            }else{
                _labelNumLB.font = [UIFont systemFontOfSize:14];
            }
            _labelNumLB.textAlignment = NSTextAlignmentCenter;
            _labelNumLB.textColor = [UIColor characterBlackColor];
            
            _labelNumLB.text = NumArr[i];
            if (i >= 4) {
                if (i % 4 == 0) {
                    _labelNumLB.frame = CGRectMake(15 + ((self.view.frame.size.width - 75) / 4  + 15) * (i % 4) , 40 + 30 * ((int)(i / 4)), (self.view.frame.size.width - 75) / 4, 30);
                }else{
                    _labelNumLB.frame = CGRectMake(15 + ((self.view.frame.size.width - 75) / 4  + 15) * (i % 4) , 40 + 30 * ((int)(i / 4)), (self.view.frame.size.width - 75) / 4, 30);
                }
            }else{
                _labelNumLB.frame = CGRectMake(15 + ((self.view.frame.size.width - 75) / 4  + 15) * i , 40, (self.view.frame.size.width - 75) / 4, 30);
            }
            
            [_purchaseIndianaNumView addSubview:_labelNumLB];
            //判断中奖号码是否存在购买号码中间, 如果存在则改变颜色
            NSString *lotteryNum = [NSString stringWithFormat:@"%lld",([_randomStr longLongValue] % [_joinNum integerValue] + 60000001)];
            if ([_labelNumLB.text isEqualToString:lotteryNum] && ([_stock integerValue] <= [_joinNum integerValue])) {
                _labelNumLB.textColor = [UIColor zheJiangBusinessRedColor];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        
        TopBottomBalckBorderAndArrowView *bottomView = [[TopBottomBalckBorderAndArrowView alloc] init];
        bottomView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left);
            make.height.equalTo(@40);
            make.top.equalTo(cell.mas_top);
            make.right.equalTo(cell.mas_right);
        }];
        
        UILabel *titleLB=[[UILabel alloc] init];
        [bottomView addSubview:titleLB];
        titleLB.text=@"夺宝记录";
        [titleLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(15);
            make.height.equalTo(@20);
            make.top.equalTo(cell.mas_top).offset(10);
            make.width.equalTo(@100);
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        OneProductIndianaRecordVC *recordVC = [[OneProductIndianaRecordVC alloc] init];
        recordVC.idStr = _idStr;
        [self.navigationController pushViewController:recordVC animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor typefaceGrayColor];
    NSArray *NumArr = [_indianaNum componentsSeparatedByString:@","];
    
    UILabel *labelTop = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 99.7)];
    labelTop.numberOfLines = 0;
    labelTop.backgroundColor = [UIColor backgroundGrayColor];
    labelTop.textAlignment = NSTextAlignmentCenter;
    
    if (_randomStr) {
        _lotteryNum = [NSString stringWithFormat:@"%lld",([_randomStr longLongValue] % [_joinNum integerValue] + 60000001)];
    }else{
        _lotteryNum = @"-----";
    }
    DLog(@"中奖号码%@",_lotteryNum);
    //如果是进行中的活动
    if ([_stock integerValue] > [_joinNum integerValue]) {
        labelTop.text = @"未开奖";
        labelTop.textColor = [UIColor characterBlackColor];
    }else{
        //如果是结束的活动 需要判断是否中奖
        for (int i = 0; i < NumArr.count; i ++) {
            if ([_lotteryNum isEqualToString:NumArr[i]]) {
                labelTop.attributedText = [StringHelper renderFrontAndAfterDifferentFontWithValue:@"开奖号码: " frontFont:16 frontColor:[UIColor characterBlackColor] afterStr:[NSString stringWithFormat:@"%@\n\n",_lotteryNum]  afterFont:16 afterColor:[UIColor zheJiangBusinessRedColor] lastStr:@"恭喜您此次夺宝中奖!" lastFont:14 lastColor:[UIColor zheJiangBusinessRedColor]];
                [self animateViewOfRound];
                break;
            }else{
                labelTop.attributedText = [StringHelper renderFrontAndAfterDifferentFontWithValue:@"开奖号码: " frontFont:16 frontColor:[UIColor characterBlackColor] afterStr:[NSString stringWithFormat:@"%@\n\n",_lotteryNum]  afterFont:16 afterColor:[UIColor zheJiangBusinessRedColor] lastStr:@"此次夺宝您未中奖 再接再厉!" lastFont:14 lastColor:[UIColor characterBlackColor]];
            }
        }
    }
    [view addSubview:labelTop];
    return view;
}

- (void)animateViewOfRound
{
    //判断当前程序是否是第一次运行，如果是第一次运行，显示夺宝成功图片
    NSUserDefaults *userDEfault = [NSUserDefaults standardUserDefaults];
    //用id作为唯一标识...
    if ([userDEfault boolForKey:_idStr] == NO) {
        //如果取出来的值为NO，说明为第一次启动，
        [self setUpUIScrollViewAndPageControl];
        //将该标志改为Yes
        [userDEfault setBool:YES forKey:_idStr];
    }
}

- (void)setUpUIScrollViewAndPageControl
{
    _viewAlpha = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _viewAlpha.backgroundColor = [UIColor characterBlackColor];
    _viewAlpha.alpha = .7;
    [self.view addSubview:_viewAlpha];
    _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"弹窗.png"]];
    _imgView.center = CGPointMake(_viewAlpha.bounds.size.width / 2, self.view.bounds.size.height / 2 - 70);
    [self.view addSubview:_imgView];
}

- (void)handleRuleBT:(UIButton *)sender
{
    IndianaRuleVC *ruleVC = [[IndianaRuleVC alloc] init];
    ruleVC.idStr = _idStr;
    [self.navigationController pushViewController:ruleVC animated:YES];
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

