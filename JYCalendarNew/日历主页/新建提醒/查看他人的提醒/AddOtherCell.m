//
//  AddOtherCell.m
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/18.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import "AddOtherCell.h"
#define heightForCc 88 / 1334.0 * kScreenHeight

@implementation AddOtherCell

- (void)awakeFromNib {

    _arrowHead = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 6, (self.height - 11) / 2.0, 6, 11)];
    _arrowHead.image = [UIImage imageNamed:@"展开.png"];
    [self.contentView addSubview:_arrowHead];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_arrowHead.left - 15 - 200, (heightForCc - 21) / 2.0, 200, 21)];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_timeLabel];
    
    
    _switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 49 - 2, (heightForCc - 31) / 2.0, 49, 31)];
    _switchBtn.onTintColor = [UIColor redColor];
    [_switchBtn addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:_switchBtn];
    
    _line = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-0.5, kScreenWidth, 0.5)];
    _line.backgroundColor = lineColor;
    [self.contentView addSubview:_line];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _arrowHead.origin = CGPointMake(kScreenWidth - 15 - 6, (self.height - 11) / 2.0);
        _timeLabel.origin = CGPointMake(_arrowHead.left - 15 - 200, (self.height - 21) / 2.0);
        
    });
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _line.frame = CGRectMake(0, self.height-0.5, kScreenWidth, 0.5);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)onAction:(UISwitch *)sender {
    
    
    int ison = sender.isOn;
    
    _actionForPassOpenOrClose(ison);
}

@end
