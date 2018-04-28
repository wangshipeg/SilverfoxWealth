

//id:1，
//url:”图片的url地址”，
//type:1，//1:内部上传，2：外部链接
//outLink:”https://baidu.com”，//外部链接地址
//shareContent:”分享文案内容”，
//title:”标题描述”


//精品推荐页 广告model

#import "MTLModel.h"
#import <Mantle.h>


@interface RecommendAdvertModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *outLink;
@property (nonatomic, strong) NSString  *type;
@property (nonatomic, strong) NSString  *idStr;
@property (nonatomic, strong) NSString  *url;
@property (nonatomic, strong) NSString  *shareContent;

@end

