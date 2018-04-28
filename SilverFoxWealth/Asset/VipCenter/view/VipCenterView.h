//
//  VipCenterView.h
//  SilverFoxWealth
//
//  Created by 丿Love_wcx丶灬丨 紫軒 on 2018/4/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VipCenterViewController.h"

@interface VipCenterView : UIView

/** viewController */
@property (nonatomic, strong) VipCenterViewController *vipVC;

@property (nonatomic, retain) UICollectionView *collectionView;
/** vipInfo */
@property (nonatomic, strong) NSDictionary *dict;

/** unPaybackPrincipal */
@property (nonatomic, strong) NSDictionary *unPaybackPrincipalDict;


@end
