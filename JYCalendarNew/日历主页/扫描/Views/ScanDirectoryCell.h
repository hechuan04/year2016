//
//  ScanDirectoryCell.h
//  ScanDemo
//
//  Created by Gaolichao on 16/5/16.
//  Copyright © 2016年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanDirectory.h"
#import "ScanFileCell.h"

@interface ScanDirectoryCell : ScanFileCell

@property (nonatomic,strong) UIButton *countInfoView;

@property (nonatomic,strong) ScanDirectory *directory;

@end
