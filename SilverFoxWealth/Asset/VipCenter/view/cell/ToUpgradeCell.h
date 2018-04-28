//
//  ToUpgradeCell.h
//  SilverFoxWealth
//
//  Created by 丿Love_wcx丶灬丨 紫軒 on 2018/4/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToUpgradeCell : UICollectionViewCell

/** upgrade */
@property (nonatomic, strong) UIButton *toUpgradeBtn;

/** block */
@property (nonatomic, copy) void (^clickCallBack)();

@end
