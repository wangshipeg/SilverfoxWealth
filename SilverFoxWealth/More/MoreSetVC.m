

#import "MoreSetVC.h"
#import "FeedBackVC.h"
#import "MoreOfSetCell.h"
#import "MoreSetTopThreeCell.h"
#import "MoreSetBottomCell.h"
#import "UILabel+LabelStyle.h"
#import "NoRightArrowCell.h"
#import "SmsNotifyCell.h"
#import "UMMobClick/MobClick.h"
#import "DataRequest.h"

//#import "ProductAnnounceVC.h"
//#import "FrequentQuestionVC.h"


@interface MoreSetVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) CustomerNavgationController *customNav;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MoreSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
    
    //self.tableView.scrollEnabled = NO;//不允许滑动
}

- (void)UIDecorate {
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"设置";
    self.title = @"设置";
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
    self.tableView.bounces = NO;
    self.tableView.backgroundColor=[UIColor backgroundGrayColor];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section==1) {
        return 30;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor backgroundGrayColor];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        IndividualInfoManage *user = [IndividualInfoManage currentAccount];
        if (user) {
            return 2;
        }
        return 1;
    }
    if (section==1) {
        return 5;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            MoreOfSetCell *cell=[[MoreOfSetCell alloc] initWithTitle:@"清除缓存"];
            UILabel *telephoneLB=[[UILabel alloc] init];
            [cell addSubview:telephoneLB];
            NSString *str = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
            telephoneLB.text = [NSString stringWithFormat:@"%@",[self libarySizeChange:[self folderSizeAtPath:str]]];
            
            telephoneLB.textAlignment=NSTextAlignmentRight;
            [telephoneLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:14] characterColor:[UIColor characterBlackColor]];
            [telephoneLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.mas_centerY);
                make.right.equalTo(cell.mas_right).offset(-38);
                make.width.equalTo(@100);
                make.height.equalTo(@20);
            }];
            return cell;
        }
        
        if (user) {
            if (indexPath.row==1) {
                SmsNotifyCell *cell=[[SmsNotifyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.titleLB.text = @"回款短信通知";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell openSMSNotifyWith:^(BOOL isOpen) {
                    if (isOpen) { //如果用户开启了回款通知
                        [MobClick event:@"sms_notify_open"];
                        _status = @"0";
                        [self paybackSmsResult:_status];
                    }else {       //如果用户关闭回款通知
                        [MobClick event:@"sms_notify_open"];
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"关闭后将收不到回款短信通知" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            _status = @"1";
                            [self paybackSmsResult:_status];
                        }];
                        [alertController addAction:otherAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                }];
                return cell;
            }
        }
    }
    
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            NoRightArrowCell *cell=[[NoRightArrowCell alloc] initWithTitle:@"微信公众号:银狐财富" ];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.row==1) {
            NoRightArrowCell *cell=[[NoRightArrowCell alloc] initWithTitle:@"企业QQ: 4000218855"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        if (indexPath.row==2) {
            NoRightArrowCell *cell=[[NoRightArrowCell alloc] initWithTitle:@"QQ1群: 320232588"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        if (indexPath.row==3) {
            NoRightArrowCell *cell=[[NoRightArrowCell alloc] initWithTitle:@"QQ2群: 313562590"];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        if (indexPath.row==4) {
            NoRightArrowCell *cell=[[NoRightArrowCell alloc] initWithTitle:@"QQ3群: 322156473"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0 && indexPath.section==0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"清除缓存" message:@"您要清理缓存吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSFileManager *manager = [NSFileManager defaultManager];
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
            NSEnumerator *filesEnumerator = [[manager subpathsAtPath:path]objectEnumerator];
            NSString *filePath = [NSString string];
            while ((filePath = [filesEnumerator nextObject]) != nil) {
                NSString *string = [path stringByAppendingPathComponent:filePath];
                [manager removeItemAtPath:string error:nil];
            }
            //刷新某一行
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)paybackSmsResult:(NSString *)status
{
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [[DataRequest sharedClient]paybackSmsResultWithcustomerId:user.customerId flag:status callback:^(id obj) {
    }];
}

//m/(1024.0*1024.0)
- (float)folderSizeAtPath:(NSString *)path {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path])
        return 0;//文件夹不存在返回0
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:path] objectEnumerator];
    NSString *fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString *fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}
- (long long) fileSizeAtPath:(NSString *) filePath{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (NSString *)libarySizeChange:(float)size {
    if (size < 1024 * 1024) {
        return [NSString stringWithFormat:@"%d K",
                (int)size / 1024];
    } else {
        return [NSString stringWithFormat:@"%.2fM", size / (1024 * 1024)];
    }
}





@end

