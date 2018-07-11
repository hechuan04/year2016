//
//  AddOtherCell.h
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/18.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddOtherCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic)UILabel *timeLabel;
@property (strong, nonatomic)UISwitch *switchBtn;
@property (nonatomic ,copy)void (^actionForPassOpenOrClose)(int);

@property (nonatomic ,strong)UIImageView *arrowHead;
@property (nonatomic, strong) UIView *line;
@end
