//
//  AddFriendVC.h
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/16.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)NSDictionary *dicForAllName;
@property (nonatomic ,strong)NSArray      *arrForAllKey;
@property (nonatomic ,strong)NSMutableArray *arrForSelect;
@property (nonatomic ,strong)NSArray      *arrForModel;
@property (nonatomic ,assign)BOOL isCreate; //用于判断时候是重新进入

@property (nonatomic ,copy)void (^actionForSelect)(NSArray *arrForSelect);

@end
