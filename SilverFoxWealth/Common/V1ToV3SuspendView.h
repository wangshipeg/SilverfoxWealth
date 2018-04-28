//
//  V1ToV3SuspendView.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2018/4/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface V1ToV3SuspendView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *vipInterestImgView;
@property (strong, nonatomic) IBOutlet UIButton *pushToDetailBT;
- (void)showVipIntersterBombBoxView;
@end
