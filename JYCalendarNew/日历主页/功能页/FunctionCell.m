//
//  FunctionCell.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/6/13.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "FunctionCell.h"

@implementation FunctionCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
    }
    return  self;
}
- (void)setupSubViews{
    
    CGFloat imageWidth = 37.f;
    
    //头像
    _iconView = [UIImageView new];
    _iconView.layer.cornerRadius = imageWidth/2;
    _iconView.layer.masksToBounds = YES;
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_iconView];
    
     //标题
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:17.f];
    [self.contentView addSubview:_titleLabel];
    
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(imageWidth);
        make.left.equalTo(self.contentView).offset(10.f);
        make.centerY.equalTo(self.contentView);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconView.mas_right).offset(15.f);
        make.centerY.equalTo(self.contentView);
    }];
    
}

- (void)setIcon:(UIImage *)image title:(NSString *)title
{
    self.iconView.image = image;
    self.titleLabel.text = title;
}
@end
