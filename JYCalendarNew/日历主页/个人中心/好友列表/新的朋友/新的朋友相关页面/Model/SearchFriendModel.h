//
//  SearchFriendModel.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/3/10.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendModel.h"

@interface SearchFriendModel : NSObject

@property (nonatomic,assign)NSInteger uid; //小秘号
@property (nonatomic,copy)NSString *userName; //好友名字
@property (nonatomic,copy)NSString *avatarUrl;   //头像
@property (nonatomic,copy)NSString *phoneNumber;  //电话
@property (nonatomic,assign)NSInteger status; //是否为好友状态

@property (nonatomic,copy) NSString *location;//地区
@property (nonatomic,copy) NSString *signature;//签名

- (instancetype)initWithDictionary:(NSDictionary *)dic;

- (FriendModel *)convertToFriendModel;
@end
