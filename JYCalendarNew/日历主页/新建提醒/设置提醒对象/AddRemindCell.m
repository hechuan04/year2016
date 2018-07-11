//
//  AddRemindCell.m
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/17.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import "AddRemindCell.h"

@implementation AddRemindCell

- (void)awakeFromNib {

   dispatch_async(dispatch_get_main_queue(), ^{
       
       _headImage.layer.cornerRadius = _headImage.width / 2.0;
       _headImage.layer.masksToBounds = YES;
       
   });

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
