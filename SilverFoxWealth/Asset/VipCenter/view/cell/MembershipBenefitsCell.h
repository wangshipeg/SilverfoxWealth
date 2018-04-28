//
//  MembershipBenefitsCell.h
//  SilverFoxWealth
//
//  Created by 丿Love_wcx丶灬丨 紫軒 on 2018/4/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MembershipBenefitsCell : UICollectionViewCell

/** icon */
@property (nonatomic, strong) UIImageView *iconImgView;

/** title */
@property (nonatomic, strong) UILabel *titleLabel;

/** subIcon */
@property (nonatomic, strong) UIImageView *subIconImgView;

/** subTitle */
@property (nonatomic, strong) UILabel *subLabel;

/** data */
@property (nonatomic, strong) NSDictionary *dict;

/** bool */
@property (nonatomic, assign) BOOL isFree;

/** index */
@property (nonatomic, assign) NSInteger cellIndex;

/** level */
@property (nonatomic, assign) NSInteger level;

/** key */
@property (nonatomic, copy) NSString *keyWord;

/** key1 */
@property (nonatomic, copy) NSString *keyWord1;

@end
