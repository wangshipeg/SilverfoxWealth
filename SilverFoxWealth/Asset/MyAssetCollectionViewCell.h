//
//  MyAssetCollectionViewCell.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2018/4/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAssetCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLB;
@property (nonatomic, strong) UILabel *viceNameLB;

- (void)assetCellContentWith:(NSDictionary *)dic;

@end
