//
//  PhotoHeaderView.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/3/14.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "PhotoHeaderView.h"

@implementation PhotoHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        CGFloat horMargin = 10.f;
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(horMargin, 0, frame.size.width-horMargin, frame.size.height)];
        _dateLabel.font = [UIFont systemFontOfSize:16.f];
        [self addSubview:_dateLabel];
    }
    return self;
}
@end
