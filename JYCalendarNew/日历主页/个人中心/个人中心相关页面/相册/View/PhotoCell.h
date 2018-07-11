//
//  PhotoCell.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/3/14.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDPhotoBrowser.h"
@class PhotoItem;

@interface PhotoCell : UICollectionViewCell<SDPhotoBrowserDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UIImageView *photoImageView;
@property (nonatomic,strong) UIButton *deleteButton;

@property (nonatomic,assign) BOOL isEditing;
@property (nonatomic,strong) PhotoItem *photoItem;
@property (nonatomic,copy) void (^deleteActionBlock)();

@property (nonatomic,weak) UIViewController *containerVC;

@end
