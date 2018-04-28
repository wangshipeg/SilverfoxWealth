

#import "AddCancelButton.h"
#import "UILabel+LabelStyle.h"
#import "UIBarButtonItem+SXCreate.h"

@implementation AddCancelButton

+ (UIView *)addCompleteBTOnVC:(UIViewController *)VC withSelector:(SEL)withSelector title:(NSString *)title {
    UIView *dismissView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(VC.view.frame), 43)];
    dismissView.backgroundColor=[UIColor backgroundGrayColor];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor iconBlueColor] forState:UIControlStateNormal];
    button.backgroundColor=[UIColor clearColor];
    button.frame=CGRectMake(CGRectGetWidth(dismissView.frame) - 60, 0, 60, 43);
    [button addTarget:VC action:withSelector forControlEvents:UIControlEventTouchUpInside];
    [dismissView addSubview:button];
    return dismissView;
}

+ (void)addCustomBarButtonItemWith:(SEL)clickSelector targetVC:(UIViewController *)targetVC image:(UIImage *)image{
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(0, 0, 60, 44);
    [firstButton setImage:image forState:UIControlStateNormal];
    [firstButton addTarget:targetVC action:clickSelector forControlEvents:UIControlEventTouchUpInside];
    if (@available(iOS 11.0, *)) {
        firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:firstButton];
    targetVC.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

+ (void)addCustomRightBarButtonItemWith:(SEL)clickSelector targetVC:(UIViewController *)targetVC image:(UIImage *)image
{
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(0, 0, 44, 44);
    [firstButton setImage:image forState:UIControlStateNormal];
    [firstButton addTarget:targetVC action:clickSelector forControlEvents:UIControlEventTouchUpInside];
    if (@available(iOS 11.0, *)) {
        firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:firstButton];
    targetVC.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

+ (void)addCustomRightTextBarButtonItemWith:(SEL)clickSelector targetVC:(UIViewController *)targetVC title:(NSString *)title
{
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.frame = CGRectMake(0, 0, 75, 44);
    firstButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [firstButton setTitle:title forState:UIControlStateNormal];
    [firstButton setTitleColor:[UIColor iconBlueColor] forState:UIControlStateNormal];
    [firstButton addTarget:targetVC action:clickSelector forControlEvents:UIControlEventTouchUpInside];
    if (@available(iOS 11.0, *)) {
        firstButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    }
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:firstButton];
    targetVC.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

//给TextField添加leftview
+ (UIView *)addTextFieldLeftViewWithTitle:(NSString *)title width:(CGFloat)width {
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, width+15, 20)];
    view.backgroundColor=[UIColor clearColor];
    UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, width, 20)];
    [view addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top);
        make.bottom.equalTo(view.mas_bottom);
        make.left.equalTo(view.mas_left).offset(15);
    }];
    lb.text=title;
    lb.textAlignment=NSTextAlignmentLeft;
    [lb decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:14] characterColor:[UIColor characterBlackColor]];
    return view;
}

//给TextField添加leftview (imageView)
+ (UIView *)addTextFieldLeftViewWithImage:(NSString *)imageName width:(CGFloat)width
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 20)];
    view.backgroundColor=[UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top);
        make.bottom.equalTo(view.mas_bottom);
        make.left.equalTo(view.mas_left).offset(10);
        make.width.equalTo(@15);
    }];
    return view;
}



@end
