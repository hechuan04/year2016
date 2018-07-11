//
//  JYAwaitTableViewCell.h
//  JYCalendar
//
//  Created by 吴冬 on 15/11/5.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYAwaitTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *centerClock;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *centerOtherClock;

@property (weak, nonatomic) IBOutlet UIImageView *selectImage;

@property (weak, nonatomic) IBOutlet UIImageView *clockImage;

@property (weak, nonatomic) IBOutlet UIImageView *otherClock;

@property (nonatomic ,strong)UILabel *timeAndCount;
@property (nonatomic ,strong)UIImageView *markImage;

@property (nonatomic ,assign)BOOL isSelect;

@end
