//
//  FeedBackVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/4/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "FeedBackVC.h"
#import "DataRequest.h"
#import "CommunalInfo.h"
#import "DeviceHelper.h"
#import "AddCancelButton.h"
#import <SVProgressHUD.h>
#import "PromptLanguage.h"
#import "RoundCornerClickBT.h"
#import "FastAnimationAdd.h"
#import "CustomerTopAndBottomSeparateLineCell.h"

#define TextViewDefaultText @"您对我们有什么建议或者意见......"

@interface FeedBackVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITextView *contentTV;
@property (strong, nonatomic) UITextField *connectionTF;
@property (strong, nonatomic) RoundCornerClickBT *commitBT;
@property (nonatomic, strong) CustomerNavgationController *customNav;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation FeedBackVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
}

- (void)UIDecorate {
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"意见反馈";
    self.title = @"意见反馈";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.tableView = [[UITableView alloc] init];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor backgroundGrayColor];
    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNav.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor=[UIColor backgroundGrayColor];
    self.tableView.allowsSelection=NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    
    //反馈内容
    _contentTV=[[UITextView alloc] init];
    _contentTV.delegate=self;
    _contentTV.font=[UIFont systemFontOfSize:15];
    _contentTV.text=TextViewDefaultText;
    _contentTV.textColor=[UIColor typefaceGrayColor];
    UIView *contentTVDis=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(contentTVNextStep) title:@"下一项"];
    [_contentTV setInputAccessoryView:contentTVDis];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectionContentTVText:) name:UITextViewTextDidChangeNotification object:nil];
    
    //联系方式
    _connectionTF=[[UITextField alloc] init];
    _connectionTF.delegate=self;
    _connectionTF.placeholder=@"您可以留下手机号或者邮箱，方便我们联系到您！";
    _connectionTF.font=[UIFont systemFontOfSize:13];
    UIView *connectionTFDis=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(connectionTFResponder) title:@"完成"];
    [self.connectionTF setInputAccessoryView:connectionTFDis];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectionconnectionTFText:) name:UITextFieldTextDidChangeNotification object:nil];
    
    //提交按钮
    _commitBT=[RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [_commitBT setTitle:@"提交" forState:UIControlStateNormal];
    _commitBT.titleLabel.font=[UIFont systemFontOfSize:16];
    _commitBT.backgroundColor=[UIColor typefaceGrayColor];
    _commitBT.userInteractionEnabled=NO;
    [FastAnimationAdd codeBindAnimation:_commitBT];
    [_commitBT addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView reloadData];
}

- (void)contentTVNextStep {
    [self.connectionTF becomeFirstResponder];
    [self detectionUserInpute];
}
- (void)connectionTFResponder
{
    [self.connectionTF resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (!_contentTV) {
        return 0;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!_contentTV) {
        return 0;
    }
    
    if (section==0) {
        return 1;
    }
    
    if (section==1) {
        return 2;
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!_contentTV) {
        return nil;
    }
    
    if (indexPath.section==0) {
        CustomerTopAndBottomSeparateLineCell *cell=[[CustomerTopAndBottomSeparateLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell addSubview:_contentTV];
        [_contentTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top).offset(5);
            make.bottom.equalTo(cell.mas_bottom).offset(-5);
            make.left.equalTo(cell.mas_left).offset(8);
            make.right.equalTo(cell.mas_right).offset(-8);
        }];
        
        return cell;
    }
    
    if (indexPath.section==1) {
        
        if (indexPath.row==0) {
            CustomerTopAndBottomSeparateLineCell *cell=[[CustomerTopAndBottomSeparateLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            [cell addSubview:_connectionTF];
            [_connectionTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).offset(5);
                make.bottom.equalTo(cell.mas_bottom).offset(-5);
                make.left.equalTo(cell.mas_left).offset(10);
                make.right.equalTo(cell.mas_right).offset(-10);
            }];
            return cell;
        }
        
        if (indexPath.row==1) {
            
            UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.backgroundColor=[UIColor backgroundGrayColor];
            [cell addSubview:_commitBT];
            [_commitBT mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).offset(30);
                make.height.equalTo(@45);
                make.left.equalTo(cell.mas_left).offset(43);
                make.right.equalTo(cell.mas_right).offset(-43);
            }];
            
            return cell;
        }
        
    }
    
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        return 180;
    }
    
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            return 60;
        }
        
        if (indexPath.row==1) {
            return 150;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (!_contentTV) {
        return 0;
    }
    
    if (section==1) {
        return 30;
    }
    return 0;
}

#pragma -mark TextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:TextViewDefaultText]) {
        textView.text = nil;
    }
    textView.textColor = [UIColor characterBlackColor];
    [self detectionUserInpute];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (range.location >= 140) {
        return NO;
    }
    return YES;
}


#pragma -mark textFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (range.location>30) {
        return NO;
    }
    return YES;
}



- (void)commit:(UIButton *)sender {
    
    //    [sender clickDelay];
    
    [self.contentTV resignFirstResponder];
    [self.connectionTF resignFirstResponder];
    
    if (self.contentTV.text.length==0||[self.contentTV.text isEqualToString:TextViewDefaultText]) {
        [SVProgressHUD showErrorWithStatus:@"反馈内容不能为空！"];
        return;
    }
    
    NSString *connectionStr=self.connectionTF.text;
    if (connectionStr.length==0) {
        IndividualInfoManage *user=[IndividualInfoManage currentAccount];
        if (user) {
            connectionStr=user.cellphone;
        }
    }
    NSString *contentTVStr=self.contentTV.text;
    
    //手机型号
    NSString *phoneModeStr=[DeviceHelper deviceType];
    NSString *deviceVersionStr=[UIDevice currentDevice].systemVersion;
    NSString *appVersionStr=[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    
    [[DataRequest sharedClient] ideaFeedbackWithContent:contentTVStr contact:connectionStr phoneModel:phoneModeStr deviceVersion:deviceVersionStr  appVersion:appVersionStr callback:^(id obj) {
        DLog(@"反馈结果===%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = obj;
            if ([dic[@"code"] intValue] == 2000) {
                [self contentTextViewReset];
                [SVProgressHUD showSuccessWithStatus:IdeaFeedbackForSucceed];
                [[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:Wait_Time]];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
            }
        }
        if ([obj isKindOfClass:[NSError class]]) {
            [SVProgressHUD showErrorWithStatus:FeedBackFail];
        }
    }];
}


- (void)contentTextViewReset {
    self.contentTV.text=nil;
    self.contentTV.text=TextViewDefaultText;
    self.contentTV.textColor=[UIColor typefaceGrayColor];
    [self detectionUserInpute];
}


- (void)detectionUserInpute {
    
    if (self.contentTV.text.length==0||[self.contentTV.text isEqualToString:TextViewDefaultText]) {
        self.commitBT.userInteractionEnabled=NO;
        self.commitBT.backgroundColor=[UIColor typefaceGrayColor];
    }else {
        self.commitBT.userInteractionEnabled=YES;
        self.commitBT.backgroundColor=[UIColor zheJiangBusinessRedColor];
    }
}

- (void)detectionContentTVText:(NSNotification *)note {
    if (self.contentTV.text.length > 140) {
        self.contentTV.text=[self.contentTV.text substringToIndex:140];
    }
    [self detectionUserInpute];
}

- (void)detectionconnectionTFText:(NSNotification *)note {
    if (self.connectionTF.text.length > 30) {
        self.connectionTF.text=[self.connectionTF.text substringToIndex:30];
    }
    [self detectionUserInpute];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.isViewLoaded && !self.view.window)
    {
        self.view = nil;
    }
}







@end

