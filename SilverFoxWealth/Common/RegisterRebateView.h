//
//  RegisterRebateView.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/3/21.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterRebateView : UIView
@property (strong, nonatomic) IBOutlet UILabel *couponAmount;
@property (strong, nonatomic) IBOutlet UILabel *couponType;

- (void)showRegisterRebateView;
@end
