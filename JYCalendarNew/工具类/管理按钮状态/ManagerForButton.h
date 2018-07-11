//
//  ManagerForButton.h
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/22.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendTableViewCell.h"
#import "BaseCell.h"

@interface ManagerForButton : NSObject

+ (ManagerForButton *)shareManagerBtn;

//主页的
@property (nonatomic ,strong)UIButton *personBtn;
@property (nonatomic ,strong)UILabel  *numberLabelForPerson;

//多少个未读提醒事件Label
@property (nonatomic ,strong)UILabel  *numberLabelForRemind;

//新的朋友页面的
@property (nonatomic ,strong)UILabel *numberOfNewfriendLabel;

//个人中心页面的
@property (nonatomic ,strong)UILabel *numberOfPersonLabel;

@property (nonatomic ,assign)int leftAndRightPage;

@property (nonatomic ,assign)BOOL haveNewFriend;
@property (nonatomic ,assign)int newFriendCountNow;

@property (nonatomic ,assign)BOOL isOpen;
@property (nonatomic ,strong)UITableViewCell *beforeCell;


@property (nonatomic ,strong)BaseCell *cell;
@property (nonatomic ,assign)BOOL isBaseCellOpen;
@property (nonatomic ,strong)NSIndexPath *indexPath;

@end
