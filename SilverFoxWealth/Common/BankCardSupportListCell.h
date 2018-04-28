

#import <UIKit/UIKit.h>
#import "CommunalInfo.h"
#import "SupportBankModel.h"

@interface BankCardSupportListCell : UITableViewCell
@property (strong, nonatomic) UIImageView *backIconIM;
@property (strong, nonatomic) UILabel *backNameLB;
@property (nonatomic, strong) UILabel *limitLB;

-(void)giveValueWithDic:(SupportBankModel *)dic;


@end
