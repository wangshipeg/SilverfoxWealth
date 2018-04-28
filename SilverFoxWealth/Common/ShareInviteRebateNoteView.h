//
//  ShareInviteRebateNoteView.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/9/9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareInviteRebateNoteView : UIView
@property (nonatomic, copy) void (^immediatelyShareBlock)();

- (void)show;

@end
