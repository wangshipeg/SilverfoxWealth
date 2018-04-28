//
//  NewHTMLVC.h
//  SilverFoxWealth
//
//  Created by SilverFox on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    productAdPage,         //产品广告
    productAdContent,      //产品广告外部链接
    noviceGuide,           //新手引导
    signinRule,            //签到规则
    serveProtocol,        //产品协议
    serveProtocolTwo,
    serveProtocolThree,
    invitorFriend,         //邀请好友
    LuckDraw,               //银子商城抽奖
    safeEnsure,          //信息披露
    myFinancing,             //理财历程
    
    MemberWithdrawals,             //提现次数
    MemberBirthday,               // 生日福利
    MemberCoupon,                 // 专属优惠券
    MemberAdviser,             //专属理财顾问
    MemberPatch_card,               // 补签卡
    MemberDiscount,                 // 折扣
    MemberInterest,               // 补签卡
    MemberBill,                 // 折扣
    MemberLevelInstructions     //等级说明
}work_net;

@interface NewHTMLVC : UIViewController
@property (nonatomic, assign) work_net  work;
@property (nonatomic, copy) NSString *account;
@property (nonatomic , copy)NSString *productOfID;



@end
