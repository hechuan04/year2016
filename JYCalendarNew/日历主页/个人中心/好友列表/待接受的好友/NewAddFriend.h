//
//  NewAddFriend.h
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/17.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define heightForBtn 84 / 1334.0 * kScreenHeight
#define widthForBtn 710 / 750.0 * kScreenWidth
#define pageForBtn 26 / 1334.0  * kScreenHeight

// 分享内容
@interface ShareContent : NSObject

@property(nonatomic,strong) NSString *title;    // 分享title
@property(nonatomic,strong) NSString *des;      // 分享描述
@property(nonatomic,strong) NSString *hideUrl;  // 跳转网址
@property(nonatomic,strong) NSArray  *imgUrls;  // 图片组

@end


@interface NewAddFriend : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong)FriendModel *model;
@property (nonatomic ,strong)NSMutableArray *arrForNewFriend;
@property (nonatomic ,copy)void (^actionForRemove)(NSArray *arr);

@property (nonatomic ,strong)UIButton *btnForAccept;
@property (nonatomic ,strong)UIButton *btnForRefuse;
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic,strong) UIButton *rightBtn;
@end
