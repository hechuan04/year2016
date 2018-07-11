//
//  YiJiCell.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/14.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YiJiCell : UITableViewCell

@property (nonatomic,strong) UIImageView *yiIconView;
@property (nonatomic,strong) UILabel *yiContentLabel;
@property (nonatomic,strong) UIImageView *jiIconView;
@property (nonatomic,strong) UILabel *jiContentLabel;
@property (nonatomic,strong) UIView *topLineView;//上分割线
@property (nonatomic,strong) UIView *leftLineView;//左分割线
@property (nonatomic,strong) UIView *rightLineView;//右分割线

@property (nonatomic,strong) UIImageView *qianImageView;

@end
