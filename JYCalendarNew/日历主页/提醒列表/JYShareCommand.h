//
//  JYShareCommand.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/11/11.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYCommand.h"


@interface JYShareCommand : JYCommand

- (JYShareCommand *)initWithFriendArr:(NSArray *)fArr
                             groupArr:(NSArray *)gArr
                              todayTb:(JYTodayListView *)todayTb
                               listTb:(JYListTableView *)listTb
                                  btn:(UIButton *)sender
                              editBtn:(UIButton *)editBtn;


@property (nonatomic ,strong)NSArray *friendArr;
@property (nonatomic ,strong)NSArray *groupArr;

@end
