//
//  JYTodayListCell.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/8/2.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYTodayListCell.h"

@implementation JYTodayListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //竖线
        _erectLine = [[UIView alloc] initWithFrame:CGRectMake(30, 0, 1, 75.0)];
        [self.bgView addSubview:_erectLine];
        

       //时间Label
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (75 - 20)/2.0, 40, 20)];
        _timeLabel.layer.masksToBounds = YES;
        _timeLabel.layer.cornerRadius = 3.0;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:14.0];
        [self.bgView addSubview:_timeLabel];
        
        
        //标题
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 15, kScreenWidth - 65 - 20, 20)];
        [self.bgView addSubview:self.titleLabel];
        
        //倒计时
        _countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 45, kScreenWidth - 65 - 20, 20)];
        _countDownLabel.textColor = RGB_COLOR(150, 150, 150);
        _countDownLabel.font = [UIFont systemFontOfSize:14.0];
        [self.bgView addSubview:_countDownLabel];
        
        
        //横线
        _horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(45, 74.5, kScreenWidth, 0.5)];
        _horizontalLine.backgroundColor = lineColor;
        [self addSubview:_horizontalLine];
        
        
        //闹钟
        _clockImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 20, (75 - 20) / 2.0, 20, 20)];
        _clockImage.image = [UIImage imageNamed:@"today_red.png"];
        [self.bgView addSubview:_clockImage];
        
    }
    
    
    return self;
}



//不创建头像
- (void)_createContent{}

@end
