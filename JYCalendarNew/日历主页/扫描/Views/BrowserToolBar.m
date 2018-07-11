//
//  BrowserToolBar.m
//  ScanDemo
//
//  Created by Gaolichao on 16/5/19.
//  Copyright © 2016年 Test. All rights reserved.
//

#import "BrowserToolBar.h"



@implementation BrowserToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupSubViewsInRect:frame];
    }
    return self;
}

- (void)setupSubViewsInRect:(CGRect)rect
{
    _backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0,-10,rect.size.width,rect.size.height)];
    _backgroundView.backgroundColor = [UIColor clearColor];
    _backgroundView.image = [UIImage imageNamed:@"tab_bg_all"];
    [self addSubview:_backgroundView];
    
    _toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [self addSubview:_toolBar];
    

    [_toolBar addSubview:self.takePhotoButton];
    
    UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(20,10,50,30)];
    [shareButton setTitle:@"传送" forState:UIControlStateNormal];
    shareButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [shareButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    UIImage *img = [UIImage imageNamed:@"扫描_传送"];
    shareButton.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
    [shareButton setImage:[img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    shareButton.titleEdgeInsets = UIEdgeInsetsMake(0,-img.size.width,-img.size.height, 0);
    shareButton.imageEdgeInsets = UIEdgeInsetsMake(-shareButton.titleLabel.intrinsicContentSize.height-10, 0, 0, -shareButton.titleLabel.intrinsicContentSize.width);
    shareButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    shareButton.hidden = YES;
    [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [_toolBar addSubview:shareButton];
//    self.shareButton = shareButton;
    
//    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_toolBar).offset(20.f);
//        make.centerY.equalTo(_toolBar);
//        make.height.equalTo(@(50.f));
//    }];
    
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(20,10,50,30)];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
    img = [UIImage imageNamed:@"扫描_删除_红"];
    deleteButton.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
    [deleteButton setImage:[img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    deleteButton.titleEdgeInsets = UIEdgeInsetsMake(0,-img.size.width,-img.size.height, 0);
    deleteButton.imageEdgeInsets = UIEdgeInsetsMake(-deleteButton.titleLabel.intrinsicContentSize.height-10, 0, 0, -deleteButton.titleLabel.intrinsicContentSize.width);
    deleteButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [deleteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar addSubview:deleteButton];
    deleteButton.hidden = YES;
    self.deleteButton = deleteButton;
    
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_toolBar).offset(-20.f);
        make.centerY.equalTo(_toolBar);
        make.height.equalTo(@(50.f));
    }];
}

- (void)shareButtonClicked:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(browserTollBar:shareButtonClicked:)]){
        [self.delegate browserTollBar:self shareButtonClicked:sender];
    }
}
- (void)deleteButtonClicked:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(browserTollBar:deleteButtonClicked:)]){
        [self.delegate browserTollBar:self deleteButtonClicked:sender];
    }
}
- (void)centerTabButtonClicked:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(browserTollBar:takePhotoButtonClicked:)]){
        [self.delegate browserTollBar:self takePhotoButtonClicked:sender];
    }
}

#pragma mark - Custom Accessors
- (UIButton *)takePhotoButton{
    if(!_takePhotoButton){
        UIImage *addImg = [UIImage imageNamed:@"相机"];
        CGFloat btnWidth = 50.f;
        _takePhotoButton = [[UIButton alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-btnWidth)/2.f,-4.f, btnWidth, btnWidth)];
        _takePhotoButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        [_takePhotoButton setImage:[addImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _takePhotoButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _takePhotoButton.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
        _takePhotoButton.layer.borderColor = [JYSkinManager shareSkinManager].colorForDateBg.CGColor;
        _takePhotoButton.layer.borderWidth = 0.5f;
        _takePhotoButton.layer.cornerRadius = btnWidth/2.f;
        _takePhotoButton.layer.masksToBounds = YES;
        _takePhotoButton.adjustsImageWhenHighlighted = NO;
        [_takePhotoButton addTarget:self action:@selector(centerTabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _takePhotoButton;
}
@end
