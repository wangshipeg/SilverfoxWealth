//
//  NoRegisterAccountVC.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/12/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSAuthDetailViewController.h"

@interface NoRegisterAccountVC : UIViewController

@property (nonatomic, strong) NSString *phoneStr;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) UMSAuthInfo *authInfo;

@end
