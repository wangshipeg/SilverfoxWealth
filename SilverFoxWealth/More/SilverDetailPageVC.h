//
//  SilverDetailPageVC.h
//  SilverFoxWealth
//
//  Created by SilverFox on 16/3/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindSilverTraderModel.h"

@interface SilverDetailPageVC : UIViewController

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *consumeSilver;
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *stockNumber;
@property (nonatomic, strong) FindSilverTraderModel *silverModel;

@end
