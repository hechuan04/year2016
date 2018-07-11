//
//  PersonTableViewCell.m
//  JYCalendar
//
//  Created by 吴冬 on 15/11/19.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "PersonTableViewCell.h"

@implementation PersonTableViewCell

- (void)awakeFromNib {

    _userTitle = [UILabel new];
    [self.contentView addSubview:_userTitle];
    
    _userHead = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 30 - 6 - 65, 8.5, 65, 65)];
    [self.contentView addSubview:_userHead];

    [_userHead mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.mas_bottom).offset(-8.5f);
        make.top.equalTo(self.mas_top).offset(8.5f);
        make.width.equalTo(_userHead.mas_height);
        make.right.equalTo(self.mas_right).offset(-36.f);
        
    }];
    
    
    _userNumber = [UILabel new];
    _userNumber.textAlignment = NSTextAlignmentRight;
    _userNumber.numberOfLines = 0;
    //_userNumber.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:_userNumber];
    
    _imageForJiantou = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 6, (self.height - 11) / 2.0, 6, 11)];
    _imageForJiantou.image = [UIImage imageNamed:@"展开.png"];
    [self.contentView addSubview:_imageForJiantou];
    
  
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _userHead.layer.cornerRadius = _userHead.width / 2.0;
        _userHead.layer.masksToBounds = YES;
        _imageForJiantou.origin = CGPointMake(kScreenWidth - 15 - 6, (self.height - 11) / 2.0);
        
        if (self.height == 82) {
            
            self.userNumber.frame = CGRectMake(kScreenWidth - 15 - 6 - 15 - 150, 0, 150, 82);
            self.userTitle.frame = CGRectMake(15, 0, 200, 82);
            
        }else{
            
            self.userNumber.frame = CGRectMake(kScreenWidth - 15 - 6 - 15 - 150, 0, 150, 49);
            self.userTitle.frame = CGRectMake(15, 0, 200, 49);
            
        }
        
        
    
    });
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
