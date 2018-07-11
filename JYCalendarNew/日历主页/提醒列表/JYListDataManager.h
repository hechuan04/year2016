//
//  JYListDataManager.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/8/4.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYListDataManager : NSObject

//普通列表数据
@property (nonatomic ,strong)NSArray *systemRemind;
@property (nonatomic ,strong)NSArray *acceptRemind;
@property (nonatomic ,strong)NSArray *sendRemind;
@property (nonatomic ,strong)NSArray *shareRemind;


//今天待办列表数据
@property (nonatomic ,strong)NSDictionary *dataDic;


+ (JYListDataManager *)manager;

/**
 *  注册通知方法,同时初始化数据
 */
- (void)addNotification;


//数据获取
- (NSArray *)systemData:(NSString *)text;
- (NSArray *)acceptData:(NSString *)text;
- (NSArray *)shareData:(NSString *)text;
- (NSArray *)sendData:(NSString *)text;
- (NSDictionary *)todayData:(NSString *)text;

@end
