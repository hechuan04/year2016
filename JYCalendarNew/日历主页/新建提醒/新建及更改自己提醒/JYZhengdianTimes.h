//
//  JYZhengdianTimes.h
//  JYCalendarNew
//
//  Created by 吴冬 on 17/1/19.
//  Copyright © 2017年 北京金源互动科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface JYZhengdianTimes : BaseViewController
@property (nonatomic ,strong)RemindModel *model;
@property (nonatomic ,copy)void (^popBlock)();
@end
