//
//  SetCell.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/7.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "SetCell.h"

@implementation SetCell

- (void)awakeFromNib {

    _arrowHead = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 6, (self.height - 11) / 2.0, 6, 11)];
    _arrowHead.image = [UIImage imageNamed:@"展开.png"];
    [self.contentView addSubview:_arrowHead];
    
    _switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 2 - 49, (self.height - 31) / 2.0, 49, 31)];
    _switchBtn.onTintColor = [UIColor redColor];
    [_switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:_switchBtn];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _arrowHead.origin = CGPointMake(kScreenWidth - 15 - 6, (self.height - 11) / 2.0);
        _switchBtn.origin = CGPointMake(kScreenWidth - 15 - 2 - 49, (self.height - 31) / 2.0);
        
    });

}

- (void)switchAction:(UISwitch *)sender
{
 
    _switchAction(sender.on);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
