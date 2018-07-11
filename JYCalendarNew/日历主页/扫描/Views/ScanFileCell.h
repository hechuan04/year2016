//
//  ScanFileCell.h
//  ScanDemo
//
//  Created by Gaolichao on 16/5/26.
//  Copyright © 2016年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanFile.h"

@interface ScanFileCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *coverView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UIImageView *checkView;

@property (nonatomic,strong) ScanFile *file;
@property (nonatomic,assign) BOOL isEditing;
@property (nonatomic,assign) BOOL isSelected;

@end
