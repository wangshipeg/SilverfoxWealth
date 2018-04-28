

#import <UIKit/UIKit.h>
#import "CustomerSeparateTableViewCell.h"
#import "ExchangerRecordModel.h"

typedef void (^CopyNumberBlock)();//复制按钮

@interface ChangerRecordCell : CustomerSeparateTableViewCell

@property (nonatomic, strong) UIImageView *goodsImage;//商品缩略图
@property (nonatomic, strong) UILabel *goodsNameLB;//商品名称
@property (nonatomic, strong) UILabel *changerTimeLB;//兑换时间
@property (nonatomic, strong) UILabel *silverLB;//兑换价格
@property (nonatomic, strong) UILabel *changerNum;//兑换码
@property (nonatomic, strong) UIButton *copynumBT;//复制按钮

@property (nonatomic, copy) CopyNumberBlock copyBlock;

- (void)copyNumberBlock:(CopyNumberBlock)copyNumberBlock;

- (void)showExchangerRecordDataWithDic:(ExchangerRecordModel *)dic;

@end






