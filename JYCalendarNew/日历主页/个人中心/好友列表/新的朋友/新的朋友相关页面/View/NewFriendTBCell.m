//
//  NewFriendTBCell.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/1/13.
//  Copyright (c) 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "NewFriendTBCell.h"

@implementation NewFriendTBCell

- (void)awakeFromNib {


    dispatch_async(dispatch_get_main_queue(), ^{
        
        _userHead.layer.masksToBounds = YES;
        _userHead.layer.cornerRadius = _userHead.width / 2.0;
        
    });
    
}


- (IBAction)addAction:(UIButton *)sender {
    
    _actionForPassCell(self);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
