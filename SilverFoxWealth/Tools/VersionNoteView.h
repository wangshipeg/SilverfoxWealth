//
//  VersionNoteView.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/7/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UpdateVersionBlock)();

@interface VersionNoteView : UIView
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, copy) UpdateVersionBlock updateBlock;

- (id)initWithFrame:(CGRect)frame forceUpdate:(BOOL)forceUpdate;

- (void)showWithUpdateBlock:(UpdateVersionBlock)up;



@end
