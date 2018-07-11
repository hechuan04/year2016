//
//  ClockCell.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/4.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClockCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;

@property (nonatomic ,copy)void (^passModel)(ClockCell *cell,BOOL isOn);

@end
