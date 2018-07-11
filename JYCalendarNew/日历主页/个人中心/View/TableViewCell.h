//
//  TableViewCell.h
//  JYCalendar
//
//  Created by 吴冬 on 15/11/19.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userHead;
@property (weak, nonatomic) IBOutlet UILabel *userName;


@property (weak, nonatomic) IBOutlet UILabel *userNumber;
@property (strong, nonatomic)UIImageView *imageForSet;
@property (strong, nonatomic)UILabel *setLabel;
@property (weak, nonatomic) IBOutlet UIImageView *barImage;

@property (nonatomic ,strong)UIImageView *imageForJiantou;

@end
