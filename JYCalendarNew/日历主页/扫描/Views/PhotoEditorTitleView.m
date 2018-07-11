//
//  PhotoEditorTitleView.m
//  ScanDemo
//
//  Created by Gaolichao on 16/5/31.
//  Copyright © 2016年 Test. All rights reserved.
//

#import "PhotoEditorTitleView.h"
#import "Masonry.h"


@implementation PhotoEditorTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        CGFloat pullDownWidth = 35.f;
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        
        _titleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width-pullDownWidth, height)];
        [_titleButton setTitle:@"" forState:UIControlStateNormal];
        _titleButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
        _titleButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_titleButton setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [_titleButton addTarget:self action:@selector(titleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_titleButton];
        
        _pullDownButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_titleButton.frame), 0, pullDownWidth, height)];
        [_pullDownButton setImage:[UIImage imageNamed:@"尺寸下拉"] forState:UIControlStateNormal];
        [_pullDownButton addTarget:self action:@selector(pullDownButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_pullDownButton];
        
        [_titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.lessThanOrEqualTo(@(width-pullDownWidth*2));
            make.left.greaterThanOrEqualTo(self.mas_left);
            make.centerY.equalTo(self);
            make.centerX.equalTo(self);
        }];
        [_pullDownButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(pullDownWidth));
            make.left.equalTo(_titleButton.mas_right);
            make.centerY.equalTo(self);
        }];
        
    }
    return self;
}
#pragma mark - Event Handler
- (void)pullDownButtonClicked:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(pullDownButtonClicked:)]){
        [self.delegate pullDownButtonClicked:self];
    }

}
- (void)titleButtonClicked:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(titleButtonClicked:)]){
        [self.delegate titleButtonClicked:self];
    }
}

#pragma mark - Getter and Setter

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    
    [self.titleButton setTitle:title forState:UIControlStateNormal];
}
- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    [self.titleButton setTitleColor:titleColor forState:UIControlStateNormal];
}
- (void)setImage:(UIImage *)image
{
    _image = image;
    [self.pullDownButton setImage:image forState:UIControlStateNormal];
}
@end
