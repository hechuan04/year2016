//
//  AddGroupVC.h
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/23.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddGroupVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)NSArray *arrForFriend;
@property (nonatomic ,strong)NSArray *arrForGroup;
@property (nonatomic ,strong)DataArray *dataArr;
@property (nonatomic ,strong)NSMutableArray *arrForSelectGroup;

@property (nonatomic ,copy)void (^actionForPassGroup)(NSArray *groupArr);

@end
