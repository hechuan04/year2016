//
//  MyWeiboListController.h
//  JYCalendarNew
//
//  Created by 何川 on 15-12-23.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewFriendViewController.h"

@interface MyWeiboListController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSString *weiboBindOpenId;
@property (strong, nonatomic) NSString *weiboBindToken;

@end
