

#import "CalculateView.h"
#import "CalculateProductInfo.h"

@implementation CalculateView
{
    UIView *upLayerView;
}

- (void)show {
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    if (![window.subviews containsObject:self]) {
        CGRect windowFrame=window.frame;
        UIView *overlayView=[[UIView alloc] initWithFrame:windowFrame];
        overlayView.backgroundColor=[UIColor clearColor];
        upLayerView=[[UIView alloc] initWithFrame:windowFrame];
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
        
        CGFloat surplusHeight = CGRectGetHeight(windowFrame)-216-20-25;
        CGFloat tradePasswordHeight=CGRectGetHeight(self.frame);
        if (surplusHeight<tradePasswordHeight) {
            tradePasswordHeight=surplusHeight;
        }
        if (IS_iPhoneX) {
            self.frame=CGRectMake(10,CGRectGetHeight(windowFrame)-216-20-64-tradePasswordHeight, CGRectGetWidth(windowFrame)-10*2, tradePasswordHeight);
        }else{
            self.frame=CGRectMake(10,CGRectGetHeight(windowFrame)-216-20-tradePasswordHeight, CGRectGetWidth(windowFrame)-10*2, tradePasswordHeight);
        }
        
        self.alpha=0;
        [overlayView addSubview:self];
        [self showValue];
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha=1;
        }];
    }
    [self calculateIncome:_jsBT];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        [self.sumTF resignFirstResponder];
        self.alpha=0;
        upLayerView.alpha=0;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
}

- (IBAction)calculateIncome:(UIButton *)sender
{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ( range.location >= 7 ) {
        return NO;
    }
    return YES;
}

- (IBAction)cancelBT:(UIButton *)sender {
    [self dismiss];
}

- (void)showValue {
    [self.sumTF becomeFirstResponder];
    self.sumTF.text = self.productModel.lowestMoney;
    self.sumTF.userInteractionEnabled=YES;    
    self.dateLB.text = [NSString stringWithFormat:@"%@",self.productModel.financePeriod];
    
    NSInteger sum;
    sum = [self.sumTF.text integerValue];
    NSInteger financePeriod = [self.productModel.financePeriod integerValue];
    CGFloat bankResult = sum*financePeriod*BankInterestRate/365;
    NSString *bankResultStr = [NSString stringWithFormat:@"%.2lf",round(bankResult*100)/100];
    self.bankResultLB.text = bankResultStr;
    
    self.showResultLB.text = [CalculateProductInfo calculateProdcutYearIncome:_productModel purchaseNum:[self.sumTF.text integerValue]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectionNameTFText:) name:UITextFieldTextDidChangeNotification object:self.sumTF];
}

- (void)detectionNameTFText:(NSNotification *)sender
{
    NSInteger sum;
    sum = [self.sumTF.text integerValue];
    NSInteger financePeriod = [self.productModel.financePeriod integerValue];
    CGFloat bankResult = sum*financePeriod*BankInterestRate/365;
    NSString *bankResultStr = [NSString stringWithFormat:@"%.2lf",round(bankResult*100)/100];
    self.bankResultLB.text = bankResultStr;
    self.showResultLB.text = [CalculateProductInfo calculateProdcutYearIncome:_productModel purchaseNum:[self.sumTF.text integerValue]];
}


@end
