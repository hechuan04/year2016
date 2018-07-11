//
//  JYShareCommand.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/11/11.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYShareCommand.h"

@implementation JYShareCommand
{
    NSArray *_friendArr;
    NSArray *_groupArr;
    JYTodayListView *_todayTableView;
    JYListTableView *_listTableView;
    UIButton        *_sender;
    UIButton        *_editBtn;
}


- (JYShareCommand *)initWithFriendArr:(NSArray *)fArr
                             groupArr:(NSArray *)gArr
                              todayTb:(JYTodayListView *)todayTb
                               listTb:(JYListTableView *)listTb
                                  btn:(UIButton *)sender
                              editBtn:(UIButton *)editBtn
{
    if (self = [super init]) {
        
        _friendArr = fArr;
        _groupArr  = gArr;
        
        _todayTableView = todayTb;
        _listTableView  = listTb;
        
        _sender = sender;
        _editBtn = editBtn;
        
    }
    
    return self;
}

- (void)execute
{
    if (_friendArr.count == 0 && _groupArr.count == 0) {
        [self showSingleAlert:@"请先点击➕选择共享人"];
        return;
    }
    
    
    if (_listTableView.hidden) {
        
        if (_todayTableView.selectData.count == 0) {
            [self showSingleAlert:@"请选择需要共享的提醒"];
            return;
        }
        
        [RemindModel shareWithFriendArr:_friendArr groupArr:_groupArr model:_todayTableView.selectData headStr:@""];
        
    }else{
        
        if (_listTableView.selectData.count == 0) {
            [self showSingleAlert:@"请选择需要共享的提醒"];
            return;
        }
        
        [RemindModel shareWithFriendArr:_friendArr groupArr:_groupArr model:_listTableView.selectData headStr:@""];
    }
    
    if (self.commandComplete) {
        self.commandComplete();
    }
    
    _friendArr = @[];
    _groupArr = @[];
    
    JYInvker *invker = [JYInvker shareInvker];
    [invker rollBackAll];
   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self _rollBack];
}

- (void)_rollBack
{
    if (_friendArr.count >0 || _groupArr.count > 0) {
        _sender.selected = YES;
    }else{
        _sender.selected = NO;
    }
}

- (void)rollBackExecute
{
    _sender.selected = NO;
    _friendArr = @[];
    _groupArr = @[];
}

@end
