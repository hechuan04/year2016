//
//  YiJiCalendarCell.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/21.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "YiJiCalendarCell.h"
#import "TopBorderView.h"
#import "BottomBorderView.h"
#import "JYCalendarModel.h"

@implementation YiJiCalendarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
        self.separatorInset = UIEdgeInsetsZero;
        [self setupSubViews];
        
    }
    return  self;
}

- (void)setupSubViews
{
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:14.f];
    label.textColor = [UIColor blackColor];
    label.text = @"2016年07月";
    label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:label];
    self.yearMonthLabel = label;
    
    label = [UILabel new];
    label.font = [UIFont systemFontOfSize:15.f];
    label.textColor = [UIColor blackColor];
    label.text = @"农历六月十二 星期日";
    [self.contentView addSubview:label];
    self.chineseCalendarLabel = label;
    
    label = [UILabel new];
    label.font = [UIFont systemFontOfSize:26.f];
    label.textColor = [JYSkinManager shareSkinManager].colorForDateBg;
    label.text = @"15";
    label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:label];
    self.dayLabel = label;
    
    label = [UILabel new];
    label.font = [UIFont systemFontOfSize:15.f];
    label.textColor = [UIColor blackColor];
    label.text = @"丙申[猴]年乙未月戊戌日";
    [self.contentView addSubview:label];
    self.chineseEraLabel = label;
    
    //border
    self.topBorderView = [TopBorderView new];
    [self.contentView addSubview:self.topBorderView];
    self.bottomBorderView = [BottomBorderView new];
    [self.contentView addSubview:self.bottomBorderView];
    
    self.leftBorderView = [UIView new];
    self.leftBorderView.backgroundColor = [JYSkinManager shareSkinManager].colorForDateBg;
    [self.contentView addSubview:self.leftBorderView];
    
    self.rightBorderView = [UIView new];
    self.rightBorderView.backgroundColor = [JYSkinManager shareSkinManager].colorForDateBg;
    [self.contentView addSubview:self.rightBorderView];
    
    UIImageView *addRemindView = [[UIImageView alloc]init];
    addRemindView.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
    addRemindView.image = [[UIImage imageNamed:@"择吉_添加"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    [addRemindView setImage:[[UIImage imageNamed:@"扫描新建"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    addRemindView.contentMode = UIViewContentModeScaleAspectFit;
//    addRemindView.layer.cornerRadius = 13.f;
//    addRemindView.layer.masksToBounds = YES;
//    addRemindView.layer.borderWidth = 1.f;
//    addRemindView.layer.borderColor = [JYSkinManager shareSkinManager].colorForDateBg.CGColor;
    [self.contentView addSubview:addRemindView];
    self.addRemindView = addRemindView;
    
    CGFloat horMargin = 15.f;
    CGFloat verMargin = 5.f;
    
    [self.topBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(horMargin);
        make.right.equalTo(self.contentView).offset(-horMargin);
        make.top.equalTo(self.contentView).offset(verMargin);
        make.height.equalTo(@10.f);
    }];
    [self.bottomBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.topBorderView);
        make.bottom.equalTo(self.contentView).offset(-verMargin);
    }];
    [self.leftBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBorderView);
        make.top.equalTo(self.topBorderView.mas_bottom);
        make.width.equalTo(@1.f);
        make.bottom.equalTo(self.bottomBorderView.mas_top);
    }];
    [self.rightBorderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topBorderView.mas_right);
        make.top.equalTo(self.topBorderView.mas_bottom);
        make.width.equalTo(@1.f);
        make.bottom.equalTo(self.bottomBorderView.mas_top);
    }];
    
    [self.yearMonthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftBorderView).offset(horMargin);
        make.top.equalTo(self.topBorderView.mas_bottom).offset(verMargin);
        make.height.equalTo(@20.f);
        make.width.equalTo(@80.f);
    }];
    [self.chineseCalendarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.yearMonthLabel.mas_right).offset(20.f);
        make.top.equalTo(self.yearMonthLabel);
        make.right.equalTo(self.addRemindView.mas_left);
    }];
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.yearMonthLabel);
        make.bottom.equalTo(self.bottomBorderView.mas_top);
        make.height.equalTo(@25.f);
    }];
    [self.chineseEraLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.chineseCalendarLabel);
        make.bottom.equalTo(self.bottomBorderView.mas_top);
        make.height.equalTo(@20.f);
    }];
 
    [self.addRemindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@22.f);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.rightBorderView.mas_left).offset(-20.f);
    }];
}

- (void)setCalendarModel:(JYCalendarModel *)calendarModel
{
    _calendarModel = calendarModel;
    
    self.yearMonthLabel.text = [NSString stringWithFormat:@"%ld年%ld月",calendarModel.year,calendarModel.month];
    self.dayLabel.text = [NSString stringWithFormat:@"%ld",calendarModel.day];
    self.chineseCalendarLabel.text = [NSString stringWithFormat:@"农历%@%@ %@",calendarModel.lunarMonth,calendarModel.lunarDay,calendarModel.weekCNString];
    NSString *eraYear = calendarModel.eraYear;
    //去掉自带"年"字
    eraYear = [eraYear substringToIndex:[eraYear length]-1];
    self.chineseEraLabel.text = [NSString stringWithFormat:@"%@[%@]年%@%@",eraYear,calendarModel.zodia,calendarModel.eraMonth,calendarModel.eraDay];
}
@end
