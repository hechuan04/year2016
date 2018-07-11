//
//  FestivalCell.m
//  JYCalendarNew
//
//  Created by Gaolichao on 2016/12/7.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "FestivalCell.h"

#define kCellNormalHeight 30

@implementation FestivalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        self.backgroundColor=[UIColor clearColor];
        [self setupSubViewsWithIdentifier:reuseIdentifier];
    }
    return self;
}

- (void)showTopLine:(BOOL)show
{
    self.topLineView.hidden = !show;
}
- (void)setupSubViewsWithIdentifier:(NSString *)reuseIdentifier{
//    _topLineView = [[UIView alloc]init];
//    _topLineView.backgroundColor = [JYSkinManager shareSkinManager].colorForDateBg;
//    [self.contentView addSubview:_topLineView];
    
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
    
    _detailBtn = [[UIButton alloc]init];
    _detailBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [_detailBtn setTitle:@"详情..." forState:UIControlStateNormal];
    _detailBtn.userInteractionEnabled = NO;
    _detailBtn.contentHorizontalAlignment = NSTextAlignmentRight;
    [_detailBtn setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
    [self.contentView addSubview:_detailBtn];
    
    CGFloat horMargin = 15.f;
//    CGFloat verMargin = 5.f;
    CGFloat imageWidth = 22.f;
    CGFloat offset = 0;
    if(reuseIdentifier==kCellIdentifierFestivalTop){
        offset = 2.f;
    }else if(reuseIdentifier==kCellIdentifierFestivalBottom) {
        offset = -2.f;
    }
//    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self.contentView);
//        make.height.mas_equalTo(1.f);
//    }];
    [_leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(1.f);
    }];
    [_rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.contentView);
        make.width.mas_equalTo(1.f);
    }];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(offset);
        make.left.equalTo(self.contentView).offset(horMargin);
        make.width.height.mas_equalTo(imageWidth);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(offset);
        make.height.equalTo(@30.f);
        make.left.equalTo(_iconView.mas_right).offset(horMargin);
        make.height.mas_greaterThanOrEqualTo(kCellNormalHeight);
        
    }];
    [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(offset);
        make.right.equalTo(self.contentView).offset(-15);
        make.width.equalTo(@50);
    }];
}
@end
