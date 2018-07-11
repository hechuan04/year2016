//
//  WeekCell.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/7.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UIImageView *SelectImage;

@property (nonatomic ,assign)BOOL isSelect;

@end
