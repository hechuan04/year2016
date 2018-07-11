//
//  AddGroupCell.h
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/23.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddGroupCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (nonatomic ,assign)BOOL isSelect;

@end
