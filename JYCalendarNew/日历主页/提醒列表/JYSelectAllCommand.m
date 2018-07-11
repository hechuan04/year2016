//
//  JYSelectAllCommand.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/11/10.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYSelectAllCommand.h"

@implementation JYSelectAllCommand
{
    JYTodayListView *_todayTableView;
    JYListTableView *_listTableView;
    UIButton        *_sender;
}

- (JYSelectAllCommand *)initWithTodayList:(JYTodayListView *)todayList
                               normalList:(JYListTableView *)normalList sender:(UIButton *)sender
{

    if (self = [super init]) {
        
        _todayTableView = todayList;
        _listTableView  = normalList;
        _sender         = sender;
    }

    return self;
}

- (void)execute
{
    [_todayTableView.boolDic removeAllObjects];
    [_todayTableView.selectData removeAllObjects];
    
    [_listTableView.boolDic removeAllObjects];
    [_listTableView.selectData removeAllObjects];
   
        if (_listTableView.hidden) {
            
            for (int i = 0; i < _todayTableView.todayList.count; i++) {
                
                NSString *key = [NSString stringWithFormat:@"0_%d",i];
                [_todayTableView.boolDic setObject:@(1) forKey:key];
                
                [_todayTableView.selectData addObject:_todayTableView.todayList[i]];
            }
            
            for (int i = 0; i < _todayTableView.notyetList.count; i++) {
                
                NSString *key = [NSString stringWithFormat:@"1_%d",i];
                [_todayTableView.boolDic setObject:@(1) forKey:key];
                
                [_todayTableView.selectData addObject:_todayTableView.notyetList[i]];
            }
            
            [_todayTableView reloadData];
            
        }else{
            
            for (int i = 0; i < _listTableView.showArr.count; i++) {
                
                [_listTableView.boolDic setObject:@(1) forKey:@(i)];
                
                [_listTableView.selectData addObject:_listTableView.showArr[i]];
            }
            
            [_listTableView reloadData];
        }

}

- (void)rollBackExecute
{
    [_todayTableView.boolDic removeAllObjects];
    [_todayTableView.selectData removeAllObjects];
    
    [_listTableView.boolDic removeAllObjects];
    [_listTableView.selectData removeAllObjects];
    
    [_todayTableView reloadData];
    [_listTableView reloadData];
    
    _sender.selected = NO;
}


@end
