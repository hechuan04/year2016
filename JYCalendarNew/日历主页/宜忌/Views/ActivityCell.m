//
//  ActivityCell.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/14.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "ActivityCell.h"
#import "ActivityCellBackgroundView.h"

@implementation ActivityCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self){
        [self setupSubviews];
        self.backgroundView = [[ActivityCellBackgroundView alloc]initWithFrame:frame fillColor:UIColorFromRGB(0xF0F0F0)];
        self.selectedBackgroundView = [[ActivityCellBackgroundView alloc]initWithFrame:frame fillColor:[JYSkinManager shareSkinManager].btnBackGroundColor];
    }
    return self;
}


#pragma mark - Public
- (void)setTitle:(NSString *)title
{
    self.activityLabel.text = title;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if(selected){
        self.activityLabel.textColor = [JYSkinManager shareSkinManager].colorForDateBg;
    }else{
        self.activityLabel.textColor = [UIColor blackColor];
    }
}
#pragma mark - Private
- (void)setupSubviews
{
    _activityLabel = [UILabel new];
    _activityLabel.text = @"祈福";
    _activityLabel.font = [UIFont systemFontOfSize:16.f];
    _activityLabel.backgroundColor = [UIColor clearColor];
    _activityLabel.textAlignment = NSTextAlignmentCenter;
    _activityLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_activityLabel];
   
    [_activityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}
@end
