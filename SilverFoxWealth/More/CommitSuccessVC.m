//
//  CommitSuccessVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CommitSuccessVC.h"
#import "StringHelper.h"
#import "TopBottomBalckBorderView.h"
#import "RoundCornerClickBT.h"
#import "ZeroMoneyIndianaVC.h"
#import "AddCancelButton.h"

@interface CommitSuccessVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) TopBottomBalckBorderView *purchaseIndianaNumView;
@property (nonatomic, strong) RoundCornerClickBT *commitBT;
@property (nonatomic, strong) UITableView *tableView;


@end

@implementation CommitSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
    
    // Do any additional setup after loading the view.
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
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        //将接口返回的夺宝字符串 切割成单个的夺宝号码 , 然后放进数组
        NSArray *NumArr = [_indianaNum componentsSeparatedByString:@","];
        //显示所有夺宝号码
        _purchaseIndianaNumView=[[TopBottomBalckBorderView alloc] init];
        _purchaseIndianaNumView.backgroundColor=[UIColor whiteColor];
        if (NumArr.count % 4 == 0) {
            _purchaseIndianaNumView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40 + 30 * (NumArr.count / 4));
        }else{
            _purchaseIndianaNumView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40 + 30 * ((int)(NumArr.count / 4) + 1));
        }
        [cell addSubview:_purchaseIndianaNumView];
        
        UILabel *numTextLB = [[UILabel alloc] init];
        numTextLB.frame = CGRectMake(15, 15, 80, 15);
        numTextLB.text = @"参与号码";
        numTextLB.font = [UIFont systemFontOfSize:14];
        numTextLB.textColor = [UIColor characterBlackColor];
        [_purchaseIndianaNumView addSubview:numTextLB];
        
        for (int i = 0; i < NumArr.count; i ++) {
            UILabel *labelNumLB = [[UILabel alloc] init];
            if ([UIScreen mainScreen].bounds.size.width == 320) {
                labelNumLB.font = [UIFont systemFontOfSize:13];
            }else{
                labelNumLB.font = [UIFont systemFontOfSize:14];
            }
            labelNumLB.textAlignment = NSTextAlignmentCenter;
            labelNumLB.textColor = [UIColor characterBlackColor];
            labelNumLB.text = NumArr[i];
            if (i >= 4) {
                if (i % 4 == 0) {
                    labelNumLB.frame = CGRectMake(15 + ((self.view.frame.size.width - 75) / 4  + 15) * (i % 4) , 40 + 30 * ((int)(i / 4)), (self.view.frame.size.width - 75) / 4, 30);
                }else{
                    labelNumLB.frame = CGRectMake(15 + ((self.view.frame.size.width - 75) / 4  + 15) * (i % 4) , 40 + 30 * ((int)(i / 4)), (self.view.frame.size.width - 75) / 4, 30);
                }
            }else{
                labelNumLB.frame = CGRectMake(15 + ((self.view.frame.size.width - 75) / 4  + 15) * i , 40, (self.view.frame.size.width - 75) / 4, 30);
            }
            [_purchaseIndianaNumView addSubview:labelNumLB];
        }
        return cell;
    }
    if (indexPath.row == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        //提交按钮
        _commitBT = [RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
        [cell addSubview:_commitBT];
        [_commitBT setTitle:@"继续夺宝" forState:UIControlStateNormal];
        [_commitBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitBT addTarget:self action:@selector(handleCommitBT) forControlEvents:UIControlEventTouchUpInside];
        _commitBT.backgroundColor = [UIColor zheJiangBusinessRedColor];
        [_commitBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(43);
            make.centerY.equalTo(cell.mas_centerY);
            make.height.equalTo(@45);
            make.right.equalTo(cell.mas_right).offset(-43);
        }];
        return cell;
    }
    return nil;
}


- (void)UIDecorate
{
    CustomerNavgationController *customNav = [[CustomerNavgationController alloc] init];
    UILabel *labelTop = [[UILabel alloc] init];
    if (IS_iPhoneX) {
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
        labelTop.frame = CGRectMake(0, iPhoneX_Navigition_Bar_Height, self.view.frame.size.width, 55);
    }else{
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
        labelTop.frame = CGRectMake(0, 64, self.view.frame.size.width, 55);
    }
    customNav.titleLabel.text = @"我的夺宝";
    self.title = @"我的夺宝";
    [self.view addSubview:customNav];
    __weak typeof (self) weakSelf = self;
    customNav.leftViewController = ^{
        [weakSelf handleCommitBT];
    };
    self.view.backgroundColor = [UIColor backgroundGrayColor];
    
    labelTop.textAlignment = NSTextAlignmentCenter;
    labelTop.attributedText = [StringHelper renderFrontAndAfterDifferentFontWithValue:@"您已成功参与夺宝" frontFont:16 frontColor:[UIColor characterBlackColor] afterStr:_indianaTimesStr  afterFont:16 afterColor:[UIColor zheJiangBusinessRedColor] lastStr:@"次" lastFont:16 lastColor:[UIColor characterBlackColor]];
    [self.view addSubview:labelTop];
    //
    self.tableView=[[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelTop.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator=NO;
}



//返回0元夺宝界面
- (void)handleCommitBT
{
    UIViewController *target = nil;
    for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
        if ([controller isKindOfClass:[ZeroMoneyIndianaVC class]]) { //这里判断是否为你想要跳转的页面
            target = controller;
        }
    }
    if (target) {
        [self.navigationController popToViewController:target animated:YES]; //跳转
    }
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

