//
//  EarnSilverVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/6/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "EarnSilverVC.h"
#import "EarnSilverCell.h"
#import "UILabel+LabelStyle.h"
#import "DataRequest.h"
#import "EarnSilversModel.h"
#import "SIgnInVC.h"
#import "ProductVC.h"
#import "EncryptHelper.h"
#import "ShareConfig.h"
#import "HTMLVC.h"
#import "ShareEarnSilversVC.h"
#import "VCAppearManager.h"

@interface EarnSilverVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EarnSilversModel *model;
@property (nonatomic, strong) NSMutableArray *oneOffDataSource;
@property (nonatomic, strong) NSMutableArray *everydayDataSource;
@property (nonatomic, strong) NSString *shareStr;
@property (nonatomic, strong) UIView *backContentView;
@property (nonatomic, strong) CustomerNavgationController *customNav;

@end

@implementation EarnSilverVC

{
    int num;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _customNav = [[CustomerNavgationController alloc] init];
    if (IS_iPhoneX) {
        _customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height);
    }else{
        _customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    }
    _customNav.titleLabel.text = @"赚银子";
    self.title = @"赚银子";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.view.backgroundColor = [UIColor backgroundGrayColor];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets=YES;
    
    [self achieveAssetDataWith];
}

-(void)achieveAssetDataWith {
    [[DataRequest sharedClient] silverTraderEarnSilverCallback:^(id obj) {
        DLog(@"银子商城赚银子加载结果======%@",obj);
        if (!obj) {
            [self withoutDataView];
            return;
        }
        [self UIDecorate];
        if ([obj isKindOfClass:[NSArray class]]) {
            [self clearBackContentViewSubView];
            [self.dataSource addObjectsFromArray:obj];
            for (id data in self.dataSource) {
                if ([data isKindOfClass:[EarnSilversModel class]]) {
                    _model = data;
                    if ([_model.type isEqual: @"1"]) {
                        [self.oneOffDataSource addObject:_model];
                    }
                    if ([_model.type isEqual: @"2"]) {
                        [self.everydayDataSource addObject:_model];
                    }
                }
            }
            [self.tableView reloadData];
        }
        
        if ([obj isKindOfClass:[NSError class]]) {
            [self withoutDataView];
        }
    }];
}

- (void)clearBackContentViewSubView {
    if ([_backContentView subviews] != 0) {
        for (UIView *vi in [_backContentView subviews]) {
            [vi removeFromSuperview];
        }
        [self.view sendSubviewToBack:_backContentView];
    }
    _backContentView.hidden = YES;
}

- (void)withoutDataView
{
    [VCAppearManager arrengmentNotDataViewWithSuperView:_backContentView title:@"土豪，暂无任务哦!"];
    [self.view bringSubviewToFront:_backContentView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ((self.oneOffDataSource.count == 0) && (self.everydayDataSource.count != 0))
    {
        return 1;
    }
    if ((self.oneOffDataSource.count != 0) && (self.everydayDataSource.count == 0))
    {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ((self.oneOffDataSource.count == 0) && (self.everydayDataSource.count != 0)) {
        return self.everydayDataSource.count;
    }
    if ((self.oneOffDataSource.count != 0) && (self.everydayDataSource.count == 0)) {
        return self.oneOffDataSource.count;
    }
    if (section == 0) {
        return self.oneOffDataSource.count;
    }
    return self.everydayDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((self.oneOffDataSource.count == 0) && (self.everydayDataSource.count != 0)) {
        EarnSilversModel *model = [self.everydayDataSource objectAtIndex:indexPath.row];
        if (!model) {
            return nil;
        }
        if (model.shareContent.length != 0) {
            _shareStr = model.shareContent;
        }
        
        static NSString *identifier = @"changer";
        EarnSilverCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[EarnSilverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell showEarnSilversDataWithDic:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //点击做任务按钮回调事件
        [cell plcyTaskBlock:^{
            if ([cell.playTaskBT.titleLabel.text isEqualToString:@"去签到"]) {
                DLog(@"跳转签到页面");
                [MobClick event:@"earn_silver_go_sign"];
                IndividualInfoManage *user = [IndividualInfoManage currentAccount];
                //如果已经登录
                if (user)
                {
                    SIgnInVC *signInVC = [[SIgnInVC alloc] init];
                    [self.navigationController pushViewController:signInVC animated:YES];
                }else{
                    [VCAppearManager presentLoginVCWithCurrentVC:self];
                }
                return;
            }
            if ([cell.playTaskBT.titleLabel.text isEqualToString:@"去分享"]) {
                DLog(@"弹出分享页面");
                [MobClick event:@"earn_silver_share"];
                IndividualInfoManage *user = [IndividualInfoManage currentAccount];
                //如果已经登录
                if (user)
                {
                    ShareEarnSilversVC *shareVC = [[ShareEarnSilversVC alloc] init];
                    shareVC.shareModel = model;
                    [self.navigationController pushViewController:shareVC animated:YES];
                } else {
                    [VCAppearManager presentLoginVCWithCurrentVC:self];
                }
                return;
            }
            if ([cell.playTaskBT.titleLabel.text isEqualToString:@"去投资"]) {
                DLog(@"跳转到产品列表页面");
                [MobClick event:@"earn_silver_invest"];
                ProductVC *productVC = [[ProductVC alloc] init];
                [self.navigationController pushViewController:productVC animated:YES];
                return;
            }
        }];
        return cell;
    }
    if ((self.oneOffDataSource.count != 0) && (self.everydayDataSource.count == 0)) {
        EarnSilversModel *model = [self.oneOffDataSource objectAtIndex:indexPath.row];
        if (!model) {
            return nil;
        }
        
        static NSString *identifier = @"changer";
        EarnSilverCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell=[[EarnSilverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell showEarnSilversDataWithDic:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //点击做任务按钮回调事件
        [cell plcyTaskBlock:^{
            if ([cell.playTaskBT.titleLabel.text isEqualToString:@"做任务"]) {
                DLog(@"跳转到问卷调查页面");
                HTMLVC *html = [[HTMLVC alloc] init];
                html.questionnaire = model.address;
                [self.navigationController pushViewController:html animated:YES];
                return;
            }
        }];
        return cell;
    }
    
    if ((self.oneOffDataSource.count != 0) && (self.everydayDataSource.count != 0)) {
        if (indexPath.section == 0) {
            EarnSilversModel *model=[self.oneOffDataSource objectAtIndex:indexPath.row];
            if (!model) {
                return nil;
            }
            static NSString *identifier=@"changer";
            EarnSilverCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell=[[EarnSilverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            [cell showEarnSilversDataWithDic:model];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //点击做任务按钮回调事件
            [cell plcyTaskBlock:^{
                if ([cell.playTaskBT.titleLabel.text isEqualToString:@"做任务"]) {
                    DLog(@"跳转到问卷调查页面");
                    HTMLVC *html = [[HTMLVC alloc] init];
                    html.questionnaire = model.address;
                    [self.navigationController pushViewController:html animated:YES];
                    return;
                }
            }];
            
            return cell;
        }
        if (indexPath.section == 1) {
            EarnSilversModel *model=[self.everydayDataSource objectAtIndex:indexPath.row];
            if (!model) {
                return nil;
            }
            if (model.shareContent.length != 0) {
                _shareStr = model.shareContent;
            }
            
            static NSString *identifier=@"changer";
            EarnSilverCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell=[[EarnSilverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            [cell showEarnSilversDataWithDic:model];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //点击做任务按钮回调事件
            [cell plcyTaskBlock:^{
                if ([cell.playTaskBT.titleLabel.text isEqualToString:@"去签到"]) {
                    DLog(@"跳转签到页面");
                    [MobClick event:@"earn_silver_go_sign"];
                    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
                    //如果已经登录
                    if (user)
                    {
                        SIgnInVC *signInVC = [[SIgnInVC alloc] init];
                        [self.navigationController pushViewController:signInVC animated:YES];
                    }else{
                        [VCAppearManager presentLoginVCWithCurrentVC:self];
                    }
                    return;
                }
                if ([cell.playTaskBT.titleLabel.text isEqualToString:@"去分享"]) {
                    DLog(@"弹出分享页面");
                    [MobClick event:@"earn_silver_go_share"];
                    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
                    if (user)
                    {
                        ShareEarnSilversVC *shareVC = [[ShareEarnSilversVC alloc] init];
                        shareVC.shareModel = model;
                        [self.navigationController pushViewController:shareVC animated:YES];
                    }else{
                        [VCAppearManager presentLoginVCWithCurrentVC:self];
                    }
                    return;
                }
                if ([cell.playTaskBT.titleLabel.text isEqualToString:@"去投资"]) {
                    DLog(@"跳转到产品列表页面");
                    [MobClick event:@"earn_silver_invest"];
                    ProductVC *productVC = [[ProductVC alloc] init];
                    [self.navigationController pushViewController:productVC animated:YES];
                    return;
                }
            }];
            return cell;
        }
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CustomerSeparateTableViewCell *view=[[CustomerSeparateTableViewCell alloc] init];
    view.backgroundColor=[UIColor backgroundGrayColor];
    
    UILabel *titleLB=[[UILabel alloc] init];
    [view addSubview:titleLB];
    [titleLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:14] characterColor:[UIColor characterBlackColor]];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.height.equalTo(@20);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@100);
    }];
    if ((self.oneOffDataSource.count == 0) && (self.everydayDataSource.count != 0)) {
        titleLB.text=@"每日任务";
    }
    if ((self.oneOffDataSource.count != 0) && (self.everydayDataSource.count == 0)) {
        titleLB.text=@"一般任务";
    }
    if ((self.oneOffDataSource.count != 0) && (self.everydayDataSource.count != 0)) {
        if (section == 0) {
            titleLB.text=@"一般任务";
        }
        if (section == 1) {
            titleLB.text=@"每日任务";
        }
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)UIDecorate
{
    self.dataSource = [NSMutableArray array];
    self.oneOffDataSource = [NSMutableArray array];
    self.everydayDataSource = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNav.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    _backContentView = [[UIView alloc] init];
    [self.view addSubview:_backContentView];
    _backContentView.backgroundColor = [UIColor clearColor];
    [_backContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
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

