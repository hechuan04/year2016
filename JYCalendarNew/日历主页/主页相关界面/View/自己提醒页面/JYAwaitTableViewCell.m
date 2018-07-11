//
//  JYAwaitTableViewCell.m
//  JYCalendar
//
//  Created by 吴冬 on 15/11/5.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYAwaitTableViewCell.h"

@implementation JYAwaitTableViewCell

- (void)awakeFromNib {

  
    _timeAndCount = [[UILabel alloc] initWithFrame:CGRectMake(20, 17, 220, 26)];
    //_timeAndCount.backgroundColor = [UIColor orangeColor];
    _timeAndCount.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:_timeAndCount];
    
    _markImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 19, 22, 22)];
    _markImage.image = [UIImage imageNamed:@"未发送显示.png"];
    [self.contentView addSubview:_markImage];

    _timeLabel.textColor = grayTextColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
