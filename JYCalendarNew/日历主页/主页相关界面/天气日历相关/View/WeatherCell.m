//
//  WeatherCell.m
//  JYCalendarNew
//
//  Created by Gaolichao on 2016/12/7.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "WeatherCell.h"

@implementation WeatherCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        self.backgroundColor=[UIColor clearColor];
        [self setupSubViewsWithIdentifier:reuseIdentifier];
    }
    return self;
}

- (void)setupSubViewsWithIdentifier:(NSString *)reuseIdentifier{
    _topLineView = [[UIView alloc]init];
    _topLineView.backgroundColor = [JYSkinManager shareSkinManager].colorForDateBg;
    [self.contentView addSubview:_topLineView];
    
    _leftLineView = [[UIView alloc]init];
    _leftLineView.backgroundColor = [JYSkinManager shareSkinManager].colorForDateBg;
    [self.contentView addSubview:_leftLineView];
    
    _rightLineView = [[UIView alloc]init];
    _rightLineView.backgroundColor = [JYSkinManager shareSkinManager].colorForDateBg;
    [self.contentView addSubview:_rightLineView];
    
    _iconView = [[UIImageView alloc]init];
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    _iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"节_%@",[JYSkinManager shareSkinManager].keywordForSkinColor]];
    [self.contentView addSubview:_iconView];
    
    _contentLabel = [[UILabel alloc]init];
    _contentLabel.font = [UIFont systemFontOfSize:14.f];
    _contentLabel.text = @"世界水日  xxxx纪念日";
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:_contentLabel];
    
    //空气指数
    CGFloat aqiHeight = 20.f;
    CGFloat aqiMinWidth = 80.f;
    _aqiLabel = [[UILabel alloc]init];
    _aqiLabel.textColor = [UIColor lightGrayColor];
    _aqiLabel.font = [UIFont systemFontOfSize:13.f];
    _aqiLabel.text = @"重度污染 1133";
    _aqiLabel.layer.cornerRadius = aqiHeight/2.f;
    _aqiLabel.layer.masksToBounds = YES;
    _aqiLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _aqiLabel.layer.borderWidth = 0.5f;
    _aqiLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_aqiLabel];

    _descLabel = [[UILabel alloc]init];
    _descLabel.font = [UIFont systemFontOfSize:12.f];
    _descLabel.text = IS_SMALL_THAN_IPHONE_6_SCREEN?@"本周天气":@"查看本周天气";
    _descLabel.textAlignment = NSTextAlignmentRight;
    _descLabel.textColor = [JYSkinManager shareSkinManager].colorForDateBg;
    [self.contentView addSubview:_descLabel];
    
    
    CGFloat horMargin = 15.f;
    CGFloat verMargin = 5.f;
    CGFloat imageWidth = 22.f;
    
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(1.f);
    }];
    [_leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(1.f);
    }];
    [_rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.contentView);
        make.width.mas_equalTo(1.f);
    }];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(horMargin);
        make.width.height.mas_equalTo(imageWidth);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(verMargin);
        make.bottom.equalTo(self.contentView).offset(-verMargin);
        make.left.equalTo(_iconView.mas_right).offset(horMargin);
        make.height.mas_greaterThanOrEqualTo(kCellNormalHeight);
    }];
    
    [_aqiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentLabel.mas_right).offset(10);
        make.height.mas_equalTo(aqiHeight);
        make.width.mas_greaterThanOrEqualTo(aqiMinWidth);
        make.centerY.equalTo(self.contentView);
    }];
   
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@(80.f));
    }];
  
}
@end
