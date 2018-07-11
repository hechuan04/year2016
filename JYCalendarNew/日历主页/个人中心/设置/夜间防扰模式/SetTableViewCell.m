//
//  SetTableViewCell.m
//  JYCalendar
//
//  Created by 吴冬 on 15/10/22.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "SetTableViewCell.h"
#import "SliderBtn.h"

@implementation SetTableViewCell
{
   


}


- (void)awakeFromNib {
  
    self.switchBtn.on = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isDistrubation"] boolValue];

    _trigonometryImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 6, (self.height - 11) / 2.0, 6, 11)];
    _trigonometryImage.image = [UIImage imageNamed:@"展开.png"];
    [self.contentView addSubview:_trigonometryImage];
    
    _titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, (self.height - 20) / 2.0 , 20, 20)];
    [self.contentView addSubview:_titleImage];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 + 20 + 15, 0, 250, 49)];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    //_titleLabel.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:_titleLabel];
    
    
    _switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 2 - 49, (self.height - 31) / 2.0, 49, 31)];
    _switchBtn.onTintColor = [UIColor redColor];
    [_switchBtn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:_switchBtn];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _trigonometryImage.origin = CGPointMake(kScreenWidth - 15 - 6, (self.height - 11) / 2.0);
        _titleImage.frame = CGRectMake(15, (self.height - 20) / 2.0 , 20, 20);
        
    });
    
}

- (void)selectedAction:(UISwitch *)sender {
    
        _isOpen = !_isOpen;
    
       sender.on = _isOpen;
        _isDistrubation(_isOpen);


    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
