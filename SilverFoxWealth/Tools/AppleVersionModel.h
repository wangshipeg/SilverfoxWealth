

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface AppleVersionModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *version; //版本号
@property (nonatomic, strong) NSString *trackViewUrl; //下载地址

@end
