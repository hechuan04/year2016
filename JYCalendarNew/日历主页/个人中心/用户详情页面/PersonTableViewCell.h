//
//  PersonTableViewCell.h
//  JYCalendar
//
//  Created by 吴冬 on 15/11/19.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonTableViewCell : UITableViewCell
@property (strong, nonatomic)  UILabel *userTitle;
@property (strong, nonatomic)  UIImageView *userHead;
@property (strong, nonatomic)  UILabel *userNumber;
@property (nonatomic ,strong)  UIImageView *imageForJiantou;


@end
