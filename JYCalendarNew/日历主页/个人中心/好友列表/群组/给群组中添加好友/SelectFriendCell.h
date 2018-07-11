//
//  SelectFriendCell.h
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/16.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectFriendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectView;
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic ,assign)BOOL isSelect;

@end
