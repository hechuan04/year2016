//
//  JYTimerManager.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/8/3.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYTimerManager : NSObject
+ (JYTimerManager *)manager;

@property (nonatomic ,strong)NSMutableArray <NSTimer *> *timerArr;

@end
