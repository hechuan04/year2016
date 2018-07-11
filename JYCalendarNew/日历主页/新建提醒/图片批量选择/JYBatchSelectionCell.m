//
//  JYBatchSelectionCell.m
//  JYCalendarNew
//
//  Created by mac on 16/3/21.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYBatchSelectionCell.h"

@implementation JYBatchSelectionCell


- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        self.backgroundColor = [UIColor orangeColor];
        _imageV.userInteractionEnabled = NO;
        [self.contentView addSubview:_imageV];
        
        _selectedBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _selectedBtn.frame = CGRectMake(self.width - 15, 1, 15, 15);
        _selectedBtn.selected = NO;
        _selectedBtn.userInteractionEnabled = NO;
        [_selectedBtn setImage:[UIImage imageNamed:@"农未选中"] forState:(UIControlStateNormal)];
        [_selectedBtn setImage:[UIImage imageNamed:@"农选中"] forState:(UIControlStateSelected)];
        [self.contentView addSubview:_selectedBtn];
        
    }
    
    return self;
}


@end
