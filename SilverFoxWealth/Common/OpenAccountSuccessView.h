//
//  OpenAccountSuccessView.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/7/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenAccountSuccessView : UIView
@property (strong, nonatomic) IBOutlet UILabel *nameLB;
@property (strong, nonatomic) IBOutlet UILabel *accountIdLB;

- (void)showOpenAccountSuccessView;
@end
