
#import <UIKit/UIKit.h>
#import "BankAndIdentityInfoModel.h"


//选择银行卡 上面数据使用的cell
@interface ChooseCardOneCell : UITableViewCell

@property (strong, nonatomic) UIImageView *bankIconIM;
@property (strong, nonatomic) UILabel *cardNameLB;

@property (strong, nonatomic) UILabel *limitLB;


-(void)setCellWith:(BankAndIdentityInfoModel *)dic;

@end
