//
//  JYSetView.h
//  JYCalendar
//
//  Created by 吴冬 on 15/10/14.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PushAction)(NSInteger row);

@interface JYSetView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,copy)PushAction pushAction;



@end
