//
//  SkinCell.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/19.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "SkinCell.h"

@implementation SkinCell

- (void)awakeFromNib {

  
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _selectColor.layer.masksToBounds = YES;
        _selectColor.layer.cornerRadius = _selectColor.width / 2.0;
        
    });

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
