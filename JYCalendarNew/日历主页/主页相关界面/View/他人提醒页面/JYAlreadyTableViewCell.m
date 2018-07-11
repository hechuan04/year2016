//
//  JYAlreadyTableViewCell.m
//  JYCalendar
//
//  Created by 吴冬 on 15/11/5.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYAlreadyTableViewCell.h"

@implementation JYAlreadyTableViewCell

- (void)awakeFromNib {

    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.headView.layer.masksToBounds = YES;
        self.headView.layer.cornerRadius = self.headView.width / 2.0;
        self.selectTimeLabel.textColor = grayTextColor;
        _isLookImage.size = CGSizeMake(9, 9);
        _isLookImage.layer.allowsEdgeAntialiasing = true;
        
    });
    
    _userName = [[UILabel alloc] initWithFrame:CGRectMake(65, 7, 140, 21)];
    _userName.font = [UIFont systemFontOfSize:15];
   // _userName.backgroundColor = [UIColor orangeColor];
    _userName.textColor = [UIColor grayColor];
    [self.contentView addSubview:_userName];
    

    
    _imageForKey = [[UIImageView alloc] initWithFrame:CGRectMake(65, 10, 14, 14)];
    _imageForKey.image = [UIImage imageNamed:@"是关键人.png"];
    [self.contentView addSubview:_imageForKey];
    
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
