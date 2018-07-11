//
//  JYRemindCell.m
//  JYCalendar
//
//  Created by 吴冬 on 15/11/2.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYRemindCell.h"

@implementation JYRemindCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth, 44)];
        [self.contentView addSubview:_titleLabel];
        
        _nextLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 6 - 15 - 200, 0, 200, 44)];
        _nextLabel.font = [UIFont systemFontOfSize:13];
        _nextLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_nextLabel];
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 44-0.5, kScreenWidth, 0.5)];
        _line.backgroundColor = lineColor;
        [self.contentView addSubview:_line];
        
        _arrowHead = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 6, (44 - 11) / 2.0, 6, 11)];
        _arrowHead.image = [UIImage imageNamed:@"展开.png"];
        [self.contentView addSubview:_arrowHead];
        
        _switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 2 - 49, (44 - 31) / 2.0, 49, 31)];
        _switchBtn.onTintColor = [UIColor redColor];
        [_switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_switchBtn];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _arrowHead.origin = CGPointMake(kScreenWidth - 15 - 6, (44 - 11) / 2.0);
            _switchBtn.origin = CGPointMake(kScreenWidth - 15 - 2 - 49, (self.height - 31) / 2.0);
            
        });

    }
    
    return  self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//是否打开开关
- (void)switchAction:(UISwitch *)sender {
    
    _switchAction(sender);
    
}



@end
