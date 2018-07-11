//
//  NewAddFriendCell.h
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/17.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewAddFriendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *xiaomiId;
@property (weak, nonatomic) IBOutlet UILabel *tel_phone;

@property (strong, nonatomic) UIImageView *barImage;
@property (weak, nonatomic) IBOutlet UILabel *barLbael;

@property (strong, nonatomic)  UIImageView *openImage;

@property (nonatomic,strong) NSString *headUrl;
@end
