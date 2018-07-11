//
//  YiJiCell.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/14.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "YiJiCell.h"

#define kCellNormalHeight (IS_BIG_THAN_IPHONE_6_SCREEN?90:(IS_SMALL_THAN_IPHONE_6_SCREEN?70.f:80.f)/ 1334.0 * kScreenHeight)

@implementation YiJiCell

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
    
    _yiIconView = [[UIImageView alloc]init];
    _yiIconView.contentMode = UIViewContentModeScaleAspectFit;
    _yiIconView.image = [UIImage imageNamed:@"宜字"];
    [self.contentView addSubview:_yiIconView];
    
    _jiIconView = [[UIImageView alloc]init];
    _jiIconView.contentMode = UIViewContentModeScaleAspectFit;
    _jiIconView.image = [UIImage imageNamed:@"忌字"];
    [self.contentView addSubview:_jiIconView];
    
    _yiContentLabel = [[UILabel alloc]init];
    _yiContentLabel.font = [UIFont systemFontOfSize:14.f];
    _yiContentLabel.text = @"祈福 祭祀 结亲 开市 交易";
    _yiContentLabel.numberOfLines = 0;
    _yiContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:_yiContentLabel];
    
    _jiContentLabel = [[UILabel alloc]init];
    _jiContentLabel.font = [UIFont systemFontOfSize:14.f];
    _jiContentLabel.text = @"祈福 祭祀 结亲 开市 交易";
    _jiContentLabel.numberOfLines = 0;
    _jiContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:_jiContentLabel];

    
    _qianImageView = [[UIImageView alloc]init];
    _qianImageView.contentMode = UIViewContentModeScaleAspectFit;
    _qianImageView.image = [UIImage imageNamed:@"观音签"];
    [self.contentView addSubview:_qianImageView];
    
    _qianImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapQian:)];
    [_qianImageView addGestureRecognizer:tap];
    
    CGFloat horMargin = 15.f;
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
    [_yiIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.yiContentLabel.mas_centerY);
        make.left.equalTo(self.contentView).offset(horMargin);
        make.width.height.mas_equalTo(imageWidth);
    }];
    
    [_yiContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.height.mas_greaterThanOrEqualTo(40.f);
        make.left.equalTo(_yiIconView.mas_right).offset(horMargin);
    }];
    
    [_jiIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.jiContentLabel.mas_centerY);
        make.left.equalTo(self.contentView).offset(horMargin);
        make.width.height.mas_equalTo(imageWidth);
    }];
    
    [_jiContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.yiContentLabel.mas_bottom);
        make.bottom.equalTo(self.contentView);
        make.height.mas_greaterThanOrEqualTo(30.f);
        make.left.equalTo(_jiIconView.mas_right).offset(horMargin);
    }];
    
    [_qianImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(IS_SMALL_THAN_IPHONE_6_SCREEN?-horMargin:-horMargin*3);
        make.centerY.equalTo(self.contentView).offset(5.f);
        make.size.mas_equalTo(CGSizeMake(30, 50));
    }];
    
  }

- (void)tapQian:(UITapGestureRecognizer *)sender
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/guan-yin-qian-shang-xiang/id992045925?l=en&mt=8"]];
}

@end
