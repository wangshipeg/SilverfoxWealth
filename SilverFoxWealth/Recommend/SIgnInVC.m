

#import "SIgnInVC.h"
#import "RoundCornerClickBT.h"
#import "VCAppearManager.h"
#import "DataRequest.h"
#import "UserDefaultsManager.h"
#import "PromptLanguage.h"
#import "FyCalendarView.h"
#import "DateHelper.h"
#import "SignInTimesModel.h"
#import "SignInPrizeListModel.h"
#import "SignInPopupViewCell.h"
#import "SCMeasureDump.h"
#import "AddCancelButton.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define viewWidth   [UIScreen mainScreen].bounds.size.width;

@interface SIgnInVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong) RoundCornerClickBT *signInBT;
@property (strong, nonatomic) FyCalendarView *calendarView;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSString *dayStr;
@property (nonatomic, strong) SignInTimesModel *timesModel;
@property (nonatomic, strong) NSMutableArray *mutableArr;
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *thirdLabel;
@property (nonatomic, strong) UILabel *fourthLabel;
@property (nonatomic, strong) UIImageView *oneImg;
@property (nonatomic, strong) UIImageView *twoImg;
@property (nonatomic, strong) UIImageView *threeImg;
@property (nonatomic, strong) UIImageView *fourImg;
@property (nonatomic, strong) UIImageView *oneLine;
@property (nonatomic, strong) UIImageView *twoLine;
@property (nonatomic, strong) UIImageView *threeLine;
@property (nonatomic, strong) UIButton *oneBT;
@property (nonatomic, strong) UIButton *twoBT;
@property (nonatomic, strong) UIButton *threeBT;
@property (nonatomic, strong) UIButton *fourBT;

@property (nonatomic, strong) NSMutableArray *prizeListDataSource;
@property (nonatomic, strong) NSString *prizeStr;//奖品提示框内容
@property (nonatomic, strong) NSString *prizeString;//领取奖品提示框内容
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) SignInPrizeListModel *prizeModel;
@property (nonatomic, strong) UIView *viw;
@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, strong) NSString *recordIdstr;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSMutableArray *mutArr;
@property (nonatomic, strong) NSMutableArray *recordMutArr;

@property (nonatomic, strong) NSMutableArray *allTimesSource;//签到数组
@property (nonatomic, strong) NSDictionary *signArrayDict;
@property (nonatomic, assign) int times;
@property (nonatomic, strong) CustomerNavgationController *customNav;

@end

@implementation SIgnInVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self UIDecorate];
    self.date = [NSDate date];
    [self achievePecommendSignInRewardData];//请求奖品显示内容 此方法先执行
}

//数据获取
- (void)achievePecommendData
{
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] recommendationSignInTimesWithcustomerId:user.customerId callback: ^(id obj) {
        DLog(@"本月累计签到天数数据获取====%@",obj);
        if ([obj isKindOfClass:[NSArray class]])
        {
            self.allTimesSource = [NSMutableArray array];
            [self.allTimesSource addObjectsFromArray:obj];
            [self updataProgressColor:obj];
            [self inspectUserWhetherSign:self.allTimesSource];
        }
        
        if ([obj isKindOfClass:[NSError class]])
        {
            [SVProgressHUD showErrorWithStatus:NotHaveNetwork];
            _oneBT.userInteractionEnabled = NO;
            _twoBT.userInteractionEnabled = NO;
            _threeBT.userInteractionEnabled = NO;
            _fourBT.userInteractionEnabled = NO;
            return;
        }
        [self setupCalendarView:obj];
    }];
}

- (void)achievePecommendSignInRecordPrizeData
{
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] recommendationSignInRecordWithcustomerId:user.customerId callback:^(id obj) {
        DLog(@"签到奖品领取记录接口====%@",obj);
        for (int i = 0; i < 4; i ++) {
            SignInPrizeListModel *model = [[SignInPrizeListModel alloc] init];
            model = self.prizeListDataSource[i];
            [_arr addObject:model.idStr];
        }
        if ([obj isKindOfClass:[NSString class]])
        {
            NSArray *components = [obj componentsSeparatedByString:@","];
            [_mutArr addObjectsFromArray:components];
            for (NSString *recordStr in components) {
                if ([_arr containsObject:recordStr]) {
                    _recordIdstr = recordStr;
                }
                [self recordIdstrInfo];
            }
        }
        [_recordMutArr addObjectsFromArray:_mutArr];
        if ([obj isKindOfClass:[NSError class]])
        {
            [SVProgressHUD showErrorWithStatus:NotHaveNetwork];
        }
    }];
}

- (void)achievePecommendSignInPrizeData:(NSString *)signInPrizeId
{
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    [[DataRequest sharedClient] recommendationSignInPrizeWithcustomerId:user.customerId prizeId:signInPrizeId callback:^(id obj) {
        DLog(@"领取签到奖品接口====%@",obj);//设置问题
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] integerValue] == 2000) {
                [self achievePecommendSignInRecordPrizeData];
                
                [self.tableView removeFromSuperview];
                if ([_prizeModel.giveType integerValue] == 1) {
                    _prizeString = [NSString stringWithFormat:@"获得%@两银子",_prizeModel.giveNum];
                } else if ([_prizeModel.giveType integerValue] == 2){
                    _prizeString = [NSString stringWithFormat:@"获得%@元红包",_prizeModel.giveNum];
                } else {
                    _prizeString = [NSString stringWithFormat:@"获得%@%%加息券",_prizeModel.giveNum];
                }
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"恭喜您" message:_prizeString delegate:self cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil];
                [alertView show];
            }else{
                [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
            }
        }
        if ([obj isKindOfClass:[NSError class]]) {
            [SVProgressHUD showErrorWithStatus:NotHaveNetwork];
        }
    }];
}

- (void)achievePecommendSignInRewardData
{
    [[DataRequest sharedClient] recommendationSignInRewardWithCallback:^(id obj)
     {
         [self achievePecommendData];
         DLog(@"获取签到奖品列表====%@",obj);
         if ([obj isKindOfClass:[NSArray class]]) {
             [self.prizeListDataSource addObjectsFromArray:obj];
             [self achievePecommendSignInRecordPrizeData];
             [self prizeListShow];
         }
         if ([obj isKindOfClass:[NSError class]]) {
             [SVProgressHUD showErrorWithStatus:NotHaveNetwork];
         }
     }];
}

- (void)quotaInfo
{
    [VCAppearManager pushNewH5VCWithCurrentVC:self workS:signinRule];
}

#pragma -mark 根据接口返回个数 更新进度条颜色
- (void)updataProgressColor:(NSArray *)arr
{
    SignInPrizeListModel *model = [[SignInPrizeListModel alloc] init];
    if (!self.prizeListDataSource) {
        return;
    }
    model = self.prizeListDataSource[0];
    NSString *days = model.days;
    if (arr.count >= [days integerValue]) {
        _oneImg.image = [UIImage imageNamed:@"RedDot.png"];
    }
    model = self.prizeListDataSource[1];
    NSString *daysT = model.days;
    if (arr.count >= [daysT integerValue]) {
        _twoImg.image = [UIImage imageNamed:@"RedDot.png"];
        _oneLine.image = [UIImage imageNamed:@"SignRedLine.png"];
    }
    model = self.prizeListDataSource[2];
    NSString *daysTr = model.days;
    if (arr.count >= [daysTr integerValue]) {
        _threeImg.image = [UIImage imageNamed:@"RedDot.png"];
        _twoLine.image = [UIImage imageNamed:@"SignRedLine.png"];
    }
    model = self.prizeListDataSource[3];
    NSString *daysF = model.days;
    if (arr.count >= [daysF integerValue]) {
        _fourImg.image = [UIImage imageNamed:@"RedDot.png"];
        _threeLine.image = [UIImage imageNamed:@"SignRedLine.png"];
    }
}

- (void)setupCalendarView:(NSArray *)array {
    _mutableArr = [NSMutableArray array];
    NSString *strTime;
    for (int i = 0; i < array.count; i ++) {
        _timesModel = array[i];
        //将签到日期转换为年月日
        strTime =[DateHelper conversionTimeStampToHorizontalAloneDayWith:_timesModel.signTime];
        _dayStr = [strTime substringFromIndex:6];
        [_mutableArr addObject:_dayStr];
    }

    NSString *currentTime = [[SCMeasureDump shareSCMeasureDump].nowTime substringToIndex:10];
    NSString *dateString = [currentTime stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *currentDayDate = [dateString substringFromIndex:6];
    
    NSMutableArray *dayDateArr = [NSMutableArray array];
    if ([currentDayDate intValue] == 1) {
        [dayDateArr addObject:currentDayDate];
    }else{
        for (int i = [currentDayDate intValue] - 1; i > 0; i --) {
            NSString *dayDate = [NSString stringWithFormat:@"%02d",i];
            [dayDateArr addObject:dayDate];
        }
    }
    
    NSMutableSet *set1 = [NSMutableSet setWithArray:dayDateArr];
    NSMutableSet *set2 = [NSMutableSet setWithArray:_mutableArr];
    [set2 minusSet:set1];
    NSMutableSet *set3 = [NSMutableSet setWithArray:_mutableArr];
    [set1 minusSet:set3];
    [set2 unionSet:set1];
    
    NSArray *partDaysArray = [set2 allObjects];
    NSMutableArray *daysMutArr = [NSMutableArray arrayWithArray:partDaysArray];
    if (dayDateArr.count > 0) {
        for (int i = 0; i < partDaysArray.count; i ++) {
            if ([dayDateArr[0] intValue] < [partDaysArray[i] intValue]) {
                [daysMutArr removeObject:partDaysArray[i]];
            }
        }
    }
#pragma -mark (以下两个数组可以分别放签到的日期和未签的日期)
    //日期状态
    self.calendarView.allDaysArr = _mutableArr;
    self.calendarView.partDaysArr = daysMutArr;
    //显示当月日期
    self.calendarView.isShowOnlyMonthDays = NO;
    self.calendarView.date = [NSDate date];
    __weak typeof(self) weakSelf = self;
    self.calendarView.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year){
        DLog(@"补签=====%li-%li-%li", (long)year,(long)month,(long)day);
        weakSelf.times ++;
        [weakSelf achievePecommendData];
    };
}
#pragma -mark 签到相关
//检查检查用户是否已经签到
- (void)inspectUserWhetherSign:(NSMutableArray *)signInArr
{
    if (signInArr.count != 0) {
        for (int i = 0; i < signInArr.count; i ++) {
            SignInTimesModel *model = signInArr[i];
            NSString *signTime = [model.signTime substringToIndex:10];
            NSString *dateStr = [signTime stringByReplacingOccurrencesOfString:@"-" withString:@""];
            //获取当前时间，日期
            NSString *currentTime = [[SCMeasureDump shareSCMeasureDump].nowTime substringToIndex:10];
            NSString *dateString = [currentTime stringByReplacingOccurrencesOfString:@"-" withString:@""];
            DLog(@"dateString:%@",dateString);
            if ([dateString isEqualToString:dateStr]) {
                [_signInBT setTitle:@"已签到" forState:UIControlStateNormal];
                return;
            }
            [_signInBT setTitle:@"签到" forState:UIControlStateNormal];
        }
    } else {
        [_signInBT setTitle:@"签到" forState:UIControlStateNormal];
    }
}

- (void)prizeListShow
{
    SignInPrizeListModel *model = [[SignInPrizeListModel alloc] init];
    model = self.prizeListDataSource[0];
    _firstLabel.text = [NSString stringWithFormat:@"%@天",model.days];
    model = self.prizeListDataSource[1];
    _secondLabel.text = [NSString stringWithFormat:@"%@天",model.days];
    model = self.prizeListDataSource[2];
    _thirdLabel.text = [NSString stringWithFormat:@"%@天",model.days];
    model = self.prizeListDataSource[3];
    _fourthLabel.text = [NSString stringWithFormat:@"%@天",model.days];
}

- (void)UIDecorate
{
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"签到";
    self.title = @"签到";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [_customNav.rightButton setTitle:@"签到规则" forState:UIControlStateNormal];
    _customNav.rightButtonHandle = ^{
        [weakSelf quotaInfo];
    };
    self.prizeListDataSource = [NSMutableArray array];
    self.arr = [NSMutableArray array];
    self.mutArr = [NSMutableArray array];
    self.recordMutArr = [NSMutableArray array];
    self.times = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //日历视图
    self.calendarView = [[FyCalendarView alloc] init];
    [self.view addSubview:self.calendarView];
    [_calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@(self.view.frame.size.width));
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(self.customNav.mas_bottom);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    [self.view addSubview:label];
    label.backgroundColor = [UIColor backgroundGrayColor];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@10);
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(_calendarView.mas_bottom).offset(20);
    }];
    
    _firstLabel = [[UILabel alloc] init];
    [self.view addSubview:_firstLabel];
    _firstLabel.textAlignment = NSTextAlignmentCenter;
    _firstLabel.font = [UIFont systemFontOfSize:14];
    _firstLabel.textColor = [UIColor characterBlackColor];
    [_firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@15);
        make.left.equalTo(self.view.mas_left).offset(30);
        make.top.equalTo(label.mas_bottom).offset(10);
    }];
    
    _secondLabel = [[UILabel alloc] init];
    [self.view addSubview:_secondLabel];
    _secondLabel.textAlignment = NSTextAlignmentCenter;
    _secondLabel.font = [UIFont systemFontOfSize:14];
    _secondLabel.textColor = [UIColor characterBlackColor];
    [_secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@15);
        make.left.equalTo(self.firstLabel.mas_right).offset((self.view.frame.size.width - 60 - 160) / 3);
        make.top.equalTo(label.mas_bottom).offset(10);
    }];
    
    _thirdLabel = [[UILabel alloc] init];
    [self.view addSubview:_thirdLabel];
    _thirdLabel.textAlignment = NSTextAlignmentCenter;
    _thirdLabel.font = [UIFont systemFontOfSize:14];
    _thirdLabel.textColor = [UIColor characterBlackColor];
    [_thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@15);
        make.left.equalTo(self.secondLabel.mas_right).offset((self.view.frame.size.width - 160 - 60) / 3);
        make.top.equalTo(label.mas_bottom).offset(10);
    }];
    
    _fourthLabel = [[UILabel alloc] init];
    [self.view addSubview:_fourthLabel];
    _fourthLabel.textAlignment = NSTextAlignmentCenter;
    _fourthLabel.font = [UIFont systemFontOfSize:14];
    _fourthLabel.textColor = [UIColor characterBlackColor];
    [_fourthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@15);
        make.left.equalTo(self.view.mas_right).offset(-70);
        make.top.equalTo(label.mas_bottom).offset(10);
    }];
    
    _oneImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GrayDot.png"]];
    [self.view addSubview:_oneImg];
    [_oneImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@10);
        make.height.equalTo(@10);
        make.centerX.equalTo(self.firstLabel.mas_centerX);
        make.top.equalTo(_firstLabel.mas_bottom).offset(12);
    }];
    
    _twoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GrayDot.png"]];
    [self.view addSubview:_twoImg];
    [_twoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@10);
        make.height.equalTo(@10);
        make.centerX.equalTo(self.secondLabel.mas_centerX);
        make.top.equalTo(_secondLabel.mas_bottom).offset(12);
    }];
    _threeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GrayDot.png"]];
    [self.view addSubview:_threeImg];
    [_threeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@10);
        make.height.equalTo(@10);
        make.centerX.equalTo(self.thirdLabel.mas_centerX);
        make.top.equalTo(_thirdLabel.mas_bottom).offset(12);
    }];
    _fourImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GrayDot.png"]];
    [self.view addSubview:_fourImg];
    [_fourImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@10);
        make.height.equalTo(@10);
        make.centerX.equalTo(self.fourthLabel.mas_centerX);
        make.top.equalTo(_fourthLabel.mas_bottom).offset(12);
    }];
    
    _oneLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SignGrayLine.png"]];
    [self.view addSubview:_oneLine];
    [_oneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstLabel.mas_bottom).offset(15);
        make.height.equalTo(@4);
        make.left.equalTo(self.oneImg.mas_right);
        make.right.equalTo(self.twoImg.mas_left);
    }];
    
    _twoLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SignGrayLine.png"]];
    [self.view addSubview:_twoLine];
    [_twoLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstLabel.mas_bottom).offset(15);
        make.height.equalTo(@4);
        make.left.equalTo(self.twoImg.mas_right);
        make.right.equalTo(self.threeImg.mas_left);
    }];
    _threeLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SignGrayLine.png"]];
    [self.view addSubview:_threeLine];
    [_threeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_firstLabel.mas_bottom).offset(15);
        make.height.equalTo(@4);
        make.left.equalTo(self.threeImg.mas_right);
        make.right.equalTo(self.fourImg.mas_left);
    }];
    
    _oneBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_oneBT];
    [_oneBT setImage:[UIImage imageNamed:@"SignReward.png"] forState:UIControlStateNormal];
    [_oneBT addTarget:self action:@selector(clickOneButton:) forControlEvents:UIControlEventTouchUpInside];
    _oneBT.tag = 100;
    [_oneBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@42);
        make.height.equalTo(@42);
        make.centerX.equalTo(self.firstLabel.mas_centerX);
        make.top.equalTo(self.oneImg.mas_bottom).offset(5);
    }];
    
    _twoBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_twoBT];
    [_twoBT setImage:[UIImage imageNamed:@"SignReward.png"] forState:UIControlStateNormal];
    [_twoBT addTarget:self action:@selector(clickOneButton:) forControlEvents:UIControlEventTouchUpInside];
    _twoBT.tag = 101;
    [_twoBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@42);
        make.height.equalTo(@42);
        make.centerX.equalTo(self.secondLabel.mas_centerX);
        make.top.equalTo(self.twoImg.mas_bottom).offset(5);
    }];
    _threeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_threeBT];
    [_threeBT setImage:[UIImage imageNamed:@"SignReward.png"] forState:UIControlStateNormal];
    [_threeBT addTarget:self action:@selector(clickOneButton:) forControlEvents:UIControlEventTouchUpInside];
    _threeBT.tag = 102;
    [_threeBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@42);
        make.height.equalTo(@42);
        make.centerX.equalTo(self.thirdLabel.mas_centerX);
        make.top.equalTo(self.threeImg.mas_bottom).offset(5);
    }];
    _fourBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_fourBT];
    [_fourBT setImage:[UIImage imageNamed:@"SignReward.png"] forState:UIControlStateNormal];
    [_fourBT addTarget:self action:@selector(clickOneButton:) forControlEvents:UIControlEventTouchUpInside];
    _fourBT.tag = 103;
    [_fourBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@42);
        make.height.equalTo(@42);
        make.centerX.equalTo(self.fourthLabel.mas_centerX);
        make.top.equalTo(self.fourImg.mas_bottom).offset(5);
    }];
    
    //签到bt
    _signInBT = [RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_signInBT];
    _signInBT.backgroundColor = [UIColor zheJiangBusinessRedColor];
    [_signInBT setTitle:@"签到" forState:UIControlStateNormal];
    [_signInBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_signInBT addTarget:self action:@selector(handleSignBt:) forControlEvents:UIControlEventTouchUpInside];
    [_signInBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-43);
        make.height.equalTo(@45);
        make.left.equalTo(self.view.mas_left).offset(43);
        make.top.equalTo(self.oneBT.mas_bottom).offset(12);
    }];
}

- (void)recordIdstrInfo{
    if ([_recordIdstr isEqualToString:_arr[0]]) {
        [_oneBT setImage:[UIImage imageNamed:@"SignRewardAlreadyReceived.png"] forState:UIControlStateNormal];
    }
    if ([_recordIdstr isEqualToString:_arr[1]]) {
        [_twoBT setImage:[UIImage imageNamed:@"SignRewardAlreadyReceived.png"] forState:UIControlStateNormal];
    }
    if ([_recordIdstr isEqualToString:_arr[2]]) {
        [_threeBT setImage:[UIImage imageNamed:@"SignRewardAlreadyReceived.png"] forState:UIControlStateNormal];
    }
    if ([_recordIdstr isEqualToString:_arr[3]]) {
        [_fourBT setImage:[UIImage imageNamed:@"SignRewardAlreadyReceived.png"] forState:UIControlStateNormal];
    }
}

- (void)clickOneButton:(UIButton *)sender
{
    _prizeModel = self.prizeListDataSource[sender.tag - 100];
    if (![_recordMutArr containsObject:_prizeModel.idStr] && (_mutableArr.count >= [_prizeModel.days integerValue]))
    {
        [self setUpPopupView];
    }
    else
    {
        SignInPrizeListModel *model = [[SignInPrizeListModel alloc] init];
        model = self.prizeListDataSource[0];
        if ([model.giveType integerValue] == 1) {
            _prizeStr = [NSString stringWithFormat:@"%@两银子",model.giveNum];
        }else if ([model.giveType integerValue] == 2){
            _prizeStr = [NSString stringWithFormat:@"%@元红包",model.giveNum];
        }else{
            _prizeStr = [NSString stringWithFormat:@"%@%%加息券",model.giveNum];
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"累计签到%@天 奖励",model.days] message:_prizeStr delegate:nil cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil];
        [alertView show];
    }
}

- (void)handleSignBt:(RoundCornerClickBT *)sender
{
    [MobClick event:@"sign_btn_click"];
    //something happens
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    if (!user) {
        [VCAppearManager presentLoginVCWithCurrentVC:self];
        return;
    }
    [[DataRequest sharedClient] signWithcustomerId:user.customerId callback:^(id obj) {
        DLog(@"签到obj====%@",obj);
        [self signFinistWith:obj];
    }];
}

- (void)signFinistWith:(id)obj {
    if (!obj) {
        [self alreadySign];
    }
    if ([obj isKindOfClass:[NSDictionary class]]) {
        _signArrayDict = obj;
        [self achievePecommendData];
        [self animationWith:_signArrayDict];
    }
}

- (void)alreadySign
{
    [SVProgressHUD showErrorWithStatus:AlreadySign];
    [_signInBT setTitle:@"已签到" forState:UIControlStateNormal];
    _signInBT.userInteractionEnabled = NO;
}

//签到成功开始 动画
- (void)animationWith:(NSDictionary *)resultDic
{
    [_signInBT setTitle:@"已签到" forState:UIControlStateNormal];
    _signInBT.userInteractionEnabled = NO;
    DLog(@"_allTimesSource====%@\n%lu",_allTimesSource,(unsigned long)_allTimesSource.count);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"签到成功" message:[NSString stringWithFormat:@"+%@两银子\n本月您已累计签到%lu天",resultDic[@"amount"],(unsigned long)_allTimesSource.count + 1 + _times] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil];
    [alertView show];
    
    [[SensorsAnalyticsSDK sharedInstance] track:@"Sign"
                                 withProperties:@{
                                                  @"SignDayOfCurrentMonth" : [NSNumber numberWithUnsignedLong:_allTimesSource.count + 1],
                                                  }];
}

#pragma -mark 设置弹出视图 (回答问题)
- (void)setUpPopupView
{
    _viw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_viw];
    _viw.backgroundColor = [UIColor characterBlackColor];
    _viw.alpha = .5;
    
    self.tableView=[[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    [self.view bringSubviewToFront:self.tableView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.layer.cornerRadius = 5;
    self.tableView.layer.masksToBounds = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    float width = self.view.frame.size.width / 3 * 2.5;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-50);
        make.width.equalTo(@(width));
        make.height.equalTo(@260);
    }];
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
}

- (void)handleCloseTableView:(UIButton *)sender
{
    [self.tableView removeFromSuperview];
    [self.viw removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    SignInPrizeListModel *model=[self.prizeListDataSource objectAtIndex:indexPath.row];
    if (!_prizeModel) {
        return nil;
    }
    static NSString *identifier=@"prize";
    SignInPopupViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[SignInPopupViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.row == 0) {
        cell.answerLB.text = [NSString stringWithFormat:@"A. %@",_prizeModel.answerA];
    }
    if (indexPath.row == 1) {
        cell.answerLB.text = [NSString stringWithFormat:@"B. %@",_prizeModel.answerB];;
    }
    if (indexPath.row == 2) {
        cell.answerLB.text = [NSString stringWithFormat:@"C. %@",_prizeModel.answerC];;
    }
    if (indexPath.row == 3) {
        cell.answerLB.text = [NSString stringWithFormat:@"D. %@",_prizeModel.answerD];;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == [_prizeModel.rightAnswer integerValue] - 1) {
        [self achievePecommendSignInPrizeData:_prizeModel.idStr];//领取奖品
    }else{
        [self.tableView removeFromSuperview];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"很遗憾,答错了~" message:@"继续加油吧!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) {
        [self.viw removeFromSuperview];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] init];
    view.backgroundColor=[UIColor whiteColor];
    UILabel *titleLB=[[UILabel alloc] init];
    [view addSubview:titleLB];
    titleLB.numberOfLines = 0;
    titleLB.textAlignment = NSTextAlignmentCenter;
    [titleLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.height.equalTo(@20);
        make.top.equalTo(view.mas_top).offset(15);
        make.right.equalTo(view.mas_right).offset(-15);
    }];
    UILabel *titleLBT=[[UILabel alloc] init];
    [view addSubview:titleLBT];
    titleLBT.numberOfLines = 0;
    titleLBT.textAlignment = NSTextAlignmentCenter;
    [titleLBT decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:14] characterColor:[UIColor characterBlackColor]];
    [titleLBT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.height.equalTo(@40);
        make.top.equalTo(titleLB.mas_bottom);
        make.right.equalTo(view.mas_right).offset(-15);
    }];
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:bt];
    [bt setImage:[UIImage imageNamed:@"CalculateClose.png"] forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(handleCloseTableView:) forControlEvents:UIControlEventTouchUpInside];
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top);
        make.right.equalTo(view.mas_right);
        make.width.equalTo(@35);
        make.height.equalTo(@35);
    }];
    
    titleLB.text = @"答对后即可领取奖品哦!";
    titleLBT.text = [NSString stringWithFormat:@"问题: %@",_prizeModel.question];
    
    return view;
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

