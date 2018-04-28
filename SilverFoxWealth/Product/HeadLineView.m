

#import "HeadLineView.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface HeadLineView()
{
    UIButton *currentSelected;
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    UILabel *label4;
    //按钮的数据
    NSMutableArray * buttonArray;
}
@end
@implementation HeadLineView
-(instancetype)init
{
    if (self = [super init]) {
        
        buttonArray = [[NSMutableArray alloc]init];
    }
    return self;
}

//传入currentIndex
-(void)setCurrentIndex:(NSInteger)CurrentIndex
{
    _CurrentIndex = CurrentIndex;//改变currentIndex
    [self shuaxinJiemian:_CurrentIndex];
    if ([_delegate respondsToSelector:@selector(refreshHeadLine:)]) {
        [_delegate refreshHeadLine:_CurrentIndex];
    }
}

//刷新界面
-(void)shuaxinJiemian:(NSInteger)index;
{
    if (buttonArray.count>0) {
        if (buttonArray.count == 4) {
            for (UIButton *labelView in buttonArray) {
                if (labelView.tag==index) {
                    if (labelView.tag==0) {
                        [labelView setTitleColor:[UIColor zheJiangBusinessRedColor] forState:UIControlStateNormal];
                        label1.backgroundColor = [UIColor zheJiangBusinessRedColor];
                    }else if(labelView.tag==1){
                        [labelView setTitleColor:[UIColor zheJiangBusinessRedColor] forState:UIControlStateNormal];
                        label2.backgroundColor=[UIColor zheJiangBusinessRedColor];
                    }else if(labelView.tag == 2){
                        [labelView setTitleColor:[UIColor zheJiangBusinessRedColor] forState:UIControlStateNormal];
                        label3.backgroundColor=[UIColor zheJiangBusinessRedColor];
                    }else{
                        [labelView setTitleColor:[UIColor zheJiangBusinessRedColor] forState:UIControlStateNormal];
                        label4.backgroundColor=[UIColor zheJiangBusinessRedColor];
                    }
                    currentSelected=labelView;
                }else{
                    if (labelView.tag==0) {
                        [labelView setTitleColor:[UIColor characterBlackColor] forState:UIControlStateNormal];
                        label1.backgroundColor=[UIColor typefaceGrayColor];
                    }else if(labelView.tag==1){
                        [labelView setTitleColor:[UIColor characterBlackColor] forState:UIControlStateNormal];
                        label2.backgroundColor=[UIColor typefaceGrayColor];
                    }else if(labelView.tag==2){
                        [labelView setTitleColor:[UIColor characterBlackColor] forState:UIControlStateNormal];
                        label3.backgroundColor=[UIColor typefaceGrayColor];
                    }else{
                        [labelView setTitleColor:[UIColor characterBlackColor] forState:UIControlStateNormal];
                        label4.backgroundColor=[UIColor typefaceGrayColor];
                    }
                }
            }
        }else if (buttonArray.count == 2){
            for (UIButton *labelView in buttonArray) {
                if (labelView.tag==index) {
                    if (labelView.tag==0) {
                        [labelView setTitleColor:[UIColor zheJiangBusinessRedColor] forState:UIControlStateNormal];
                        label1.backgroundColor = [UIColor zheJiangBusinessRedColor];
                    }else{
                        [labelView setTitleColor:[UIColor zheJiangBusinessRedColor] forState:UIControlStateNormal];
                        label2.backgroundColor=[UIColor zheJiangBusinessRedColor];
                    }
                    currentSelected=labelView;
                }else{
                    if (labelView.tag==0) {
                        [labelView setTitleColor:[UIColor characterBlackColor] forState:UIControlStateNormal];
                        label1.backgroundColor=[UIColor typefaceGrayColor];
                    }else{
                        [labelView setTitleColor:[UIColor characterBlackColor] forState:UIControlStateNormal];
                        label2.backgroundColor=[UIColor typefaceGrayColor];
                    }
                }
            }
        }
    }
}

//按钮点击 传入代理
-(void)buttonClick:(UIButton*)button
{
    NSInteger viewTag=[button tag];
    if ([button isEqual:currentSelected]) {
        return;
    }
    _CurrentIndex=viewTag;
    [self shuaxinJiemian:_CurrentIndex];
    if ([_delegate respondsToSelector:@selector(refreshHeadLine:)]) {
        [_delegate refreshHeadLine:_CurrentIndex];
    }
}

//传入顶部的title
-(void)setTitleArray:(NSArray *)titleArray
{
    if (titleArray.count == 4) {
        _titleArray=titleArray;
        UIButton * btn=NULL;
        CGFloat width=WIDTH/_titleArray.count;
        for (int i = 0; i < _titleArray.count; i++) {
            btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(i*width, 0, width, 48);
            btn.tag = i;
            [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
            btn.titleLabel.textAlignment=NSTextAlignmentCenter;
            btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            [btn setBackgroundColor:[UIColor whiteColor]];
            
            [btn setUserInteractionEnabled:YES];
            [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [buttonArray addObject:btn];
            [self addSubview:btn];
            if (i == 0) {
                currentSelected = btn;
                [btn setTitleColor:[UIColor zheJiangBusinessRedColor] forState:UIControlStateNormal];
                label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 45.5, WIDTH/4, 1.5)];
                label1.backgroundColor = [UIColor zheJiangBusinessRedColor];
                [self addSubview:label1];
            }else if(i == 1){
                [btn setTitleColor:[UIColor characterBlackColor] forState:UIControlStateNormal];
                label2 = [[UILabel alloc]initWithFrame:CGRectMake(width, 45.5, WIDTH/4, 1.5)];
                label2.backgroundColor = [UIColor typefaceGrayColor];
                [self addSubview:label2];
            }else if(i == 2){
                [btn setTitleColor:[UIColor characterBlackColor] forState:UIControlStateNormal];
                label3 = [[UILabel alloc]initWithFrame:CGRectMake(width * 2, 45.5, WIDTH/4, 1.5)];
                label3.backgroundColor = [UIColor typefaceGrayColor];
                [self addSubview:label3];
            }else{
                [btn setTitleColor:[UIColor characterBlackColor] forState:UIControlStateNormal];
                label4 = [[UILabel alloc]initWithFrame:CGRectMake(width * 3, 45.5, WIDTH/4, 1.5)];
                label4.backgroundColor = [UIColor typefaceGrayColor];
                [self addSubview:label4];
                
            }
        }
    }else if(titleArray.count == 2){
        _titleArray=titleArray;
        UIButton * btn=NULL;
        CGFloat width=WIDTH/_titleArray.count;
        for (int i = 0; i < _titleArray.count; i++) {
            btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(i*width, 0, width, 48);
            btn.tag = i;
            [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
            btn.titleLabel.textAlignment=NSTextAlignmentCenter;
            btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            [btn setBackgroundColor:[UIColor whiteColor]];
            
            [btn setUserInteractionEnabled:YES];
            [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [buttonArray addObject:btn];
            [self addSubview:btn];
            if (i == 0) {
                currentSelected = btn;
                [btn setTitleColor:[UIColor zheJiangBusinessRedColor] forState:UIControlStateNormal];
                label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 45.5, WIDTH/2, 1.5)];
                label1.backgroundColor = [UIColor zheJiangBusinessRedColor];
                [self addSubview:label1];
            }else{
                [btn setTitleColor:[UIColor characterBlackColor] forState:UIControlStateNormal];
                label2 = [[UILabel alloc]initWithFrame:CGRectMake(width, 45.5, WIDTH/2, 1.5)];
                label2.backgroundColor = [UIColor typefaceGrayColor];
                [self addSubview:label2];
                
            }
        }

    }
}
@end
