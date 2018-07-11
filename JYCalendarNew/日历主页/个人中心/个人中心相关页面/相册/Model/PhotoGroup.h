//
//  PhotoGroup.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/3/14.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoGroup : NSObject

@property (nonatomic,strong) NSDate *createdTime;
@property (nonatomic,strong) NSMutableArray *photoItems;//of PhotoItem

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
