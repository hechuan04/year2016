//
//  FriendCell.m
//  JYCalendarNew
//
//  Created by Gaolichao on 2016/11/23.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "FriendCell.h"

@implementation FriendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *selectedBackgroundView = [[UIView alloc] init];
        selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        [self setupSubViews];
        
    }
    return  self;
}

- (void)setupSubViews
{
    CGFloat horMargin = 14.f;
    CGFloat imageWidth = 40.f;
    
    _headImageView = [UIImageView new];
    _headImageView.contentMode = UIViewContentModeScaleAspectFit;
    _headImageView.image = [UIImage imageNamed:@"默认用户头像"];
    _headImageView.layer.cornerRadius = imageWidth/2.f;
    _headImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_headImageView];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:16.f];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_nameLabel];
    
    _bottomLineView = [UIView new];
    _bottomLineView.backgroundColor = UIColorFromRGB(0xcccccc);
    [self addSubview:_bottomLineView];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.height.width.equalTo(@(imageWidth));
        make.left.equalTo(self.contentView).offset(horMargin);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.headImageView.mas_right).offset(horMargin);
        make.right.equalTo(self.contentView.mas_right).offset(-horMargin);
    }];
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(0.5));
    }];
}

- (void)setHeadUrl:(NSString *)headUrlStr name:(NSString *)name
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:headUrlStr] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
    self.nameLabel.text = name;
    
}
- (void)setImage:(UIImage *)image title:(NSString *)title
{
    self.headImageView.image = image;
    self.nameLabel.text = title;
}
@end
