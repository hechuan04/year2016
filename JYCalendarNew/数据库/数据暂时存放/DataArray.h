//
//  DataArray.h
//  JYCalendar
//
//  Created by 吴冬 on 15/11/6.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendTableViewCell.h"
@interface DataArray : NSObject

+ (DataArray *)shareDateArray;

//@property (nonatomic ,strong)NSArray *arrForAllLocalData; //所有本地数据，不涉及到网络
@property (nonatomic ,strong)NSArray *arrForAllData; //有关自己的所有提醒(me，he)
@property (nonatomic ,strong)NSArray *arrForAllFriend; //好友列表
@property (nonatomic ,strong)NSArray *arrForAllGroup;  //所有组
@property (nonatomic ,strong)NSArray *arrForNewFreind; //新朋友

@property (nonatomic ,strong)NSArray *arrForGroup;     //群组传值用
@property (nonatomic ,strong)NSString *strForGroupName; //组名字传值用


@property (nonatomic ,strong)RemindModel *modelForSend; //传值事件
@property (nonatomic ,strong)RemindModel *modelForUpData; //更改事件


@property (nonatomic ,strong)FriendTableViewCell *cell; //暂时存放这个cell

@end
