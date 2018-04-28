

#import "MoreBaseCell.h"
#import "UILabel+LabelStyle.h"
#import "StringHelper.h"


@implementation MoreBaseCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
//        UIImageView *imageV=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginHead.png"]];
//        [self addSubview:imageV];
//        imageV.contentMode=UIViewContentModeScaleAspectFit;
//        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left).offset(15);
//            make.centerY.equalTo(self.mas_centerY);
//            make.width.equalTo(@25);
//            make.height.equalTo(@25);
//        }];
        
        _nameAndPhoneNumLB=[[UILabel alloc] init];
        [self addSubview:_nameAndPhoneNumLB];
        [_nameAndPhoneNumLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:18] characterColor:[UIColor characterBlackColor]];
        [_nameAndPhoneNumLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@180);
            make.height.equalTo(@20);
        }];
        
        _individualCenter=[[UILabel alloc] init];
        [self addSubview:_individualCenter];
        _individualCenter.text=@"个人中心";
        [_individualCenter decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
        [_individualCenter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@80);
            make.height.equalTo(@20);
        }];
        
        _noteLoginLB=[[UILabel alloc] init];
        [self addSubview:_noteLoginLB];
        _noteLoginLB.text=@"点击登录";
        _noteLoginLB.textAlignment=NSTextAlignmentRight;
        [_noteLoginLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor iconBlueColor]];
        [_noteLoginLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-40);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@70);
            make.height.equalTo(@20);
        }];
        
        UIImageView *arrowImageV=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AllowRight.png"]];
        [self addSubview:arrowImageV];
        arrowImageV.contentMode=UIViewContentModeScaleAspectFit;
        [arrowImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@10);
            make.height.equalTo(@15);
        }];
    }
    
    return self;
}

- (void)showDetailWith:(IndividualInfoManage *)user {
    if (user) {
        NSString *phoneNumStr=[StringHelper coverUsecellPhoneWith:user.cellphone];
        //如果用户有名字 名字和电话一起显示 否则只显示电话
        if (user.name.length != 0) {
            NSString *nameStr=[StringHelper coverUserNameWith:user.name];
            self.nameAndPhoneNumLB.text = [NSString stringWithFormat:@"%@ %@",nameStr,phoneNumStr];
        }else{
            self.nameAndPhoneNumLB.text = [NSString stringWithFormat:@"%@",phoneNumStr];
        }
        self.noteLoginLB.hidden=YES;
        self.individualCenter.hidden=YES;
    }else {
        self.nameAndPhoneNumLB.text=nil;
        self.noteLoginLB.hidden=NO;
        self.individualCenter.hidden=NO;
    }
}


@end
