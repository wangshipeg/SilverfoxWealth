//
//  ActivityZoonModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/10/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface ActivityZoonModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *beginDate;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *shareDesc;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;//1-内部上传 2-外部链接


/*id
 title
 imgUrl
 begainDate
 endDate
 shareDesc
*/
@end
