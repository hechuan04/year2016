//
//  SkinCell.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/19.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkinCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;
@property (weak, nonatomic) IBOutlet UIView *selectColor;
@property (weak, nonatomic) IBOutlet UILabel *selectText;
@property (weak, nonatomic) IBOutlet UILabel *selectLabel;

@end
