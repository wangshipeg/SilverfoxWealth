//
//  VersionNoteView.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/7/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "VersionNoteView.h"
#import "UILabel+LabelStyle.h"
#import "RoundCornerClickBT.h"
#import "VersionNoteBaseView.h"


@implementation VersionNoteView
{
    BOOL isFouceUpdate; //是否强制更新
    UIView *overlayView; //背景视图
    
}

//总共130

- (id)initWithFrame:(CGRect)frame forceUpdate:(BOOL)forceUpdate {
    self = [super initWithFrame:frame];
    if (self) {
        isFouceUpdate=forceUpdate;
        self.backgroundColor=[UIColor whiteColor];
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=5;
        
        UILabel *noteLB=[[UILabel alloc] init];
        [self addSubview:noteLB];
        noteLB.text=@"更新内容";
        noteLB.textAlignment=NSTextAlignmentCenter;
        [noteLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
        [noteLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(5);
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.equalTo(@20);
        }];
        
        _textView=[[UITextView alloc] init];
        [self addSubview:_textView];
        _textView.textColor=[UIColor characterBlackColor];
        _textView.editable=NO;
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(noteLB.mas_bottom).offset(5);
            make.left.equalTo(self.mas_left).offset(5);
            make.right.equalTo(self.mas_right).offset(-5);
            make.height.equalTo(@85);
        }];
        
        if (forceUpdate) {
            RoundCornerClickBT *affirmUpdateBT=[RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
            [self addSubview:affirmUpdateBT];
            [affirmUpdateBT setTitle:@"更新" forState:UIControlStateNormal];
            affirmUpdateBT.backgroundColor=[UIColor zheJiangBusinessRedColor];
            [affirmUpdateBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            affirmUpdateBT.titleLabel.font=[UIFont systemFontOfSize:15];
            [affirmUpdateBT addTarget:self action:@selector(passUpdateInfo) forControlEvents:UIControlEventTouchUpInside];
            [affirmUpdateBT mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_textView.mas_bottom).offset(5);
                make.left.equalTo(self.mas_left).offset(15);
                make.right.equalTo(self.mas_right).offset(-15);
                make.height.equalTo(@40);
            }];
        }else {
            RoundCornerClickBT *cancelUpdateBT=[RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
            [self addSubview:cancelUpdateBT];
            [cancelUpdateBT setTitle:@"忽略" forState:UIControlStateNormal];
            cancelUpdateBT.backgroundColor=[UIColor typefaceGrayColor];
            [cancelUpdateBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cancelUpdateBT.titleLabel.font=[UIFont systemFontOfSize:15];
            [cancelUpdateBT addTarget:self action:@selector(passCancelInfo) forControlEvents:UIControlEventTouchUpInside];
            [cancelUpdateBT mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_textView.mas_bottom).offset(5);
                make.left.equalTo(self.mas_left).offset(15);
                make.height.equalTo(@40);
            }];
            
            RoundCornerClickBT *updateBT=[RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
            [self addSubview:updateBT];
            [updateBT setTitle:@"更新" forState:UIControlStateNormal];
            updateBT.backgroundColor=[UIColor zheJiangBusinessRedColor];
            [updateBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            updateBT.titleLabel.font=[UIFont systemFontOfSize:15];
            [updateBT addTarget:self action:@selector(passUpdateInfo) forControlEvents:UIControlEventTouchUpInside];
            [updateBT mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_textView.mas_bottom).offset(5);
                make.left.equalTo(cancelUpdateBT.mas_right).offset(15);
                make.right.equalTo(self.mas_right).offset(-15);
                make.height.equalTo(@40);
                make.width.equalTo(cancelUpdateBT.mas_width);
            }];
        }
    }
    return self;
}


- (void)showWithUpdateBlock:(UpdateVersionBlock)up {

    self.updateBlock=up;
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    
    if (![window.subviews containsObject:self]) {
        CGRect windowFrame=window.frame;
        VersionNoteBaseView *twoView=[[VersionNoteBaseView alloc] initWithFrame:windowFrame];
        twoView.backgroundColor=[UIColor clearColor];
        [window addSubview:twoView];
        
        if (!overlayView) {
            overlayView=[[UIView alloc] initWithFrame:windowFrame];
        }
        overlayView.backgroundColor=[UIColor blackColor];
        overlayView.alpha=0.0;
        [twoView addSubview:overlayView];
        
        [UIView animateWithDuration:0.6 animations:^{
            overlayView.alpha=0.3;
        }];
        self.frame=CGRectMake(0, 0, CGRectGetWidth(windowFrame)-30*2, CGRectGetHeight(self.frame));
        self.center=twoView.center;
        [twoView addSubview:self];
    }
}

- (void)dismissView {
    [UIView animateWithDuration:0.3 animations:^{
        overlayView.alpha=0;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
}

//更新
- (void)passUpdateInfo {
    if (self.updateBlock) {
        self.updateBlock();
    }
}

//忽略
- (void)passCancelInfo {
    
    [self dismissView];

}





@end
