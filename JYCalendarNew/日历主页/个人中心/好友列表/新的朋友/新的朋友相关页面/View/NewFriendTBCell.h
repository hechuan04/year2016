//
//  NewFriendTBCell.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/1/13.
//  Copyright (c) 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFriendTBCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userHead;
@property (weak, nonatomic) IBOutlet UILabel *friendLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (nonatomic ,copy)void (^actionForPassCell)(NewFriendTBCell *cell);
@property (nonatomic ,assign)BOOL canBind;

@end
