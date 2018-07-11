//
//  ManagerForButton.m
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/22.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import "ManagerForButton.h"

static ManagerForButton *managerForBtn = nil;

@implementation ManagerForButton

+ (ManagerForButton *)shareManagerBtn
{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (managerForBtn == nil) {
            
            managerForBtn = [[ManagerForButton alloc] init];

        }
        
        
    });
    
    return managerForBtn;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
  
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (managerForBtn == nil) {
            
            
            managerForBtn = [super allocWithZone:zone];
        }
        
    });
 
    return managerForBtn;

}

@end
