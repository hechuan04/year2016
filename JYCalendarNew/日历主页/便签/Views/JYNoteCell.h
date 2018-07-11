//
//  JYNoteCell.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/4/27.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYNote;
@interface JYNoteCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIView  *lineView;
@property (nonatomic,strong) UIView  *bottomLineView;
@property (nonatomic,strong) NSDateFormatter *dateFormat;
@property (nonatomic,strong) UIImageView *checkView;
@property (nonatomic,strong) UIImageView *syncView;
@property (nonatomic,assign) BOOL isSelected;

@property (nonatomic,strong) MASConstraint *checkWidthConstraint;
@property (nonatomic,strong) MASConstraint *titleLeftConstraint;

@property (nonatomic,strong) JYNote *note;
@end
