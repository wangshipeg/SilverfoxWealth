

#import "CustomerSeparateTableViewCell.h"
#import "AssetFormationModel.h"
#import "UAProgressView.h"

@interface AssetsFormationWithDetailCell : CustomerSeparateTableViewCell

@property (nonatomic, strong) UILabel *nameLB;
@property (nonatomic, strong) UILabel *moneyLB;
@property (nonatomic, strong) UILabel *moneyTextLB;
@property (nonatomic, strong) UAProgressView *progressView;
@property (nonatomic, strong) UILabel *label;
- (void)assetFormationWith:(AssetFormationModel *)dic;

@end
