//
//  JYSystemList.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/30.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYSystemList : NSObject

+ (JYSystemList *)shareList;

- (NSArray *)selectAllModel;
- (NSArray *)selectAllModelWithStr:(NSString *)str;
@end
