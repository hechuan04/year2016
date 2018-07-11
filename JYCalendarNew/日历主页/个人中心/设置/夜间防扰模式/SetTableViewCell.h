//
//  SetTableViewCell.h
//  JYCalendar
//
//  Created by 吴冬 on 15/10/22.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderBtn.h"


typedef void(^isDistrub)(BOOL isDistrub);

@interface SetTableViewCell : UITableViewCell

@property (strong, nonatomic)UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (strong, nonatomic)UISwitch *switchBtn;
@property (strong, nonatomic)UIImageView *titleImage;

@property (nonatomic ,strong)UIImageView *trigonometryImage;

@property (nonatomic ,assign)BOOL isOpen;

@property (nonatomic ,copy)isDistrub isDistrubation;

@end
