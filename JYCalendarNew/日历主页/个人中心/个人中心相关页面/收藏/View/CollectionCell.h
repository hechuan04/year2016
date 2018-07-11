//
//  CollectionCell.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/3/11.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RemindCollectionModel;

@interface CollectionCell : UITableViewCell

@property (nonatomic,strong) UIImageView *avatarView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *dateLabel;

@property (nonatomic,strong) RemindCollectionModel *remindModel;

@end
