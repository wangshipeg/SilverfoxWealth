//
//  HeadViewCell.h
//  SilverFoxWealth
//
//  Created by SilverFox on 16/3/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundCornerClickBT.h"

typedef void (^LogInBlock)();
typedef void (^UserSilverNumBlock)();//登录/兑换记录
typedef void (^MoreGoodsBlock)();//更多
typedef void (^BannerImageBlock)();//banner图

@interface HeadViewCell : UICollectionViewCell
@property (nonatomic, copy) LogInBlock loginBlock;
@property (nonatomic, copy) UserSilverNumBlock silverNum;
@property (nonatomic, copy) MoreGoodsBlock goodsBlock;
@property (nonatomic, copy) BannerImageBlock bannerBlock;

@property (nonatomic, strong) RoundCornerClickBT *headBT;
@property (nonatomic, strong) UILabel *headLB;
@property (nonatomic, strong) UILabel *goodsNameLB;
@property (nonatomic, strong) UIButton *moreBT;
@property (nonatomic, strong) UIImageView *bannerImage;

- (void)logInWith:(LogInBlock)lgBlock;

- (void)userSilverNumWith:(UserSilverNumBlock)siverNumBlock;
- (void)moreGoodsWith:(MoreGoodsBlock)goodsBlock;
- (void)bannerImageWith:(BannerImageBlock)bannerBlock;

@end











