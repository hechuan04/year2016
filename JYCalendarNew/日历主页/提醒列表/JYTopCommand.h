//
//  JYTopCommand.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/11/11.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYCommand.h"

@interface JYTopCommand : JYCommand

- (JYTopCommand *)initWithTodayList:(JYTodayListView *)todayList
                         normalList:(JYListTableView *)normalList
                            editBtn:(UIButton *)editBtn
                                btn:(UIButton *)sender;

@end
