
#import "ModifyLogInPasswordVC.h"
#import "DataRequest.h"
#import "CommunalInfo.h"
#import "Validation.h"
#import <SVProgressHUD.h>
#import "AddCancelButton.h"
#import "UMMobClick/MobClick.h"
#import "InspectNetwork.h"
#import "RoundCornerClickBT.h"
#import "FastAnimationAdd.h"
#import "AddBankCardCell.h"

@interface ModifyLogInPasswordVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)  UITextField *originalPasswordTF;
@property (strong, nonatomic)  UITextField *freshPasswordOneTF;
@property (strong, nonatomic)  UITextField *freshPasswordTwoTF;
@property (strong, nonatomic)  RoundCornerClickBT *modifyBT;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ModifyLogInPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
}

- (void)UIDecorate {
    CustomerNavgationController *customNav = [[CustomerNavgationController alloc] init];
    if (IS_iPhoneX) {
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height);
    }else{
        customNav.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    }
    customNav.titleLabel.text = @"修改登录密码";
    self.title = @"修改登录密码";
    [self.view addSubview:customNav];
    __weak typeof (self) weakSelf = self;
    customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.view.backgroundColor=[UIColor backgroundGrayColor];
    
    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = [UIColor backgroundGrayColor];
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(customNav.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.bounces = NO;
    
    _originalPasswordTF=[[UITextField alloc] init];
    _originalPasswordTF.delegate=self;
    _originalPasswordTF.secureTextEntry=YES;
    _originalPasswordTF.placeholder=@"请输入原密码";
    UIView *originalPasswordTFDis=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(originalPasswordTFrespond) title:@"下一项"];
    [self.originalPasswordTF setInputAccessoryView:originalPasswordTFDis];
    
    _freshPasswordOneTF=[[UITextField alloc] init];
    _freshPasswordOneTF.delegate=self;
    _freshPasswordOneTF.secureTextEntry=YES;
    _freshPasswordOneTF.placeholder=@"请设置新密码";
    UIView *freshPasswordOneTFDis=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(freshPasswordOneTFrespond) title:@"下一项"];
    [self.freshPasswordOneTF setInputAccessoryView:freshPasswordOneTFDis];
    
    _freshPasswordTwoTF=[[UITextField alloc] init];
    _freshPasswordTwoTF.delegate=self;
    _freshPasswordTwoTF.secureTextEntry=YES;
    _freshPasswordTwoTF.placeholder=@"请再次输入新密码";
    UIView *freshPasswordTwoTFDis=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(freshPasswordTwoTFrespond) title:@"完成"];
    [self.freshPasswordTwoTF setInputAccessoryView:freshPasswordTwoTFDis];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectionTFText:) name:UITextFieldTextDidChangeNotification object:nil];
    
    _modifyBT=[RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [_modifyBT setTitle:@"修改" forState:UIControlStateNormal];
    _modifyBT.titleLabel.font=[UIFont systemFontOfSize:16];
    _modifyBT.backgroundColor=[UIColor typefaceGrayColor];
    _modifyBT.userInteractionEnabled=NO;
    [FastAnimationAdd codeBindAnimation:_modifyBT];
    [_modifyBT addTarget:self action:@selector(modifyStep:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView reloadData];
}

- (void)detectionTFText:(NSNotification *)note {
    [self detectionUserInput];
}

- (void)originalPasswordTFrespond {
    [self.freshPasswordOneTF becomeFirstResponder];
    [self detectionUserInput];
}

- (void)freshPasswordOneTFrespond {
    [self.freshPasswordTwoTF becomeFirstResponder];
    [self detectionUserInput];
}

- (void)freshPasswordTwoTFrespond {
    [self.freshPasswordTwoTF resignFirstResponder];
    [self detectionUserInput];
}


- (void)modifyStep:(UIButton *)sender {
    
    [MobClick event:@"ensure_update_login_pwd"];
    _modifyBT.userInteractionEnabled = NO;
    if ([InspectNetwork connectedToNetwork] ) {
        [self modifiyLoginPassword];
    }else {
        [SVProgressHUD showErrorWithStatus:NotHaveNetwork];
    }
    
}

- (void)modifiyLoginPassword {
    
    if (self.originalPasswordTF.text.length==0) {
        _modifyBT.userInteractionEnabled = YES;
        [SVProgressHUD showErrorWithStatus:[PromptLanguage pleaseInputeWith:@"原密码"]];
        return;
    }
    
    if (![Validation pwd:self.originalPasswordTF.text]) {
        _modifyBT.userInteractionEnabled = YES;
        [SVProgressHUD showErrorWithStatus:ModifiyLoginPasswordForOriginalFormatError];
        return;
    }
    
    if (self.freshPasswordOneTF.text.length==0||self.freshPasswordTwoTF.text.length==0) {
        _modifyBT.userInteractionEnabled = YES;
        [SVProgressHUD showErrorWithStatus:[PromptLanguage pleaseInputeWith:@"新密码"]];
        return;
    }
    
    if (![Validation pwd:self.freshPasswordOneTF.text]||![Validation pwd:self.freshPasswordTwoTF.text]) {
        _modifyBT.userInteractionEnabled = YES;
        [SVProgressHUD showErrorWithStatus:ModifiyLoginPasswordForNewFormatError];
        return;
    }
    
    if (![self.freshPasswordOneTF.text isEqualToString:self.freshPasswordTwoTF.text]) {
        _modifyBT.userInteractionEnabled = YES;
        [SVProgressHUD showErrorWithStatus:ModifiyLoginPasswordForTwiceDifferent];
        return;
    }
    
    if ([self.freshPasswordOneTF.text isEqualToString:self.originalPasswordTF.text]) {
        _modifyBT.userInteractionEnabled = YES;
        [SVProgressHUD showErrorWithStatus:ModifiyLoginPasswordForNewAndOldPasswordCannotSame];
        return;
    }
    
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [[DataRequest sharedClient]  modifyLoginPasswordWithcustomerId:user.customerId oldpassword:self.originalPasswordTF.text newpassword:self.freshPasswordTwoTF.text callback:^(id obj) {
        DLog(@"修改登录密码==%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic=obj;
            switch ([[dic objectForKey:@"code"] integerValue]) {
                case 2000:
                    [SVProgressHUD showSuccessWithStatus:ModifiySucceed];
                    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:Wait_Time]];
                    [self.navigationController popViewControllerAnimated:YES];
                    break;
                default:
                    _modifyBT.userInteractionEnabled = YES;
                    [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
                    break;
            }
        }
    }];
}

- (void)detectionUserInput {
    if (self.originalPasswordTF.text.length<6||self.freshPasswordOneTF.text.length<6||self.freshPasswordTwoTF.text.length<6) {
        self.modifyBT.backgroundColor=[UIColor typefaceGrayColor];
        self.modifyBT.userInteractionEnabled=NO;
    }else {
        self.modifyBT.backgroundColor=[UIColor zheJiangBusinessRedColor];
        self.modifyBT.userInteractionEnabled=YES;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        AddBankCardCell *cell=[[AddBankCardCell alloc] initWithTitle:@"原登录密码" inputTF:_originalPasswordTF leftViewWidth:85];
        return cell;
    }
    if (indexPath.row==1) {
        AddBankCardCell *cell=[[AddBankCardCell alloc] initWithTitle:@"设置密码" inputTF:_freshPasswordOneTF leftViewWidth:85];
        return cell;
    }
    
    if (indexPath.row==2) {
        AddBankCardCell *cell=[[AddBankCardCell alloc] initWithTitle:@"重复密码" inputTF:_freshPasswordTwoTF leftViewWidth:85];
        return cell;
    }
    
    if (indexPath.row==3) {
        UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor=[UIColor backgroundGrayColor];
        [cell addSubview:_modifyBT];
        [_modifyBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top).offset(50);
            make.height.equalTo(@45);
            make.left.equalTo(cell.mas_left).offset(43);
            make.right.equalTo(cell.mas_right).offset(-43);
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 3:
            return 150;
            break;
        default:
            break;
    }
    return 60;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (range.location>=20) {
        return NO;
    }
    
    if (![Validation oneLengthpwd:string]&&[string length]!=0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField==self.originalPasswordTF) {
        [self.freshPasswordOneTF becomeFirstResponder];
    }
    
    if (textField==self.freshPasswordOneTF) {
        [self.freshPasswordTwoTF becomeFirstResponder];
    }
    
    if (textField==self.freshPasswordTwoTF) {
        [self.freshPasswordTwoTF resignFirstResponder];
    }
    [self detectionUserInput];
    return YES;
}






@end

