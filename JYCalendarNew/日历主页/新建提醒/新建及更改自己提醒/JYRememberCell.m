//
//  JYRememberCell.m
//  JYCalendarNew
//
//  Created by 吴冬 on 17/1/11.
//  Copyright © 2017年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYRememberCell.h"

@implementation JYRememberCell


- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [UILabel new];
        _titleLable.font = [UIFont systemFontOfSize:15];
        _titleLable.backgroundColor = RGB_COLOR(244, 244, 244);
        [self.contentView addSubview:_titleLable];
        
        [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(5);
            make.left.equalTo(self.contentView.mas_left).offset(15.f);
            make.height.mas_equalTo(20.f);
            make.width.mas_equalTo(kScreenWidth - 15 - 15);
        }];
    }
    
    return _titleLable;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.backgroundColor = RGB_COLOR(244, 244, 244);
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = RGB_COLOR(178, 181, 183);
        [self.contentView addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLable.mas_bottom);
            make.left.equalTo(self.titleLable.mas_left);
            make.height.mas_equalTo(15.f);
            make.width.mas_equalTo(kScreenWidth - 15 - 15);
        }];
    }
    
    return _timeLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
