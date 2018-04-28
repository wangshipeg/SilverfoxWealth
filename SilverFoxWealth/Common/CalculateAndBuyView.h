
#import "TopBlackLineView.h"

typedef void (^CalculateClickBlock)();
typedef void (^BuyClickBlock)();

@interface CalculateAndBuyView : TopBlackLineView

@property (nonatomic, copy) CalculateClickBlock calculateBlock;
@property (nonatomic, copy) BuyClickBlock buyBlock;

- (instancetype)initWith:(UIButton *)buyBT;

//初始化一个没有计算器的购买视图
- (instancetype)initNoCaculeteWith:(UIButton *)buyBT;

- (void)achieveClickEventWithbuyBlock:(BuyClickBlock)bock;

- (void)achieveClickEventWith:(CalculateClickBlock)caBlock buBlock:(BuyClickBlock)bock;


@end
