//
//  JYBottomFrame.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/11/11.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYListVC.h"

@interface JYBottomFrame : NSObject

+ (void)appearBottomBtn:(NSArray *)orderArr lineView:(UIView *)lineView;
+ (void)disAppearBottomBtn:(NSArray *)orderArr lineView:(UIView *)lineView;
@end
