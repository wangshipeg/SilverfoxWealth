

#import "CustomerSeparateTableViewCell.h"
#import "ThreeEquelPartByLBView.h"
#import "IndianaRecordsModel.h"
#import "ExchangeRecordModel.h"

@interface SilverClearCell : UITableViewCell
@property (nonatomic, strong) ThreeEquelPartByLBView *contentLBView;

-(void)showInfoWithDic:(NSDictionary *)dic;

- (void)showMyIndianaWithDic:(IndianaRecordsModel *)data;

- (void)showExchangeRecordWith:(ExchangeRecordModel *)model;

@end

