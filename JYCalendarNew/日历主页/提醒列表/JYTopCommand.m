//
//  JYTopCommand.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/11/11.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYTopCommand.h"

@implementation JYTopCommand
{
    JYTodayListView *_todayTableView;
    JYListTableView *_listTableView;
    UIButton        *_editBtn;
    UIButton        *_sender;
}


- (JYTopCommand *)initWithTodayList:(JYTodayListView *)todayList
                         normalList:(JYListTableView *)normalList
                            editBtn:(UIButton *)editBtn
                                btn:(UIButton *)sender
{
    if (self = [super init]) {
        
        _todayTableView = todayList;
        _listTableView  = normalList;
        _editBtn        = editBtn;
        _sender         = sender;
    }
    
    return self;
}

- (void)execute
{
    if (_listTableView.hidden) {
        
        if (_todayTableView.selectData.count == 0) {
            
            [self showSingleAlert:@"请选择要置顶的内容"];
            return;
        }
        
        [RemindModel topAction:_todayTableView.selectData];
        
    }else{
        
        if (_listTableView.selectData.count == 0) {
            
            [self showSingleAlert:@"请选择要置顶的内容"];
            return;
        }
        
        [RemindModel topAction:_listTableView.selectData];
    }
    
    JYInvker *invker = [JYInvker shareInvker];
    [invker rollBackAll];
        
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self rollBackExecute];
}

- (void)rollBackExecute
{
    _sender.selected = NO;
}

@end
