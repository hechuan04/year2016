//
//  FriendCell.h
//  JYCalendarNew
//
//  Created by Gaolichao on 2016/11/23.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIView *bottomLineView;

- (void)setHeadUrl:(NSString *)headUrlStr name:(NSString *)name;
- (void)setImage:(UIImage *)image title:(NSString *)title;

@end
