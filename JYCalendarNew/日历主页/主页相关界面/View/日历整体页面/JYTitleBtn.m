//
//  JYTitleBtn.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/4/13.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYTitleBtn.h"

@implementation JYTitleBtn

- (instancetype)initWithFrame:(CGRect)frame
                     andTitle:(NSString *)title
{
 
    if (self = [super initWithFrame:frame]) {
        
        _calendarTitle = [UILabel new];
        _calendarTitle.text = title;
        _calendarTitle.textAlignment = NSTextAlignmentCenter;
        _calendarTitle.font = [UIFont systemFontOfSize:20];
        //_calendarTitle.backgroundColor = [UIColor orangeColor];
        [self addSubview:_calendarTitle];
        
        [_calendarTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        UIButton *selectDay = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectDay setImage:[UIImage imageNamed:@"下拉框.png"] forState:UIControlStateNormal];
        [self addSubview:selectDay];
        
        
        [selectDay mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_calendarTitle.mas_right);
            make.centerY.equalTo(self.mas_centerY).offset(1.f);
            make.width.mas_equalTo(28.f);
            make.height.mas_equalTo(14.f);
            
        }];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:self.bounds];
        [btn addTarget:self action:@selector(selectDay) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
    }
    
    return self;
}

//选择天数
- (void)selectDay
{
    _selectCalendarBlock();
    NSLog(@"hahaha");
}

@end
