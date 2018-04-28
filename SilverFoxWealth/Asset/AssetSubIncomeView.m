

#import "AssetSubIncomeView.h"
#import "UILabel+LabelStyle.h"

@implementation AssetSubIncomeView

- (id)initWithTitle:(NSString *)title {
    self=[super init];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
        _contentLB=[[UILabel alloc] init];
        [self addSubview:_contentLB];
        _contentLB.textAlignment = NSTextAlignmentCenter;
        [_contentLB decorateLabelStyleWithCharacterFont:[UIFont fontWithName:@"Helvetica" size:20]characterColor:[UIColor whiteColor]];
        _contentLB.text=@"";
        _contentLB.adjustsFontSizeToFitWidth = YES;
        [_contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.top.equalTo(self.mas_top);
            make.height.equalTo(@30);
        }];
        
        UILabel *titleLB=[[UILabel alloc] init];
        [self addSubview:titleLB];
        titleLB.textAlignment = NSTextAlignmentCenter;
        titleLB.text=title;
        [titleLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:13] characterColor:[UIColor whiteColor]];
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.contentLB.mas_bottom);
            make.width.equalTo(self.mas_width);
            make.height.equalTo(@15);
        }];
    }
    return self;
}


@end

