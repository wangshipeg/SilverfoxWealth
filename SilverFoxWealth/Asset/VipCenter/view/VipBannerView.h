//
//  VipBannerView.h
//  SilverFoxWealth
//
//  Created by 丿Love_wcx丶灬丨 紫軒 on 2018/4/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface VipBannerViewCell : UIView

/** vipView */
@property (nonatomic, strong) UIImageView *vipImgView;

/** currentLevel */
@property (nonatomic, strong) UILabel *currentLevelLabel;

/** principal */
@property (nonatomic, strong) UILabel *principalLabel;

@end

@interface VipBannerView : UIView <iCarouselDelegate, iCarouselDataSource>

@property (nonatomic,strong) iCarousel *myCarousel;

/** block */
@property (nonatomic, copy) void (^selectedCallBack)(NSInteger index);

/** data */
@property (nonatomic, strong) NSArray *rangeArray;

@end
