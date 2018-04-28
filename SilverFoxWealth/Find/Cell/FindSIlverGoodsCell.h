//
//  FindSIlverGoodsCell.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/1/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CustomerSeparateTableViewCell.h"
#import "FindSilverTraderModel.h"

typedef void (^SilverGoodsOneBlock)();//0元夺宝
typedef void (^SilverGoodsTwoBlock)();//抽奖
@interface FindSIlverGoodsCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *phoneImg;
@property (nonatomic, strong) UIView *alphaGrayView;
@property (nonatomic, strong) UILabel *nameLB;
@property (nonatomic, strong) UILabel *silverLB;
@property (nonatomic, strong) UILabel *residueLB;//剩余件数
@property (nonatomic, strong) UILabel *discountLB;
@property (nonatomic, strong) UIImageView *discountImgV;

@property (nonatomic, copy) SilverGoodsOneBlock oneBlcok;
@property (nonatomic, copy) SilverGoodsTwoBlock twoBlock;

- (void)silverGoodsOne:(SilverGoodsOneBlock)oneBlock;
- (void)silverGoodsTwo:(SilverGoodsTwoBlock)twoBlock;

- (void)setUpSilverGoodsListData:(FindSilverTraderModel *)dic discountStr:(NSString *)discount;

@end
