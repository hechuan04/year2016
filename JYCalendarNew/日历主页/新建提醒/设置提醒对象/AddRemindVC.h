//
//  AddRemindVC.h
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/17.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddRemindVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)NSArray *arrForGroup;
@property (nonatomic ,strong)NSArray *arrForFriend;

@property (nonatomic ,strong)NSMutableArray *arrForSelectFriend;
@property (nonatomic ,strong)NSMutableArray *arrForSelectGroup;

@property (nonatomic ,assign)BOOL isCreate;

@property (nonatomic ,copy)void (^actionForSendArr)(NSArray *arrForFriendModel, NSArray *arrForGroupModel);
@property (nonatomic ,strong)DataArray  *dataArr;
@property (nonatomic ,assign)BOOL isShare;

@property (nonatomic ,strong)NSDictionary *dicForAllName;
@property (nonatomic ,strong)NSArray      *arrForAllKey;

@end
