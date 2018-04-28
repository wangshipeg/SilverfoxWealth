

#import "UITabBarItem+TabBarItemModify.h"

@implementation UITabBarItem (TabBarItemModify)


+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    
    UITabBarItem *tabBarItem = nil;
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImage];
    return tabBarItem;
    
}




















@end
