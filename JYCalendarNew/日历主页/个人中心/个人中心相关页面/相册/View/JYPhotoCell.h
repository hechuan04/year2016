//
//  JYPhotoCell.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/4/22.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoItem;

@interface JYPhotoCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *photoImageView;
@property (nonatomic,strong) UIImageView *checkView;

@property (nonatomic,assign) BOOL isEditing;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,strong) PhotoItem *photoItem;

@property (nonatomic,weak) UIViewController *containerVC;

@end
