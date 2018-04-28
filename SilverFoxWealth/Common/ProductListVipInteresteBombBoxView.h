//
//  ProductListVipInteresteBombBoxView.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2018/4/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductListVipInteresteBombBoxView : UIView
@property (strong, nonatomic) IBOutlet UILabel *gradeLB;
@property (strong, nonatomic) IBOutlet UILabel *vipInterest;
@property (strong, nonatomic) IBOutlet UIImageView *vipInterestImgView;


- (void)showVipIntersterBombBoxView;
@end
