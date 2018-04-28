

#import "AssetNotLoginView.h"
#import "UILabel+LabelStyle.h"
#import "FastAnimationAdd.h"

@implementation AssetNotLoginView

- (id)initWithFrame:(CGRect)frame noteTitle:(NSString *)noteTitle btTitle:(NSString *)btTitle  {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=[UIColor backgroundGrayColor];
        UIView *contentBackView=[[UIView alloc] init];
        [self addSubview:contentBackView];
        contentBackView.backgroundColor=[UIColor backgroundGrayColor];
        [contentBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@306);
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
        }];
        
        UIImageView *foxImageV=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NoDataFox.png"]];
        [contentBackView addSubview:foxImageV];
        [foxImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentBackView.mas_top);
            make.width.equalTo(@130);
            make.height.equalTo(@122);
            make.centerX.equalTo(contentBackView.mas_centerX).offset(18);
        }];
        
       UILabel *notLoginLB=[[UILabel alloc] init];
        [contentBackView addSubview:notLoginLB];
        notLoginLB.text = noteTitle;
        [notLoginLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor zheJiangBusinessRedColor]];
        notLoginLB.textAlignment=NSTextAlignmentCenter;
        [notLoginLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(foxImageV.mas_bottom).offset(25);
            make.left.equalTo(contentBackView.mas_left).offset(15);
            make.right.equalTo(contentBackView.mas_right).offset(-15);
            make.height.equalTo(@20);
        }];
        
        RoundCornerClickBT *loginBT = [RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
        [contentBackView addSubview:loginBT];
        loginBT.backgroundColor=[UIColor zheJiangBusinessRedColor];
        loginBT.titleLabel.font=[UIFont systemFontOfSize:18];
        [loginBT setTitle:btTitle forState:UIControlStateNormal];
        [loginBT addTarget:self action:@selector(logIn:) forControlEvents:UIControlEventTouchUpInside];
        [FastAnimationAdd codeBindAnimation:loginBT];
        [loginBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(notLoginLB.mas_bottom).offset(70);
            make.left.equalTo(contentBackView.mas_left).offset(43);
            make.right.equalTo(contentBackView.mas_right).offset(-43);
            make.height.equalTo(@45);
        }];
    }
    return self;
}

- (void)logInWith:(LogInBlock)lgBlock{
    _loginBlock=lgBlock;
}

- (void)logIn:(UIButton *)sender {
    _loginBlock();
    
}

@end
