//
//  JYTodayListCell.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/8/2.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYListTCell.h"
@interface JYTodayListCell : JYListTCell

@property (nonatomic ,strong)UIView *horizontalLine;  //横线
@property (nonatomic ,strong)UIView *erectLine; //竖线
@property (nonatomic ,strong)UILabel *timeLabel; //显示时间
@property (nonatomic ,strong)UILabel *countDownLabel; //倒计时


@property (nonatomic ,strong)UIImageView *clockImage;

@end
