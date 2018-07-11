//
//  JYRecurVC.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/7.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface JYRecurVC : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)ClockModel *model;
@property (nonatomic ,strong)NSMutableArray *arrForWeek;

@property (nonatomic ,copy)void (^actionForWeek)(ClockModel *model);

@end
