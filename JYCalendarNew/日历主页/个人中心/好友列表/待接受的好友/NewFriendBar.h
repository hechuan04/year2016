//
//  NewFriendBar.h
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/24.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFriendBar : UIViewController
@property (weak, nonatomic) IBOutlet UIView *myContentView;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLbael;
@property (weak, nonatomic) IBOutlet UILabel *xiaomiId;
@property (weak, nonatomic) IBOutlet UIImageView *barImage;

@property (nonatomic ,strong)FriendModel *model;

@end
