//
//  TableViewCell.m
//  JYCalendar
//
//  Created by 吴冬 on 15/11/19.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "TableViewCell.h"

#define yForTop 15 / 1334.0 * kScreenHeight

@implementation TableViewCell

- (void)awakeFromNib {

    _imageForJiantou = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 15 - 6, (self.height - 11) / 2.0, 6, 11)];
    _imageForJiantou.image = [UIImage imageNamed:@"展开.png"];
    [self.contentView addSubview:_imageForJiantou];
    
    
    _imageForSet = [UIImageView new];
    //_imageForSet.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:_imageForSet];
    
    [_imageForSet mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(super.mas_left).offset(15.f);
        make.top.mas_equalTo(49.f).offset(11.f);
        make.bottom.mas_equalTo(49.f).offset(-11.f);
        
        make.width.equalTo(_imageForSet.mas_height);

    }];
    
    _setLabel = [UILabel new];
    _setLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_setLabel];
    
    [_setLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_imageForSet.mas_right).offset(10.f);
        make.top.mas_equalTo(0.f);
        make.bottom.mas_equalTo(0.f);
        
        make.width.equalTo(super.mas_width);
        
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _imageForJiantou.origin = CGPointMake(kScreenWidth - 15 - 6, (self.height - 11) / 2.0);
 
    });
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
