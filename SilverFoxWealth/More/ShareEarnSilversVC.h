//
//  ShareEarnSilversVC.h
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareView.h"
#import "EarnSilversModel.h"

@interface ShareEarnSilversVC : UIViewController

@property (strong, nonatomic) UIWebView *webView;
@property (nonatomic, strong) EarnSilversModel *shareModel;
@property (nonatomic, strong) ShareView      *shareView;

@end
