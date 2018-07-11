//
//  NSNull+Patch.m
//  JYDatePicker
//
//  Created by Gaolichao on 2017/1/20.
//  Copyright © 2017年 Gaolichao. All rights reserved.
//

#import "NSNull+Patch.h"

@implementation NSNull (Patch)

- (NSInteger)integerValue
{
    return 0;
}
- (int)intValue
{
    return 0;
}
- (NSString *)stringValue
{
    return @"";
}
@end
