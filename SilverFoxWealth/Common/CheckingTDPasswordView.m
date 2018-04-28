
#import "CheckingTDPasswordView.h"


@implementation CheckingTDPasswordView
{
    UIView *upLayerView;
    NSInteger currentStrIndex; //记录当前输入框字符的序号
    
}
- (void)cancel:(inputFinishCancel)cancelBlock{
    _inputFinishCancelBlock = cancelBlock;
}

-(void)show:(inputFinish)myblock {
    
    _inputPasswordFinishBlock=myblock;
    
    if (!_blackPointList) {
        _blackPointList=[NSMutableDictionary dictionary];
    }else {
        [_blackPointList removeAllObjects];
    }
    currentStrIndex=-1;
    
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    
    if (![window.subviews containsObject:self]) {
        
        CGRect windowFrame=window.frame;
        
        UIView *overlayView=[[UIView alloc] initWithFrame:windowFrame];
        overlayView.backgroundColor=[UIColor clearColor];
        
        if (!upLayerView) {
           upLayerView=[[UIView alloc] initWithFrame:windowFrame];
        }
        upLayerView.backgroundColor=[UIColor blackColor];
        upLayerView.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [upLayerView addGestureRecognizer:tap];
        upLayerView.alpha=0.0;
        [overlayView addSubview:upLayerView];
        
        [window addSubview:overlayView];
        
        [UIView animateWithDuration:0.6 animations:^{
            upLayerView.alpha=0.3;
        }];
        CGFloat tradePasswordHeight=CGRectGetHeight(self.frame);
        self.frame=CGRectMake(10, CGRectGetHeight(windowFrame)-216-30-tradePasswordHeight, CGRectGetWidth(windowFrame)-10*2, tradePasswordHeight);
        self.alpha=0;
        
        
        [overlayView addSubview:self];
        
        [self.passwordInputTF becomeFirstResponder];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha=1;
        }];
        
    }
}


-(void)dismiss {
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.passwordInputTF resignFirstResponder];
        self.alpha=0;
        upLayerView.alpha=0;
    } completion:^(BOOL finished) {
        self.passwordInputTF.text=nil;
        _resultStr=nil;
        [self detectionResultStrContent];
        [self deleteBlackPointView];
        [self.superview removeFromSuperview];
    }];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.location==6) {
        return NO;
    }
    
    NSInteger transformValue=range.location;
    _resultStr=nil;
    //如果是输入状态
    if (transformValue>currentStrIndex) {
        currentStrIndex=range.location;
        [self addBlackDot:range.location];
        if (range.location==5) {
            _resultStr=[textField.text stringByAppendingString:string];
        }
    }else if(transformValue==currentStrIndex ){ //如果是删除状态
        [self deleteBlockDot:range.location];
        currentStrIndex--;
    }
    [self detectionResultStrContent];
    //当输入第6个字符的时候 获取结果
    return YES;
}

- (void)detectionResultStrContent {
    
    if (_resultStr.length==6) {
        self.commitBT.backgroundColor=[UIColor zheJiangBusinessRedColor];
        self.commitBT.userInteractionEnabled=YES;
    }else{
        self.commitBT.backgroundColor=[UIColor typefaceGrayColor];
        self.commitBT.userInteractionEnabled=NO;
    }
    
}



- (IBAction)cancelAndAffirm:(UIButton *)sender {
    
    if (sender.tag==1) {
        [MobClick event:@"buy_check_trade_pwd_cancel"];
//        //验证密码
        if (_resultStr.length != 3) {
            //return;
            [self dismiss];
            _inputFinishCancelBlock(nil);
        }
    }
    
    if (sender.tag==2) {
        [MobClick event:@"buy_check_trade_pwd_sure"];
        //验证密码
        if (_resultStr.length != 6) {
            return;
        }
        _inputPasswordFinishBlock(_resultStr);
        [self dismiss];
    }
    
}


//根据序号添加黑点
-(void)addBlackDot:(NSUInteger)num {
    
    NSString *key=[NSString stringWithFormat:@"%lu",(unsigned long)num];
    
    if ([self.blackPointList objectForKey:key] != nil ) {
        
        BlackPointView *view=(BlackPointView *)[self.blackPointList objectForKey:key];
        [self.passWordCoverView addSubview:view];
        return;
    }
    
    CGFloat monadWidth=CGRectGetWidth(self.passWordCoverView.frame)/12;
    BlackPointView *view=[[BlackPointView alloc]  initWithFrame:CGRectMake(0, 0, 15, 15)];
    view.center=CGPointMake(monadWidth+2*num*monadWidth, CGRectGetHeight(self.passWordCoverView.frame)/2);
    view.backgroundColor=[UIColor iconBlueColor];
    [self.blackPointList setValue:view forKey:key];
    [self.passWordCoverView addSubview:view];
}

//根据序号删除黑点
- (void)deleteBlockDot:(NSUInteger)num {
    NSString *key=[NSString stringWithFormat:@"%lu",(unsigned long)num];
    BlackPointView *view=(BlackPointView *)[self.blackPointList objectForKey:key];
    [view removeFromSuperview];
}

//从框中 删除黑点
-(void)deleteBlackPointView {
    //重置当前序号
    currentStrIndex=-1;
    self.passwordInputTF.text=nil;
    for (UIView *blackView in [self.blackPointList allValues]) {
        [blackView removeFromSuperview];
    }
    
}




@end
