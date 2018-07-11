//
//  ClockCell.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/4.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "ClockCell.h"

@implementation ClockCell

- (void)awakeFromNib {
    // Initialization code
    self.switchBtn.tintColor = UIColorFromRGB(0xf1f1f1);
}


- (IBAction)switchAction:(UISwitch *)sender {
    
    if (sender.on == 1) {
        
        self.timeLabel.textColor = [UIColor blackColor];
        self.time.textColor = [UIColor blackColor];

    }else{
        
        self.timeLabel.textColor = nameTextColor;
        self.time.textColor = nameTextColor;
        
    }
  
    _passModel(self,sender.on);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
