//
//  NoteNothingNetView.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/6/12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "NoteNothingNetView.h"
#import "CommunalInfo.h"


@implementation NoteNothingNetView

- (void)addView {

    self.backgroundColor=[UIColor colorWithRed:251 green:246 blue:228];
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 15, 15)];
    imageView.image=[UIImage imageNamed:@"NothingNetNote.png"];
    [self addSubview:imageView];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+10, 7, 250, 15)];
    label.text=@"暂无网络连接，请检查您的网络设置！";
    label.textColor=[UIColor characterBlackColor];
    label.font=[UIFont systemFontOfSize:12];
    [self addSubview:label];
    
}


@end
