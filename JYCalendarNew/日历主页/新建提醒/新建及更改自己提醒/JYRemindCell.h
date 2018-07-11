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

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *nextLabel;

@property (strong, nonatomic)UIImageView *arrowHead;

@property (strong, nonatomic)UISwitch *switchBtn;

@property (nonatomic ,copy)switchAction switchAction;



@end
