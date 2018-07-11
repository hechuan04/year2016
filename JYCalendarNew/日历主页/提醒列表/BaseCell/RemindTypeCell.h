//
//  RemindTypeCell.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/3/23.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemindTypeCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *unreadCountLabel;
@property (nonatomic,strong) UIImageView *arrowView;
@property (nonatomic ,strong)UIImageView *headImage;

- (void)setTitle:(NSString *)title unreadCount:(NSString *)unreadCount;
@end
