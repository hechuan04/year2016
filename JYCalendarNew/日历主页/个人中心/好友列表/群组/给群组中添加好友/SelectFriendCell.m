//
//  SelectFriendCell.m
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/16.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import "SelectFriendCell.h"

@implementation SelectFriendCell

- (void)awakeFromNib {

  
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _headView.layer.masksToBounds = YES;
        _headView.layer.cornerRadius = _headView.width / 2.0;
        _headView.layer.allowsGroupOpacity = true;
        
    });

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
