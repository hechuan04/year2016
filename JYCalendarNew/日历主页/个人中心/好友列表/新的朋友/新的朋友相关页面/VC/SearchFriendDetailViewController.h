//
//  SearchFriendDetailViewController.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/4/25.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchFriendModel.h"
#import "NewAddFriend.h"

@interface SearchFriendDetailViewController : NewAddFriend

@property (nonatomic,strong) SearchFriendModel *searchModel;
@property (nonatomic,strong) UIButton *actionButton;
@end
