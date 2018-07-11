//
//  GroupModelVC.h
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/16.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupModelVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSArray     *arrForAllFriend;
@property (nonatomic ,copy)NSString      *groupName;
@property (nonatomic ,copy)void (^actionForReloadData)();

@property (nonatomic ,assign)int gid;

@property (nonatomic ,strong)UILabel *labelForName;

@property (nonatomic,copy) NSString *groupHeaderUrl;
@property (nonatomic ,assign)BOOL onlyInspect;

@end
