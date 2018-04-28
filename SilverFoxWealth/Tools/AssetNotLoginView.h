


#import <UIKit/UIKit.h>
#import "RoundCornerClickBT.h"

typedef void (^LogInBlock)();


@interface AssetNotLoginView : UIView
@property (nonatomic, copy) LogInBlock loginBlock;

- (id)initWithFrame:(CGRect)frame noteTitle:(NSString *)noteTitle btTitle:(NSString *)btTitle;

- (void)logInWith:(LogInBlock)lgBlock;


@end
