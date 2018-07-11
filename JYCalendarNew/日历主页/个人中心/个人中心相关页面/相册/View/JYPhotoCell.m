//
//  JYPhotoCell.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/4/22.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYPhotoCell.h"

#import "PhotoItem.h"

#define kDeleteBtnWidth 25.f
#define kImageViewInitMargin 0.f
@implementation JYPhotoCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        
        _photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kImageViewInitMargin,kImageViewInitMargin,width-kImageViewInitMargin*2,height-kImageViewInitMargin*2)];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.clipsToBounds = YES;
        [self.contentView addSubview:_photoImageView];
        
        _checkView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,kDeleteBtnWidth,kDeleteBtnWidth)];
        _checkView.contentMode = UIViewContentModeScaleAspectFill;
        [_checkView setImage:[UIImage imageNamed:@"农未选中"]];
        [self.contentView addSubview:_checkView];
        _checkView.alpha = 0;
        
    }
    return self;
}
- (void)setIsEditing:(BOOL)isEditing{
    _isEditing = isEditing;
    _checkView.alpha = _isEditing?1:0;
}
- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if(isSelected){
        [_checkView setImage:[UIImage imageNamed:@"农选中"]];
    }else{
        [_checkView setImage:[UIImage imageNamed:@"农未选中"]];
    }
}
- (void)setPhotoItem:(PhotoItem *)photoItem{
    _photoItem = photoItem;
    if(photoItem.isSelected){
        [_checkView setImage:[UIImage imageNamed:@"农选中"]];
    }else{
        [_checkView setImage:[UIImage imageNamed:@"农未选中"]];
    }

    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:photoItem.photoUrl] placeholderImage:[UIImage imageNamed:@"相册默认图片"]];
}
@end
