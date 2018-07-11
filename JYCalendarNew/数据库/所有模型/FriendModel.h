//
//  FriendModel.h
//  JYCalendar
//
//  Created by 吴冬 on 15/12/7.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendModel : NSObject

@property (nonatomic ,assign)NSInteger fid; //小秘号
@property (nonatomic ,copy)NSString *friend_name; //好友名字
@property (nonatomic ,copy)NSString *head_url;   //头像
@property (nonatomic ,copy)NSString *tel_phone;  //电话
@property (nonatomic ,assign)int status; //是否为好友状态
@property (nonatomic ,assign)int keystatus;//是否为关键人
@property (nonatomic, copy) NSString *remarkName;//备注姓名

@property (nonatomic ,copy)NSString *sex;
@property (nonatomic ,copy)NSString *local;
@property (nonatomic ,copy)NSString *sign;

@end
