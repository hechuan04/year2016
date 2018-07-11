//
//  FriendTableViewCell.h
//  ffff
//
//  Created by 吴冬 on 16/1/11.
//  Copyright (c) 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManagerForButton.h"

@interface FriendTableViewCell : UITableViewCell<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *friendLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userHead;

@property (weak, nonatomic) IBOutlet UIScrollView *bgScroll;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *keyBtn;

//传indexPath
@property (nonatomic ,copy)void (^actionForPushIndex)(NSIndexPath *indexPath);

//传关键人
@property (nonatomic ,copy)void (^actionForKeyPath)(FriendTableViewCell *cell);

//删除
@property (nonatomic ,copy)void (^actionForDelete)(FriendTableViewCell *cell);

@end
