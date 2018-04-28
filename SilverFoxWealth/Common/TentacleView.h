//
//  TentacleView.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/4/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResetDelegate <NSObject>
//把手势结果result 送出去 检查两次输入的是否一样
-(BOOL)resetPassword:(NSString *)result;
@end

@protocol VerificationDelegate <NSObject>
//把手势结果result 送出去供外界检查
-(BOOL)verification:(NSString *)result;
@end

@protocol TouchBeginDelegate <NSObject>
//把手势开始的状态传送出去
-(void)gestureTouchBegin;
@end

@interface TentacleView : UIView

@property (nonatomic, strong) NSArray *buttonArray; //接收外界送进来的button数组
@property (nonatomic, assign) NSInteger style; //1是验证  其它的是设置

@property (nonatomic, assign) id<VerificationDelegate> verificationDelegate;
@property (nonatomic, assign) id<ResetDelegate> resetDelegate;
@property (nonatomic, assign) id<TouchBeginDelegate> touchBeginDelegate;

//重置所有状态
-(void)enterArgin;


























@end
