//
//  JYSelectAllCommand.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/11/10.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYCommand.h"


@interface JYSelectAllCommand : JYCommand

- (JYSelectAllCommand *)initWithTodayList:(JYTodayListView *)todayList
                               normalList:(JYListTableView *)normalList sender:(UIButton *)sender;
@end
