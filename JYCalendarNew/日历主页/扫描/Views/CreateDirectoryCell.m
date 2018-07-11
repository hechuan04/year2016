//
//  CreateDirectoryCell.m
//  ScanDemo
//
//  Created by Gaolichao on 16/5/26.
//  Copyright © 2016年 Test. All rights reserved.
//

#import "CreateDirectoryCell.h"
#import "Masonry.h"

@implementation CreateDirectoryCell

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
    //虚线框
    _dashEdgeView = [DashEdgeView new];
    _dashEdgeView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_dashEdgeView];
    
    //小文件夹视图
    _coverView = [[UIImageView alloc]init];
    _coverView.image = [UIImage imageNamed:@"新建文件夹"];
    _coverView.contentMode = UIViewContentModeScaleAspectFit;
    _coverView.clipsToBounds = YES;
    [self.dashEdgeView addSubview:_coverView];

    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"新建文件夹";
    _titleLabel.font = [UIFont systemFontOfSize:13.f];
    _titleLabel.textColor = [UIColor lightGrayColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
    
    CGFloat titleHeight = 34.f;
   
    [_dashEdgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.titleLabel.mas_top);
    }];
    [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.dashEdgeView);
        make.width.height.equalTo(@(45.f));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.equalTo(@(titleHeight));
    }];
    
}
@end
