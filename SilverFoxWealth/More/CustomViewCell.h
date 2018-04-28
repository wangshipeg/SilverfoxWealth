

#import <UIKit/UIKit.h>
#import "FindSilverTraderModel.h"
@interface CustomViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *phoneImg;
@property (nonatomic, strong) UIView *alphaGrayView;
@property (nonatomic, strong) UILabel *nameLB;
@property (nonatomic, strong) UILabel *silverLB;
@property (nonatomic, strong) UILabel *residueLB;//剩余件数
@property (nonatomic, strong) UILabel *grayLineLB;
@property (nonatomic, strong) UILabel *discountLB;
@property (nonatomic, strong) UIImageView *discountImgV;

- (void)setUpSilverGoodsListData:(FindSilverTraderModel *)dic discountStr:(NSString *)discount;
@end
