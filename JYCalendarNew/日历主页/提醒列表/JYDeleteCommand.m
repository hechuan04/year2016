//
//  JYDeleteCommand.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/11/10.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYDeleteCommand.h"
#import <objc/runtime.h>

const void *deleteAction = @"deleteAction";

@implementation JYDeleteCommand
{
    JYTodayListView *_todayTableView;
    JYListTableView *_listTableView;
    RemindModel     *_model;
    UIButton        *_sender;
    UIButton        *_editBtn;
}

- (JYDeleteCommand *)initWithSingleDelete:(RemindModel *)model editBtn:(UIButton *)editBtn
{
    if (self = [super init]) {
        
        _model = model;
        _editBtn = editBtn;
    }
    
    return self;
}

- (JYDeleteCommand *)initWithTodayList:(JYTodayListView *)todayList
                               normalList:(JYListTableView *)normalList
                                   btn:(UIButton *)sender
                               editBtn:(UIButton *)editBtn
{
    
    if (self = [super init]) {
        
        _todayTableView = todayList;
        _listTableView = normalList;
        
        _sender = sender;
        _editBtn = editBtn;
    }
    
    return self;
}

- (void)execute
{
    if (_model) {
        
        [self confirmDeleteSingle:_model];
   
    }else{
        
        if (_listTableView.hidden) {
            
            if (_todayTableView.selectData.count == 0) {
                [self showAlert:@"请选择要删除的条目"];
                return;
            }
            
            [self confirmDelete:_todayTableView.selectData];
            
        }else{
            
            if (_listTableView.selectData.count == 0) {
                [self showAlert:@"请选择要删除的条目"];
                return;
            }
            
            [self confirmDelete:_listTableView.selectData];
            
        }
    }

}

//提示框（single）
- (void)confirmDeleteSingle:(RemindModel *)model
{
        void (^deleteBlock)() = ^{
            [RemindModel deleteWithModel:model];
            [[JYInvker shareInvker] rollBack];

        };
    
        UIAlertView *alert = [self showAlert:@"您确定删除提醒吗？删除之后无法恢复"];
    
        objc_setAssociatedObject(alert, deleteAction, deleteBlock, OBJC_ASSOCIATION_COPY);
}

//提示框
- (void)confirmDelete:(NSArray *)arr
{
    void (^deleteBlock)() = ^{
        [RemindModel deleteMoreModel:arr];
        [[JYInvker shareInvker] rollBackAll];
    };
    
    UIAlertView *alert = [self showAlert:@"您确定删除提醒吗？删除之后无法恢复"];
    
    objc_setAssociatedObject(alert, deleteAction, deleteBlock, OBJC_ASSOCIATION_COPY);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
        void (^deleteBlock)() = objc_getAssociatedObject(alertView, deleteAction);
    
        if (buttonIndex == 0) {
    
            if (deleteBlock) {
                deleteBlock();
            }
        }
    if (_model) {
        [[JYInvker shareInvker] rollBack];
    }else{
        [self rollBackExecute];
    }
}

- (void)rollBackExecute
{
    _sender.selected = NO;
}

@end
