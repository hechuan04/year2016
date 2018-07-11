//
//  JYRightAndWrongView.h
//  JYCalendar
//
//  Created by 吴冬 on 15/10/13.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYRightAndWrongView : UIView

//阴历
@property (nonatomic ,strong)UILabel *lunarDayLabel;
//宜
@property (nonatomic ,strong)UILabel *rightLabel;
@property (nonatomic ,strong)UILabel *rightLabelWord;

//忌
@property (nonatomic ,strong)UILabel *wrongLabel;
@property (nonatomic ,strong)UILabel *wrongLabelWord;

@end
