//
//  SliderBtn.m
//  POP
//
//  Created by 吴冬 on 15/10/22.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "SliderBtn.h"


@implementation SliderBtn
{
  
    BOOL _isSelect;
    CGFloat _widthForBtn;
    CGFloat _heightForBtn;
    UIButton *_sliderBtn;
    UILabel  *_labelOne;
    UILabel  *_labelTwo;
    UIView   *_viewForBg;
    UIColor  *_labelOneColor;
    UIColor  *_labelTwoColor;
}

- (instancetype)initWithView:(UIView *)superView
{

    if (self = [super init]) {
        
        [self createBtn:superView];
    }

    return self;
}

- (void)createBtn:(UIView *)superView
{

    _sliderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sliderBtn.frame = CGRectMake(100, 200, 100, 30);
    [_sliderBtn addTarget:self action:@selector(actionForBtn:) forControlEvents:UIControlEventTouchDown];
    _sliderBtn.layer.borderWidth = 1;
    _sliderBtn.layer.borderColor = [UIColor colorWithRed:255 / 255.0 green:59 / 255.0 blue:48 / 255.0 alpha:1].CGColor;
    _sliderBtn.layer.cornerRadius = 15;
    _sliderBtn.layer.masksToBounds = YES;
    //_btnForTEST.backgroundColor = [UIColor cyanColor];
    [superView addSubview:_sliderBtn];
    
    
    _labelOne = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    _labelOne.text = @"等待";
    _labelOne.textColor = [UIColor whiteColor];
    _labelOne.layer.cornerRadius = 15;
    _labelOne.layer.masksToBounds = YES;
    _labelOne.userInteractionEnabled = NO;
    _labelOne.textAlignment = NSTextAlignmentCenter;
    [_sliderBtn addSubview:_labelOne];
    
    _labelTwo = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 50, 30)];
    _labelTwo.text = @"加载";
    _labelTwo.textColor = [UIColor redColor];
    _labelTwo.layer.cornerRadius = 15;
    _labelTwo.userInteractionEnabled = NO;
    _labelTwo.layer.masksToBounds = YES;
    _labelTwo.textAlignment = NSTextAlignmentCenter;
    [_sliderBtn addSubview:_labelTwo];
    
    _viewForBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    _viewForBg.layer.cornerRadius = 15;
    _viewForBg.layer.masksToBounds = YES;
    _viewForBg.userInteractionEnabled = NO;
    _viewForBg.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:59 / 255.0 blue:48 / 255.0 alpha:1];
    [_sliderBtn insertSubview:_viewForBg belowSubview:_labelOne];

    _widthForBtn = 100;
    _heightForBtn = 30;
    _labelOneColor = [UIColor whiteColor];
    _labelTwoColor = [UIColor redColor];
}

- (void)setArrForLabelText:(NSArray *)arrForLabelText
{
   
    if (_arrForLabelText != arrForLabelText) {
        
        _arrForLabelText = arrForLabelText;
        _labelOne.text = _arrForLabelText[0];
        _labelTwo.text = _arrForLabelText[1];
        
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
  
    _labelOne.layer.cornerRadius = cornerRadius;
    _labelTwo.layer.cornerRadius = cornerRadius;
    _viewForBg.layer.cornerRadius = cornerRadius;
    _sliderBtn.layer.cornerRadius = cornerRadius;

}


- (void)setArrForLabelColor:(NSArray *)arrForLabelColor
{
    
    if (_arrForLabelColor != arrForLabelColor) {
        
        _arrForLabelColor = arrForLabelColor;
        
        _labelOne.textColor = _arrForLabelColor[0];
        _labelTwo.textColor = _arrForLabelColor[1];
        
        _labelOneColor = _arrForLabelColor[0];
        _labelTwoColor = _arrForLabelColor[1];
        
    }

}




- (void)setBgViewColor:(UIColor *)bgViewColor
{
   
    if (_bgViewColor != bgViewColor) {
        
        _bgViewColor = bgViewColor;
        _viewForBg.backgroundColor = _bgViewColor;
        
    }

}

- (void)setFontForLabel:(UIFont *)fontForLabel
{
   
    if (_fontForLabel != fontForLabel) {
        
        _fontForLabel = fontForLabel;
        
        _labelTwo.font = _fontForLabel;
        _labelOne.font = _fontForLabel;
        
    }

}

- (void)setBtnRect:(CGRect)btnRect
{
    
    _widthForBtn = btnRect.size.width;
    _heightForBtn = btnRect.size.height;

    _sliderBtn.frame = btnRect;
    _labelOne.frame = CGRectMake(0, 0, _widthForBtn / 2.0, _heightForBtn);
    _labelTwo.frame = CGRectMake(_widthForBtn / 2.0, 0, _widthForBtn / 2.0, _heightForBtn);
    _viewForBg.frame = CGRectMake(0, 0, _widthForBtn / 2.0, _heightForBtn);
    
    _isSelect = NO;
    
}


- (void)actionForBtn:(UIButton *)sender
{
    sender.userInteractionEnabled = NO;
    
    _isSelect = !_isSelect;
    
    if (_isSelect) {
        
        _labelOne.textColor = _labelTwoColor;
        
        _labelTwo.textColor = _labelOneColor;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _viewForBg.frame = CGRectMake(_widthForBtn / 2.0, 0, _widthForBtn / 2.0, _heightForBtn);
            
            
        } completion:^(BOOL finished) {
            
            sender.userInteractionEnabled = YES;
            
        }];
        
    }else{
        
        _labelOne.textColor = _labelOneColor;
        
        _labelTwo.textColor = _labelTwoColor;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            
            _viewForBg.frame = CGRectMake(0, 0, _widthForBtn / 2.0, _heightForBtn);
            
            
        } completion:^(BOOL finished) {
            
            sender.userInteractionEnabled = YES;
            
        }];
        
    }
    
    _isSelectedBlock(_isSelect);
    
}







@end
