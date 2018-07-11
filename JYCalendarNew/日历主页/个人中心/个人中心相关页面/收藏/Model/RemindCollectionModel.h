//
//  RemindCollectionModel.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/3/11.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemindCollectionModel : NSObject

@property (nonatomic,assign) NSInteger mid;//提醒id
@property (nonatomic,assign) NSInteger sid;//收藏id
@property (nonatomic,copy) NSString *senderName;
@property (nonatomic,copy) NSString *senderUid;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *avatarUrl;
@property (nonatomic,strong) NSDate *createTime;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
