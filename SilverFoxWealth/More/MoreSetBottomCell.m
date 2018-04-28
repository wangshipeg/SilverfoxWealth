

#import "MoreSetBottomCell.h"
#import "UILabel+LabelStyle.h"

@implementation MoreSetBottomCell

- (id)initWithTitle:(NSString *)title imageName:(NSString *)imageName {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self) {
        
        UIImageView *imageV=[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        [self addSubview:imageV];
        imageV.contentMode=UIViewContentModeScaleAspectFit;
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
        
        UILabel *titleLB=[[UILabel alloc] init];
        [self addSubview:titleLB];
        titleLB.text=title;
        [titleLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(51);
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.equalTo(@20);
        }];
        
        
    }
    return self;
}

@end
