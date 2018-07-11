//
//  SearchFriendCell.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/3/10.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchFriendModel;

@interface SearchFriendCell : UITableViewCell

@property (nonatomic,strong) UIImageView *avatarView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *phoneLabel;
@property (nonatomic,strong) UIButton *actionButton;

@property (nonatomic,strong) SearchFriendModel *friendModel;
@property (nonatomic,strong) void (^actionBlock)(SearchFriendModel *model);
@end
