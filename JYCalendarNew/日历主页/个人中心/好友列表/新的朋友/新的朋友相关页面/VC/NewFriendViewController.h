//
//  NewFriendViewController.h
//  JYCalendar
//
//  Created by 吴冬 on 15/12/14.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface NewFriendViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ZBarReaderDelegate,ZBarReaderViewDelegate,UISearchDisplayDelegate,WXApiDelegate,WeiboSDKDelegate,TencentSessionDelegate>

@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSArray     *arrForNewFriend;
@property (nonatomic ,strong)ZBarReaderView *readerView;

@property (nonatomic, strong) NSMutableArray *searchFriendResults;//of SearchFriendModel

@end
