

#import <UIKit/UIKit.h>
#import "BaseTabBarController.h"

static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow             *window;
@property (nonatomic, strong) BaseTabBarController *mainTab;
/**
 *共享应用实例
 */
+ (AppDelegate *)shareDelegate;



@end

