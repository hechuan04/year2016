//
//  YiJiCalendarCell.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/21.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TopBorderView;
@class BottomBorderView;
@class JYCalendarModel;

@interface YiJiCalendarCell : UITableViewCell

@property (nonatomic,strong) UILabel *yearMonthLabel;
@property (nonatomic,strong) UILabel *dayLabel;
@property (nonatomic,strong) UILabel *chineseCalendarLabel;
@property (nonatomic,strong) UILabel *chineseEraLabel;

@property (nonatomic,strong) UIView *leftBorderView;
@property (nonatomic,strong) UIView *rightBorderView;
@property (nonatomic,strong) TopBorderView *topBorderView;
@property (nonatomic,strong) BottomBorderView *bottomBorderView;

@property (nonatomic,strong) UIImageView *addRemindView;

@property (nonatomic,strong) JYCalendarModel *calendarModel;
@end
