//
//  NewAddFriendCell.m
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/17.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import "NewAddFriendCell.h"

@implementation NewAddFriendCell

- (void)awakeFromNib {
    // Initialization code
    
    
    _openImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 6, (self.height - 11) / 2.0, 6, 11)];
    _openImage.image = [UIImage imageNamed:@"展开.png"];
    [self.contentView addSubview:_openImage];
    
    _barImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 30 - 30, 15, 30, 30)];
    [self.contentView addSubview:_barImage];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.headImage.layer.masksToBounds = YES;
        self.headImage.layer.cornerRadius = self.headImage.width / 2.0;
          _openImage.origin = CGPointMake(kScreenWidth - 15 - 6, (self.height - 11) / 2.0);
    });

    
    self.headImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUserHead:)];
    [self.headImage addGestureRecognizer:tap];

}
- (void)tapUserHead:(UIGestureRecognizer *)sender
{
    [SinglePreview showWithImageUrlString:self.headUrl];
}

@end
