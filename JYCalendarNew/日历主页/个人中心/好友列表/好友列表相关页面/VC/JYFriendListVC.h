//
//  JYFriendListVC.h
//  JYCalendar
//
//  Created by 吴冬 on 15/12/8.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "FriendTableViewCell.h"
#import "BaseViewController.h"

@interface JYFriendListVC : BaseViewController<UIAlertViewDelegate>

@property (nonatomic ,strong)NSDictionary *dicForAllName;
@property (nonatomic ,strong)NSArray      *arrForAllKey;
@property (nonatomic ,strong)ManagerForButton *managerBtn;

@property (nonatomic ,strong)FriendModel *friend_model;

@end
