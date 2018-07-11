//
//  UIImageView+Copy.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/17.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Copy)<NSCopying>

- (id)copyWithZone:(NSZone *)zone;

@end
