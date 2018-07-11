//
//  NSNull+Patch.h
//  JYDatePicker
//
//  Created by Gaolichao on 2017/1/20.
//  Copyright © 2017年 Gaolichao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNull (Patch)

- (NSInteger)integerValue;
- (int)intValue;
- (NSString *)stringValue;
@end
