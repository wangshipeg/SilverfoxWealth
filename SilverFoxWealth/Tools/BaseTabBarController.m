

#import "BaseTabBarController.h"
#import "CommunalInfo.h"
#import "UITabBarItem+TabBarItemModify.h"
#import <SVProgressHUD.h>

#import "RefinedCommendVC.h"
#import "ProductVC.h"
#import "MyAssetVC.h"
#import "FindVC.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITabBar appearance] setBackgroundColor:[UIColor clearColor]];
    [UITabBar appearance].translucent = NO;

    RefinedCommendVC *refinedVC = [[RefinedCommendVC alloc] init];
    UIViewController *refinedNV = [self showVCTabBarItemWith:refinedVC imageInset:UIEdgeInsetsMake(5, 0, -5, 0)  mainImageStr:@"CommentIcon.png" selectedImageStr:@"CommentSelectIcon.png"];
    ProductVC *productVC = [[ProductVC alloc] init];
    UINavigationController *productNV = [self showVCTabBarItemWith:productVC imageInset:UIEdgeInsetsMake(5, 0, -5, 0) mainImageStr:@"ProductIcon.png" selectedImageStr:@"ProductSelectIcon.png"];
    FindVC *findVC = [[FindVC alloc] init];
    UINavigationController *findNV = [self showVCTabBarItemWith:findVC imageInset:UIEdgeInsetsMake(5, 0, -5, 0) mainImageStr:@"FindIcon.png" selectedImageStr:@"FindSelectIcon.png"];
    MyAssetVC *assetVC = [[MyAssetVC alloc] init];
    UINavigationController *assetNV = [self showVCTabBarItemWith:assetVC imageInset:UIEdgeInsetsMake(5, 0, -5, 0) mainImageStr:@"AssetIcon.png" selectedImageStr:@"AssetSelectIcon.png"];
    
    NSArray *vcArray = @[refinedNV,productNV,findNV,assetNV];
    [self setViewControllers:vcArray];
    [self consolidationDecmainorateNavStyle];
    [self consolidationDecmainorateSVProgressHUD];
}

- (UINavigationController *)showVCTabBarItemWith:(UIViewController *)targetVC imageInset:(UIEdgeInsets)imageInset mainImageStr:(NSString *)mainImageStr selectedImageStr:(NSString *)selectedImageStr {
    UINavigationController *recommendNav=[[UINavigationController alloc] initWithRootViewController:targetVC];
    UIImage *mainImage=[UIImage imageNamed:mainImageStr];
    UIImage *selectedImage=[UIImage imageNamed:selectedImageStr];
    UITabBarItem *item=[UITabBarItem itemWithTitle:nil image:mainImage selectedImage:selectedImage];
    [item setTitlePositionAdjustment:UIOffsetMake(0, 50)];
    [recommendNav setTabBarItem:item];
    [recommendNav.tabBarItem setImageInsets:imageInset];
    return recommendNav;
}

//统一布置导航栏样式
- (void)consolidationDecmainorateNavStyle {
//    UIImage *image = [UIImage imageNamed:@"nav_back.png"];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [UINavigationBar appearance].backIndicatorTransitionMaskImage = image;
//    [UINavigationBar appearance].backIndicatorImage = image;
//    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName,[UIColor characterBlackColor],NSForegroundColorAttributeName, nil]];
//    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} forState:UIControlStateNormal];
//
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    [[UITextField appearance] setTintColor:[UIColor iconBlueColor]];
}

- (CGSize)intrinsicContentSize {
    return UILayoutFittingExpandedSize;
}

- (void)consolidationDecmainorateSVProgressHUD {
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setErrorImage:nil];
    [SVProgressHUD setInfoImage:nil];
    [SVProgressHUD setSuccessImage:nil];
}

@end


