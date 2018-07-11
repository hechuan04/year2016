//
//  JYRightAndWrongView.m
//  JYCalendar
//
//  Created by 吴冬 on 15/10/13.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYRightAndWrongView.h"

//frame
#define xForLunarD 56 / 750.0 * kScreenWidth
#define yForLunarD 30 / 1334.0 * kScreenHeight
#define heightForLunarD 27 / 1334.0 * kScreenHeight

#define yForRight 81 / 1334.0 * kScreenHeight

#define yForWrong 134 / 1334.0 * kScreenHeight

#define heightForRW 30 / 1334.0 * kScreenHeight

@implementation JYRightAndWrongView

- (instancetype)initWithFrame:(CGRect)frame
{
   
    if (self = [super initWithFrame:frame]) {
        
        _lunarDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(xForLunarD, yForLunarD, kScreenWidth - 100, heightForLunarD)];
        _lunarDayLabel.text = @"乙未[年]年 乙酉日 庚子时 壬午时";
        //_lunarDayLabel.backgroundColor = [UIColor colorWithRed:1.000 green:0.609 blue:0.476 alpha:1.000];
       // _lunarDayLabel.font = [UIFont systemFontOfSize:12];
        _lunarDayLabel.textColor = [UIColor grayColor];
        [self addSubview:_lunarDayLabel];
        
        _rightLabelWord = [[UILabel alloc] initWithFrame:CGRectMake(xForLunarD, yForRight, 25, heightForRW)];
        _rightLabelWord.text = @"宜";
        _rightLabelWord.textColor = [UIColor colorWithRed:2 / 255.0 green:175 / 255.0 blue:212 / 255.0 alpha:1];
        [self addSubview:_rightLabelWord];
        
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(_rightLabelWord.right , yForRight + 1, kScreenWidth, heightForLunarD)];
        _rightLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_rightLabel];
        
        _wrongLabelWord = [[UILabel alloc] initWithFrame:CGRectMake(xForLunarD, yForWrong, 25, heightForRW)];
        _wrongLabelWord.text = @"忌";
        _wrongLabelWord.textColor = [UIColor redColor];
        [self addSubview:_wrongLabelWord];
        
        _wrongLabel = [[UILabel alloc] initWithFrame:CGRectMake(_wrongLabelWord.right , yForWrong + 1, kScreenWidth, heightForLunarD)];
        _wrongLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_wrongLabel];
   
    }
    
    return self;
}

@end
