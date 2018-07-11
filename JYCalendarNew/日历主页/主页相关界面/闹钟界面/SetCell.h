//
//  SetCell.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/7.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *content;
@property (strong, nonatomic)UIImageView *arrowHead;

@property (strong, nonatomic)UISwitch *switchBtn;

@property (nonatomic ,copy)void (^switchAction)(int isOn);

@end
