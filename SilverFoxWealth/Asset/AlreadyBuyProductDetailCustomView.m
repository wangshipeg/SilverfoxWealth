
#import "AlreadyBuyProductDetailCustomView.h"
#import "UILabel+LabelStyle.h"

@implementation AlreadyBuyProductDetailCustomView


- (id)initWithTitle:(NSString *)title contentLB:(UILabel *)contentLB  {
    self = [super init];
    if (self) {
        
        self.backgroundColor=[UIColor whiteColor];
        
        UILabel *titleLB=[[UILabel alloc] init];
        [self addSubview:titleLB];
        [titleLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
        titleLB.text=title;
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@110);
            make.height.equalTo(@20);
        }];
        
        [self addSubview:contentLB];
        [contentLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor depictBorderGrayColor]];
        contentLB.textAlignment=NSTextAlignmentRight;
        [contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-40);
            make.height.equalTo(@20);
            make.width.equalTo(@140);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title imageView:(UIImageView *)image contentLB:(UILabel *)contentLB
{
    self = [super init];
    if (self) {
        
        self.backgroundColor=[UIColor whiteColor];
        
        UILabel *titleLB=[[UILabel alloc] init];
        [self addSubview:titleLB];
        [titleLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
        titleLB.text=title;
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@110);
            make.height.equalTo(@20);
        }];
        
        [self addSubview:contentLB];
        [contentLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
        [contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-40);
            make.height.equalTo(@20);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [self addSubview:image];
        image.contentMode = UIViewContentModeScaleAspectFit;
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@25);
            make.height.equalTo(@25);
            make.right.equalTo(contentLB.mas_left).offset(-5);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title imageView:(UIImageView *)image
{
    self = [super init];
    if (self) {
        
        self.backgroundColor=[UIColor whiteColor];
        
        UILabel *titleLB=[[UILabel alloc] init];
        [self addSubview:titleLB];
        [titleLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
        titleLB.text=title;
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@110);
            make.height.equalTo(@20);
        }];
        
        [self addSubview:image];
        image.contentMode = UIViewContentModeScaleAspectFit;
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@8);
            make.height.equalTo(@25);
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;

}


@end



