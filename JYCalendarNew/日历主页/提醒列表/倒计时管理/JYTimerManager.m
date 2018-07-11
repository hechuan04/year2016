//
//  JYTimerManager.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/8/3.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYTimerManager.h"
static JYTimerManager *manager = nil;
@implementation JYTimerManager

+ (JYTimerManager *)manager{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[JYTimerManager alloc] init];
        }
    });
    
    return manager;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [super allocWithZone:zone];
        }
    });
    
    return manager;
}




@end
