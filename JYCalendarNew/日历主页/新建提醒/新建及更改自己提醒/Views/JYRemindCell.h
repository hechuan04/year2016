//
//  JYRemindCell.h
//  JYCalendar
//
//  Created by 吴冬 on 15/11/2.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^switchAction)(UISwitch *btn);

@interface JYRemindCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *nextLabel;

@property (strong, nonatomic)UIImageView *arrowHead;

@property (strong, nonatomic)UISwitch *switchBtn;

@property (nonatomic ,copy)switchAction switchAction;
@property (nonatomic, strong) UIView *line;



@end
