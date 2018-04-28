

#import "CustomerSeparateTableViewCell.h"
#import  "IndividualInfoManage.h"

@interface MoreBaseCell : UITableViewCell

@property (strong, nonatomic) UILabel *nameAndPhoneNumLB; //显示姓名和电话的
@property (strong, nonatomic) UILabel *individualCenter;
@property (strong, nonatomic) UILabel *noteLoginLB;

- (void)showDetailWith:(IndividualInfoManage *)user;

@end
