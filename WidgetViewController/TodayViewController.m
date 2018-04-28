

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "UIColor+CustomColors.h"
#import "ProductDetailVC.h"
#import "BaseTabBarController.h"
#import "WidgetManager.h"
#import "WidgetCell.h"
#import "WidgetModel.h"

@interface TodayViewController () <NCWidgetProviding,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIImageView *alphaBackground;
@property (nonatomic, strong) BaseTabBarController *mainTab;
@property (nonatomic, strong) NSMutableArray *widgetArray;
@property (nonatomic, strong) UITableView *widgetTable;
@property (nonatomic, strong) WidgetModel *model;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    WidgetManager *widgetManager = [WidgetManager new];
    NSArray *array = [widgetManager getWidgetData];
    self.widgetArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i ++) {
        WidgetModel *widgetModel = [[WidgetModel alloc] initWithDic:array[i]];
        [self.widgetArray addObject:widgetModel];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self changerWidgetUI];
    });
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, self.widgetArray.count * 100 + 40);
    }else{
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 100);
    }
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 100);
    } else {
        self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, self.widgetArray.count * 100 + 40);
    }
}
//ios10以下版本默认(0, 48, 39 ,0)
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    NSLog(@"%@", NSStringFromUIEdgeInsets(defaultMarginInsets));
    return UIEdgeInsetsZero;
}

- (void)changerWidgetUI
{
    self.widgetTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:self.widgetTable];
    self.widgetTable.delegate=self;
    self.widgetTable.dataSource=self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.widgetArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.widgetArray.count) {
        return 40;
    }
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WidgetCell *cell;
    static NSString *identifier=@"widgetIdentifier";
    cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[WidgetCell alloc] initWithOtherReuseIdentifier:identifier];
    }
    if (indexPath.row == self.widgetArray.count) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 40, 10, 80, 20)];
        label.text = @"查看全部";
        label.textColor = [UIColor iconBlueColor];
        label.font = [UIFont systemFontOfSize:16];
        [cell addSubview:label];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        NSLog(@"ddddffffd0===%@",self.widgetArray);
        if (self.widgetArray.count == 0) {
            return cell;
        }
        _model=[self.widgetArray objectAtIndex:indexPath.row];
        if (!_model) {
            return nil;
        }
        [cell showOtherDataWithDic:_model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == self.widgetArray.count) {
        NSString*urlStr = [NSString stringWithFormat:@"testWidget://"];
        NSURL*url = [NSURL URLWithString:urlStr];
        [self.extensionContext openURL:url completionHandler:^(BOOL success) {
            NSLog(@"调起app成功,!!!");
        }];
    }else{
        WidgetModel *model=[self.widgetArray objectAtIndex:indexPath.row];
        NSString*urlStr = [NSString stringWithFormat:@"testWidget://%@",model.idStr];
        NSURL*url = [NSURL URLWithString:urlStr];
        [self.extensionContext openURL:url completionHandler:^(BOOL success) {
            NSLog(@"调起app成功,!!!");
        }];
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

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

/*
 actualAmount = 0;
 category = 0;
 categoryName = "<null>";
 financePeriod = 300;
 id = 923;
 increaseInterest = 5;
 interestDate = "2016-11-25";
 label = "\U9650\U65f6\U52a0\U606f5%";
 name = " 7\U4ebf\U4e13\U4eab13\U671f";
 property = ACTIVITY;
 purchaseNumber = 0;
 rebateName = "<null>";
 shippedTime = 1479978000000;
 totalAmount = 20000;
 tradingCount = 0;
 yearIncome = 11;
 */

@end
