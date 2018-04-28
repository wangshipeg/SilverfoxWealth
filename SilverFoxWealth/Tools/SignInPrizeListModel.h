//
//  SignInPrizeListModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface SignInPrizeListModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *answerA;
@property (nonatomic, strong) NSString *answerB;
@property (nonatomic, strong) NSString *answerC;
@property (nonatomic, strong) NSString *answerD;
@property (nonatomic, strong) NSString *days;//累计天数(可送奖励)
@property (nonatomic, strong) NSString *giveNum;
@property (nonatomic, strong) NSString *giveType;// 1银子 2红包 3收益
@property (nonatomic, strong) NSString *idStr;//奖励id
@property (nonatomic, strong) NSString *question;//问题
@property (nonatomic, strong) NSString *rightAnswer;//正确答案

/*
 id:1,
 days:15,
 question:”领奖问题”,
 answerA:”答案A”,
 answerB:”答案B”,
 answerC:”答案C”,
 answerD:”答案D”,
 rightAnswer:1,//正确答案序号
 giveType:1,//1：银子2:红包，3：加息券
 giveNum:10//赠送数量
*/
@end





