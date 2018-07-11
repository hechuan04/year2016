//
//  JYEmptyDatasourceAndDelegate.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/3/29.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIScrollView+EmptyDataSet.h"

@interface JYEmptyDatasourceAndDelegate : UIViewController<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

typedef NS_ENUM(NSInteger,ControllerType){
    ControllerTypePhotoVC = 0, //相册页
    ControllerTypeCollectionVC,//收藏页
    ControllerTypeAlarmVC, //闹钟页
    ControllerTypeGroupListVC, //群组页
    ControllerTypeRemindListVC //提醒页
};

- (instancetype)initWithControllerType:(ControllerType)type;

@property (nonatomic,assign) ControllerType controllerType;
//@property (nonatomic,assign,getter=isLodingCompleted) BOOL loadingCompleted;

@end
