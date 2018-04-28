

#import "MoreVC.h"
#import "IndividualInfoVC.h"
#import "UserMessageVC.h"
#import "MoreSetVC.h"
#import "HTMLVC.h"
#import "DataRequest.h"
#import "UINavigationController+DetectionNetState.h"
#import "CommunalInfo.h"
#import "UserDefaultsManager.h"
#import "NoneInvestView.h"
#import "StringHelper.h"
#import <objc/runtime.h>
#import "UMMobClick/MobClick.h"
#import "VCAppearManager.h"
#import "PromptLanguage.h"
#import "MoreBaseCell.h"
#import "MoreSetTopCell.h"
#import "MoreSetBottomLineCell.h"
#import "FastAnimationAdd.h"
#import "SilverTraderVC.h"
#import "UserInfoModel.h"
#import "SystemInfoModel.h"
#import "SCMeasureDump.h"
#import "FeedBackVC.h"
#import "AccountBindingVC.h"
#import "InspectNetwork.h"

//udesk
#import "UdeskOrganization.h"
#import "UdeskCustomer.h"
#import "UdeskManager.h"
#import "UdeskSDKManager.h"
#import "CommunalInfo.h"
#import <AdSupport/AdSupport.h>

@interface MoreVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UILabel *quitLoginLB;
@property (nonatomic, strong) UILabel *phoneLB;
@property (nonatomic, strong) NoneInvestView *noneInvestView; //未投资提示
@property (nonatomic, strong) UIImageView *phoneImg;//电话标识
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *mutArr;
@property (nonatomic, strong) CustomerNavgationController *customNav;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MoreVC
{
    BOOL isUpdateTableViewScrollEnabled;
}

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
    _customNav.titleLabel.text = @"更多";
    self.title = @"更多";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    isUpdateTableViewScrollEnabled = NO;
    
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _quitLoginLB = [[UILabel alloc] init];
    _quitLoginLB.text = @"400-021-8855";
    _quitLoginLB.font = [UIFont systemFontOfSize:20];
    _quitLoginLB.textAlignment = NSTextAlignmentCenter;
    _quitLoginLB.textColor = [UIColor characterBlackColor];
    _phoneImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone.png"]];
    
    _phoneLB = [[UILabel alloc] init];
    _phoneLB.text = @"客服热线";
    _phoneLB.font = [UIFont systemFontOfSize:15];
    _phoneLB.textColor = [UIColor characterBlackColor];
    _phoneLB.textAlignment = NSTextAlignmentCenter;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showUsetInfo];
}

-(void)showUsetInfo {
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    }
    
    if (indexPath.section == 2 && indexPath.row == 1) {
        return 100;
    }
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 3;
    }
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            MoreBaseCell *cell = [[MoreBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            IndividualInfoManage *user = [IndividualInfoManage currentAccount];
            [cell showDetailWith:user];
            return cell;
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            MoreSetBottomLineCell *cell = [[MoreSetBottomLineCell alloc] initWithTitle:@"账号绑定"];
            return cell;
        }
        if (indexPath.row == 1) {
            MoreSetBottomLineCell *cell = [[MoreSetBottomLineCell alloc] initWithTitle:@"常见问题"];
            return cell;
        }
        if (indexPath.row == 2) {
            MoreSetTopCell *cell = [[MoreSetTopCell alloc] initWithTitle:@"联系客服"];
            return cell;
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            MoreSetTopCell *cell = [[MoreSetTopCell alloc] initWithTitle:@"设置"];
            return cell;
        }
        
        if (indexPath.row == 1) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsMake(0, 0, -10, 0);
            cell.backgroundColor = [UIColor backgroundGrayColor];
            [cell addSubview:_phoneLB];
            [cell addSubview:_quitLoginLB];
            [cell addSubview:_phoneImg];
            
            [_quitLoginLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).offset(30);
                make.height.equalTo(@20);
                make.centerX.equalTo(cell.mas_centerX).offset(20);
            }];
            
            [_phoneImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_quitLoginLB.mas_top);
                make.width.equalTo(@20);
                make.height.equalTo(@20);
                make.right.equalTo(_quitLoginLB.mas_left).offset(-5);
            }];
            
            [_phoneLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_quitLoginLB.mas_bottom).offset(10);
                make.height.equalTo(@20);
                make.left.equalTo(cell.mas_left).offset(43);
                make.right.equalTo(cell.mas_right).offset(-43);
            }];
            
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 0.5;
    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor backgroundGrayColor];
    return backView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![InspectNetwork connectedToNetwork]){
        return;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            //常见问题
            [MobClick event:@"more_common_question"];
            [VCAppearManager pushH5VCWithCurrentVC:self workS:frequentQuestion];
            return;
        }
        if (indexPath.row == 2) {
            [MobClick event:@"more_band_account"];
            DLog(@"联系客服");
            
            [[NSUserDefaults standardUserDefaults] setObject:UDeskAccount forKey:@"domain"];
            [[NSUserDefaults standardUserDefaults] setObject:UDeskAPPKey forKey:@"key"];
            [[NSUserDefaults standardUserDefaults] setObject:UDeskAPPId forKey:@"appId"];
            UdeskOrganization *organization = [[UdeskOrganization alloc] initWithDomain:UDeskAccount appKey:UDeskAPPKey appId:UDeskAPPId];
            
            //客户信息
            IndividualInfoManage *user = [IndividualInfoManage currentAccount];
            UdeskCustomer *customer = [UdeskCustomer new];
            if (!user) {
                NSString *idfa = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
                customer.sdkToken = idfa;
                customer.nickName = idfa;
                customer.email = nil;
                customer.cellphone = nil;
                customer.customerDescription = @"此用户未登录";
            } else {
                customer.sdkToken = user.customerId;
                customer.nickName = user.customerId;
                customer.email = nil;
                customer.customerDescription = [NSString stringWithFormat:@"注册时间:%@",user.registerTime];
            }
            //            //设置头像
            //            UdeskSDKManager *chat = [[UdeskSDKManager alloc] initWithSDKStyle:[UdeskSDKStyle defaultStyle]];
            //            //通过URL设置头像
            //            [chat setCustomerAvatarWithURL:user.headImage];
            //通过本地图片设置头像
            //[chat setCustomerAvatarWithImage:[UIImage imageNamed:@"customer"]];
            
            //初始化sdk
            [UdeskManager initWithOrganization:organization customer:customer];
            //后台配置
            UdeskSDKManager *chatViewManager = [[UdeskSDKManager alloc] initWithSDKStyle:[UdeskSDKStyle customStyle]];
            //不隐藏定位
            chatViewManager.hiddenLocationButton = YES;
            [chatViewManager pushUdeskInViewController:self completion:nil];
            
            return;
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row==0) {
            [MobClick event:@"more_set"];
            MoreSetVC *moreVC=[[MoreSetVC alloc] init];
            moreVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:moreVC animated:YES];
            return;
        }
        if (indexPath.row==1) {
            [MobClick event:@"more_call_phone"];
            NSString *deviceType = [UIDevice currentDevice].model;
            if([deviceType  isEqualToString:@"iPod touch"]||[deviceType  isEqualToString:@"iPad"]||[deviceType  isEqualToString:@"iPhone Simulator"]){
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您的设备不能拨打电话" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
                return;
            }
            UIWebView *callWebView = [[UIWebView alloc] init];
            NSURL *telURL=[NSURL URLWithString:@"tel:4000218855"];
            [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
            [self.view addSubview:callWebView];
            return;
        }
    }
    //如果未登陆 不能继续
    if (![self isLogin]) {
        return;
    }
    if (indexPath.section == 1) {
        //账号绑定
        if (indexPath.row == 0) {
            [MobClick event:@"more_band_account"];
            AccountBindingVC *bindingVC = [[AccountBindingVC alloc] init];
            [self.navigationController pushViewController:bindingVC animated:YES];
        }
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row==0) {
            [MobClick event:@"more_user_centre"];
            IndividualInfoVC *individual=[[IndividualInfoVC alloc] init];
            individual.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:individual animated:YES];
        }
    }
}

- (BOOL)isLogin {
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    if (user) {
        return YES;
    }
    [VCAppearManager presentLoginVCWithCurrentVC:self];
    return NO;
}

//适应屏幕
- (void)adaptWindow {
    if (!isUpdateTableViewScrollEnabled) {
        UIWindow *window=[[UIApplication sharedApplication] keyWindow];
        CGFloat screenHeight=window.bounds.size.height;
        CGFloat surplusHeight=screenHeight-64-49;
        if (surplusHeight<self.tableView.contentSize.height) {
            self.tableView.scrollEnabled = YES;
        }else{
            self.tableView.scrollEnabled = NO;
        }
        isUpdateTableViewScrollEnabled = YES;
    }
}

@end

