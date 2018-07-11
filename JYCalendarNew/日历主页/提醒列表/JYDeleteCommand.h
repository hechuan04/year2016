//
//  JYDeleteCommand.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/11/10.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYCommand.h"


@interface JYDeleteCommand : JYCommand<UIAlertViewDelegate>


- (JYDeleteCommand *)initWithTodayList:(JYTodayListView *)todayList
                            normalList:(JYListTableView *)normalList
                                   btn:(UIButton *)sender
                               editBtn:(UIButton *)editBtn;


- (JYDeleteCommand *)initWithSingleDelete:(RemindModel *)model editBtn:(UIButton *)editBtn;

@end
