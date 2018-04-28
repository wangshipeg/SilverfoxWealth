//
//  CollectPrincipalCell.h
//  SilverFoxWealth
//
//  Created by 丿Love_wcx丶灬丨 紫軒 on 2018/4/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VipBannerView.h"

@interface CollectPrincipalCell : UICollectionViewCell

/** bgView */
@property (nonatomic, strong) UIView *bgView;

/** banner */
@property (nonatomic, strong) VipBannerView *bannerView;

/** money */
@property (nonatomic, strong) UILabel *collectPrincipalLabel;

@end
