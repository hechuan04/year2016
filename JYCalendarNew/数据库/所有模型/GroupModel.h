//
//  GroupModel.h
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/16.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupModel : NSObject

@property (nonatomic ,assign)int gid;
@property (nonatomic ,assign)int oid;
@property (nonatomic ,copy)NSString *group_name;

@property (nonatomic,strong) UIImage *groupHeader;
@property (nonatomic,copy) NSString *groupHeaderUrl;

@end
