//
//  UIImageView+Copy.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/17.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "UIImageView+Copy.h"

@implementation UIImageView (Copy)

- (id)copyWithZone:(NSZone *)zone
{
 
    UIImageView *copy = [[[self class] allocWithZone:zone] init];
    
    return copy;
    
}



@end
