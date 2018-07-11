//
//  ALAsset+Common.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/8/29.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "ALAsset+Common.h"

@implementation ALAsset (Common)

- (NSDate *)date
{
    return [self valueForProperty:ALAssetPropertyDate];
}

@end
