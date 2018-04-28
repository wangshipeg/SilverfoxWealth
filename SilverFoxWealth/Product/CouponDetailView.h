//
//  CouponDetailView.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponDetailView : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *couponImageView;
@property (weak, nonatomic) IBOutlet UILabel *amountLB;
@property (weak, nonatomic) IBOutlet UILabel *couponInfoLB;
@property (nonatomic, assign) NSInteger index;


@end
