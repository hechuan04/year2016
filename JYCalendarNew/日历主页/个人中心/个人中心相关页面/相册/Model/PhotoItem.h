//
//  PhotoItem.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/3/14.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoItem : NSObject

@property (nonatomic,assign) NSInteger pId;
@property (nonatomic,copy) NSString *photoUrl;

@property (nonatomic,assign) BOOL isSelected;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

- (instancetype)initWithId:(NSString *)pid url:(NSString *)url;
@end
