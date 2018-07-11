//
//  PersonListCell.h
//  JYCalendar
//
//  Created by 吴冬 on 15/11/23.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *personName;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *Status;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;

@end
