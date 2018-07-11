//
//  ScanFileCell.m
//  ScanDemo
//
//  Created by Gaolichao on 16/5/26.
//  Copyright © 2016年 Test. All rights reserved.
//

#import "ScanFileCell.h"
#import "Masonry.h"
#import "ScanUtil.h"
#import "UIImageView+WebCache.h"

@implementation ScanFileCell

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self){
        [self setupSubviews];
    }
    return self;
}


#pragma mark - Public


#pragma mark - Private
- (void)setupSubviews
{
    
    _coverView = [[UIImageView alloc]init];
    _coverView.image = [UIImage imageNamed:@"相册默认图片"];
    _coverView.contentMode = UIViewContentModeScaleAspectFill;
    _coverView.clipsToBounds = YES;
    _coverView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _coverView.layer.borderWidth = 0.5f;
    [self.contentView addSubview:_coverView];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"田田的旅行";
    _titleLabel.font = [UIFont systemFontOfSize:13.f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
    
    _dateLabel = [UILabel new];
    _dateLabel.text = @"05/23/15:30";
    _dateLabel.font = [UIFont systemFontOfSize:13.f];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_dateLabel];
    
    
    _checkView = [UIImageView new];
    _checkView.contentMode = UIViewContentModeScaleAspectFill;
    [_checkView setImage:[UIImage imageNamed:@"扫描_未选中"]];
    [self.contentView addSubview:_checkView];
    _checkView.alpha = 0;

    
    CGFloat titleHeight = 18.f;
    CGFloat dateHeight = 16.f;
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_coverView.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@(titleHeight));
    }];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@(dateHeight));
        make.top.equalTo(_titleLabel.mas_bottom);
    }];
    [_checkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@25.f);
        make.top.equalTo(self.contentView).offset(5.f);
        make.right.equalTo(self.contentView).offset(-5.f);
    }];
    
   
}
#pragma mark - Custom Accessors
- (void)setFile:(ScanFile *)file
{
    _file = file;
    _titleLabel.text = file.name;
    _dateLabel.text = [[ScanUtil sharedInstance].dateFormatterForDirectoryCell stringFromDate:file.createdTime];
    
    if(file.type==1){
        _coverView.image = [UIImage imageNamed:@"text_placeholder"];
        
    }else if(file.type==0){
        [_coverView sd_setImageWithURL:[NSURL URLWithString:file.imageUrlStr] placeholderImage:[UIImage imageNamed:@"相册默认图片"]];
    }
}
- (void)setIsEditing:(BOOL)isEditing{
    _isEditing = isEditing;
    _checkView.alpha = _isEditing?1:0;
}
- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if(isSelected){
        [_checkView setImage:[UIImage imageNamed:@"扫描_选中"]];
    }else{
        [_checkView setImage:[UIImage imageNamed:@"扫描_未选中"]];
    }
}
@end
