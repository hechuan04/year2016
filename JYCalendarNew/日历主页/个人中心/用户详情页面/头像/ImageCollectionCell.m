//
//  ImageCollectionCell.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/2.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "ImageCollectionCell.h"

@implementation ImageCollectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame
{
 
    if (self = [super initWithFrame:frame]) {
        
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        self.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:_imageV];

    }
    
    return self;
}



@end
