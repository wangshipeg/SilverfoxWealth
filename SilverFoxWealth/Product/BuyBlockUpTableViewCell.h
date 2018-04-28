
#import "CustomerSeparateTableViewCell.h"
#import "DetailPageBuyBlockModel.h"

@interface BuyBlockUpTableViewCell : CustomerSeparateTableViewCell
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *lastOrderRebateLB;

- (void)buyBlockupWith:(DetailPageBuyBlockModel *)dic;

@end
