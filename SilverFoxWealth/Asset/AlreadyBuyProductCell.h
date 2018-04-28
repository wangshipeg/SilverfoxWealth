

#import <UIKit/UIKit.h>
#import "AlreadyPurchaseProductModel.h"
#import "CustomerSeparateLineAndArrowCell.h"

@interface AlreadyBuyProductCell : UITableViewCell
@property (strong, nonatomic) UILabel *productNameLB;
@property (strong, nonatomic) UILabel *purchaseSumLB;
@property (strong, nonatomic) UILabel *thirdLB;
@property (nonatomic, strong) UILabel *timeLastLB;
@property (nonatomic, strong) UILabel *incomeLB;
@property (nonatomic, strong) UIImageView *vipLevelImg;
//显示收益中的数据
-(void)showProceedDetailWithDic:(AlreadyPurchaseProductModel *)dic;
//显示已回款的数据
-(void)showCompleteDetailWithDic:(AlreadyPurchaseProductModel *)dic;

//收益中
-(void)proceedSubMenuDetailWithDic:(AlreadyPurchaseProductModel *)dic;

@end

