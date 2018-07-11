//
//  FestivalCell.h
//  JYCalendarNew
//
//  Created by Gaolichao on 2016/12/7.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kCellIdentifierFestivalTop = @"kCellIdentifierFestivalTop";
static NSString *kCellIdentifierFestival = @"kCellIdentifierFestival";
static NSString *kCellIdentifierFestivalBottom = @"kCellIdentifierFestivalBottom";

@interface FestivalCell : UITableViewCell

@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIView *topLineView;//上分割线
@property (nonatomic,strong) UIView *leftLineView;//左分割线
@property (nonatomic,strong) UIView *rightLineView;//右分割线

@property (nonatomic,strong) UIButton *detailBtn;//详情

- (void)showTopLine:(BOOL)show;
@end
