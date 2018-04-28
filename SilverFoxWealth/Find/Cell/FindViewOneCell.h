//
//  FindViewOneCell.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/1/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CustomerSeparateTableViewCell.h"


typedef void (^ZeroIndianaBlock)();//0元夺宝
typedef void (^LuckDrawBlock)();//抽奖
typedef void (^EarnSilverBlock)();//赚银子

@interface FindViewOneCell : UITableViewCell

@property (nonatomic, strong) UIButton *headBTOne;
@property (nonatomic, strong) UIButton *headBTTwo;
@property (nonatomic, strong) UIButton *headBTThree;

@property (nonatomic, copy) ZeroIndianaBlock zeroIndiana;
@property (nonatomic, copy) LuckDrawBlock luckDraw;
@property (nonatomic, copy) EarnSilverBlock earnSilver;

- (instancetype)initWithOtherReuseIdentifier:(NSString *)reuseIdentifier;

- (void)zeroIndianaWith:(ZeroIndianaBlock)zeroIndianaBlock;
- (void)luckDrawWith:(LuckDrawBlock)luckDrawBlock;
- (void)earnSilverWith:(EarnSilverBlock)earnSilverBlock;
@end
